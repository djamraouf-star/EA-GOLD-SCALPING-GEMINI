//+------------------------------------------------------------------+
//|                                                  RiskManager.mqh |
//+------------------------------------------------------------------+
#ifndef RISKMANAGER_MQH
#define RISKMANAGER_MQH

#include "../Core/Context.mqh"
#include "../Config/Parameters.mqh"
#include "StopLoss.mqh"
#include "TakeProfit.mqh"

struct TradeRiskParams
{
   ENUM_POSITION_TYPE   type;
   double               price;
   double               sl;
   double               tp;
   double               lots;
};

class CRiskManager
{
public:
   bool PrepareTrade(ENUM_SIGNAL_TYPE signal, const CMarketContext &ctx, const CParameters &params, TradeRiskParams &outParams)
   {
      if(signal == SIGNAL_NONE) return false;

      outParams.type = (signal == SIGNAL_BUY) ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
      outParams.price = (signal == SIGNAL_BUY) ? ctx.m_ask : ctx.m_bid;

      bool canTrade = true;
      double slDist = CStopLoss::CalculateSLDistance(ctx, params, canTrade);
      if(!canTrade || slDist <= 0) return false;

      double tpDist = CTakeProfit::CalculateTPDistance(ctx, params);

      if(signal == SIGNAL_BUY) {
         outParams.sl = outParams.price - slDist;
         outParams.tp = outParams.price + tpDist;
      } else {
         outParams.sl = outParams.price + slDist;
         outParams.tp = outParams.price - tpDist;
      }

      outParams.lots = CalculateLotSize(ctx.m_symbol, slDist, params);

      return (outParams.lots > 0);
   }

   double CalculateLotSize(string symbol, double slDistance, const CParameters &params)
   {
      if(!params.m_useAutoRisk) return params.m_lotSize;

      double balance = AccountInfoDouble(ACCOUNT_BALANCE);
      double riskAmount = balance * (params.m_riskPercent / 100.0);

      double tickValue = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
      double tickSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
      double point = SymbolInfoDouble(symbol, SYMBOL_POINT);

      if(tickSize <= 0 || point <= 0 || tickValue <= 0 || slDistance <= 0) return params.m_lotSize;

      double slInTicks = slDistance / tickSize;
      double lossPerLot = slInTicks * tickValue;

      if(lossPerLot <= 0) return params.m_lotSize;

      double calculatedLot = riskAmount / lossPerLot;

      double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
      double maxLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
      double stepLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);

      calculatedLot = MathFloor(calculatedLot / stepLot) * stepLot;

      if(calculatedLot < minLot) calculatedLot = minLot;
      if(calculatedLot > maxLot) calculatedLot = maxLot;

      return calculatedLot;
   }
};

#endif
