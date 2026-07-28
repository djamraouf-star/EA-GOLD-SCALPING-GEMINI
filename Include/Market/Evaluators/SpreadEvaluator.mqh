//+------------------------------------------------------------------+
//|                                             SpreadEvaluator.mqh  |
//+------------------------------------------------------------------+
#ifndef SPREADEVALUATOR_MQH
#define SPREADEVALUATOR_MQH

#include "IIQMEvaluator.mqh"

class CSpreadEvaluator : public IIQMEvaluator
{
public:
   virtual double Evaluate(const CMarketContext& ctx, const CParameters& params) override
   {
      if(ctx.m_spreadPoints <= 0 || params.m_maxSpreadPoints <= 0) return 0.0;
      
      double ratio = ctx.m_spreadPoints / params.m_maxSpreadPoints;
      if(ratio <= 0.25) return 1.0; // Spread idéal (< 25% du max)
      if(ratio >= 1.0)  return 0.0; // Dépassement de la borne max
      
      // Dégradation non-linéaire (quadratique) : accentue la pénalité sur les spreads élevés
      double normProgress = (ratio - 0.25) / 0.75;
      double score = 1.0 - MathPow(normProgress, 1.5);
      return MathMax(0.0, MathMin(1.0, score));
   }
   
   virtual string Name() override { return "Spread"; }
};

#endif
