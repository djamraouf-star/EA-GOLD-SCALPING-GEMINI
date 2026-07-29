//+------------------------------------------------------------------+
//|                                              PositionManager.mqh |
//+------------------------------------------------------------------+
#ifndef POSITIONMANAGER_MQH
#define POSITIONMANAGER_MQH

#include "../Core/Context.mqh"
#include "../Config/Parameters.mqh"
#include "../Risk/BreakEven.mqh"
#include "../Risk/TrailingStop.mqh"
#include "OrderManager.mqh"
#include "../Statistics/Logger.mqh"

class CPositionManager
{
public:
   void ManagePositions(const CMarketContext &ctx, const CParameters &params, COrderManager &orderMgr, CLogger &logger)
   {
      for(int i = PositionsTotal() - 1; i >= 0; i--) {
         ulong ticket = PositionGetTicket(i);
         if(ticket <= 0) continue;

         if(PositionGetString(POSITION_SYMBOL) != ctx.m_symbol) continue;
         if(PositionGetInteger(POSITION_MAGIC) != params.m_magicNumber) continue;

         ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
         double currentSL = PositionGetDouble(POSITION_SL);
         double currentTP = PositionGetDouble(POSITION_TP);
         double volume    = PositionGetDouble(POSITION_VOLUME);

         double point = SymbolInfoDouble(ctx.m_symbol, SYMBOL_POINT);
         if(point <= 0) continue;

         double profitPoints = (type == POSITION_TYPE_BUY) ? (ctx.m_bid - openPrice) / point
                                                           : (openPrice - ctx.m_ask) / point;

         if(params.m_enablePartialClose && currentTP > 0) {
            double tp1DistancePoints = (ctx.m_atr * params.m_tp1AtrMultiplier) / point;
            if(profitPoints >= tp1DistancePoints && volume > 0.01) {
               double closeVol = NormalizeDouble(volume * (params.m_partialClosePercent / 100.0), 2);
               if(closeVol >= 0.01) {
                  logger.Log("TRADE", "PositionManager", StringFormat("TP1 atteint sur ticket #%d. Clôture partielle de %.2f Lots", ticket, closeVol));
                  if(orderMgr.ClosePartial(ticket, closeVol, logger)) {
                     double beSL = CBreakEven::CalculateBreakEvenPrice(type, openPrice, currentSL, params, ctx.m_symbol);
                     orderMgr.ModifySLTP(ticket, beSL, 0, logger);
                     currentSL = beSL;
                  }
               }
            }
         }

         if(params.m_enableBreakEven) {
            double beTriggerPoints = (ctx.m_atr * params.m_breakEvenAtrTrigger) / point;
            if(profitPoints >= beTriggerPoints) {
               double newSL = CBreakEven::CalculateBreakEvenPrice(type, openPrice, currentSL, params, ctx.m_symbol);
               if(newSL != currentSL) {
                  logger.Log("TRADE", "PositionManager", StringFormat("Activation BreakEven sur ticket #%d: Nouveau SL = %.2f", ticket, newSL));
                  orderMgr.ModifySLTP(ticket, newSL, currentTP, logger);
                  currentSL = newSL;
               }
            }
         }

         if(params.m_enableTrailingStop) {
            double trailSL = CTrailingStop::CalculateTrailingSL(type, openPrice, currentSL, ctx, params);
            if(trailSL != currentSL) {
               logger.Log("TRADE", "PositionManager", StringFormat("Mise à jour Trailing Stop ticket #%d: Nouveau SL = %.2f", ticket, trailSL));
               orderMgr.ModifySLTP(ticket, trailSL, currentTP, logger);
            }
         }
      }
   }
};

#endif
