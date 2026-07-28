//+------------------------------------------------------------------+
//|                                                    BuySignal.mqh |
//+------------------------------------------------------------------+
#ifndef BUYSIGNAL_MQH
#define BUYSIGNAL_MQH

#include "../Core/Context.mqh"

class CBuySignal
{
public:
   static bool Evaluate(const CMarketContext &ctx)
   {
      bool trendOk = (ctx.m_emaFast > ctx.m_emaSlow);
      bool momentumOk = (ctx.m_rsi >= 52.0 && ctx.m_rsi <= 70.0);
      bool priceOk = (ctx.m_ask > ctx.m_emaFast);

      return (trendOk && momentumOk && priceOk);
   }
};

#endif
