//+------------------------------------------------------------------+
//|                                                 TrailingStop.mqh |
//+------------------------------------------------------------------+
#ifndef TRAILINGSTOP_MQH
#define TRAILINGSTOP_MQH

#include "../Core/Context.mqh"
#include "../Config/Parameters.mqh"
#include "../Utils/PriceUtils.mqh"

class CTrailingStop
{
public:
   static double CalculateTrailingSL(ENUM_POSITION_TYPE type, double openPrice, double currentSL, const CMarketContext &ctx, const CParameters &params)
   {
      double point = SymbolInfoDouble(ctx.m_symbol, SYMBOL_POINT);
      if(point <= 0) return currentSL;

      double trailStartPoints = (ctx.m_atr * params.m_trailingStartAtr) / point;
      double trailStepPoints  = (ctx.m_atr * params.m_trailingStepAtr)  / point;

      double profitPoints = (type == POSITION_TYPE_BUY) ? (ctx.m_bid - openPrice) / point
                                                        : (openPrice - ctx.m_ask) / point;

      if(profitPoints >= trailStartPoints) {
         double targetSL = (type == POSITION_TYPE_BUY) ? ctx.m_bid - (trailStepPoints * point)
                                                       : ctx.m_ask + (trailStepPoints * point);

         bool modify = (type == POSITION_TYPE_BUY) ? (targetSL > currentSL + (5 * point))
                                                   : (currentSL == 0 || targetSL < currentSL - (5 * point));

         if(modify) {
            return CPriceUtils::NormalizePrice(ctx.m_symbol, targetSL);
         }
      }

      return currentSL;
   }
};

#endif
