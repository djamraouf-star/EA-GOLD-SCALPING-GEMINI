//+------------------------------------------------------------------+
//|                                          PullbackEvaluator.mqh   |
//+------------------------------------------------------------------+
#ifndef PULLBACKEVALUATOR_MQH
#define PULLBACKEVALUATOR_MQH

#include "IIQMEvaluator.mqh"

class CPullbackEvaluator : public IIQMEvaluator
{
public:
   virtual double Evaluate(const CMarketContext& ctx, const CParameters& params) override
   {
      double point = SymbolInfoDouble(ctx.m_symbol, SYMBOL_POINT);
      if(point <= 0) return 0.5;
      
      double distFast = MathAbs(ctx.m_ask - ctx.m_emaFast) / point;
      double atrPts = ctx.m_atr / point;
      if(atrPts <= 0) atrPts = 10.0;
      
      double maxDist = atrPts * 0.5;
      if(distFast > maxDist) return 0.0;
      
      double score = 1.0 - (distFast / maxDist);
      return MathMax(0.0, MathMin(1.0, score));
   }
   
   virtual string Name() override { return "Pullback"; }
};

#endif
