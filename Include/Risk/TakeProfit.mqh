//+------------------------------------------------------------------+
//|                                                   TakeProfit.mqh |
//+------------------------------------------------------------------+
#ifndef TAKEPROFIT_MQH
#define TAKEPROFIT_MQH

#include "../Core/Context.mqh"
#include "../Config/Parameters.mqh"

class CTakeProfit
{
public:
   static double CalculateTPDistance(const CMarketContext &ctx, const CParameters &params)
   {
      return ctx.m_atr * params.m_tp1AtrMultiplier;
   }
};

#endif
