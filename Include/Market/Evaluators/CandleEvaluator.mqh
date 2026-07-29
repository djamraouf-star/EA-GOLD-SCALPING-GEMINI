//+------------------------------------------------------------------+
//|                                             CandleEvaluator.mqh  |
//+------------------------------------------------------------------+
#ifndef CANDLEEVALUATOR_MQH
#define CANDLEEVALUATOR_MQH

#include "IIQMEvaluator.mqh"

class CCandleEvaluator : public IIQMEvaluator
{
public:
   virtual double Evaluate(const CMarketContext& ctx, const CParameters& params) override
   {
      double open1  = iOpen(ctx.m_symbol, PERIOD_CURRENT, 1);
      double close1 = iClose(ctx.m_symbol, PERIOD_CURRENT, 1);
      double high1  = iHigh(ctx.m_symbol, PERIOD_CURRENT, 1);
      double low1   = iLow(ctx.m_symbol, PERIOD_CURRENT, 1);
      
      double range1 = high1 - low1;
      if(range1 <= 0) return 0.5;
      
      double body1 = MathAbs(close1 - open1);
      double bodyRatio = body1 / range1;
      
      if(bodyRatio > 0.6) return 1.0;
      if(bodyRatio > 0.4) return 0.7;
      if(bodyRatio > 0.2) return 0.4;
      return 0.2;
   }
   
   virtual string Name() override { return "Candles"; }
};

#endif
