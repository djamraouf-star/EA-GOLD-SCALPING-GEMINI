//+------------------------------------------------------------------+
//|                                                RSIEvaluator.mqh  |
//+------------------------------------------------------------------+
#ifndef RSIEVALUATOR_MQH
#define RSIEVALUATOR_MQH

#include "IIQMEvaluator.mqh"
#include "../../Utils/MathUtils.mqh"

class CRSIEvaluator : public IIQMEvaluator
{
public:
   virtual double Evaluate(const CMarketContext& ctx, const CParameters& params) override
   {
      double rsiDist = MathAbs(ctx.m_rsi - 50.0);
      double score = CMathUtils::NormalizeScore(rsiDist, 2.0, 15.0);
      return MathMin(1.0, MathMax(0.0, score));
   }
   
   virtual string Name() override { return "RSI"; }
};

#endif
