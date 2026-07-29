//+------------------------------------------------------------------+
//|                                                   SellSignal.mqh |
//+------------------------------------------------------------------+
#ifndef SELLSIGNAL_MQH
#define SELLSIGNAL_MQH

#include "../Core/Context.mqh"

class CSellSignal
{
public:
   static bool Evaluate(const CMarketContext &ctx)
   {
      bool trendOk = (ctx.m_emaFast < ctx.m_emaSlow);
      bool momentumOk = (ctx.m_rsi <= 48.0 && ctx.m_rsi >= 30.0);
      bool priceOk = (ctx.m_bid < ctx.m_emaFast);

      return (trendOk && momentumOk && priceOk);
   }
};

#endif
