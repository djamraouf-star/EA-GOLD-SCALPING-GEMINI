//+------------------------------------------------------------------+
//|                                              TrendEvaluator.mqh  |
//+------------------------------------------------------------------+
#ifndef TRENDEVALUATOR_MQH
#define TRENDEVALUATOR_MQH

#include "IIQMEvaluator.mqh"
#include "../../Utils/MathUtils.mqh"

class CTrendEvaluator : public IIQMEvaluator
{
public:
   virtual double Evaluate(const CMarketContext& ctx, const CParameters& params) override
   {
      double point = SymbolInfoDouble(ctx.m_symbol, SYMBOL_POINT);
      if(point <= 0 || ctx.m_atr <= 0) return 0.5;
      
      double emaDiff = MathAbs(ctx.m_emaFast - ctx.m_emaSlow) / point;
      double minTrend = 0.5;
      double atrPts = ctx.m_atr / point;
      if(atrPts <= 0) atrPts = 10.0;
      double maxTrend = atrPts * 1.0;
      
      double score = CMathUtils::NormalizeScore(emaDiff, minTrend, maxTrend);
      return MathMin(1.0, MathMax(0.0, score));
   }
   
   virtual string Name() override { return "Trend"; }
};

#endif
