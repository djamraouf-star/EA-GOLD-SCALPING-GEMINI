//+------------------------------------------------------------------+
//|                                                ATREvaluator.mqh  |
//+------------------------------------------------------------------+
#ifndef ATREVALUATOR_MQH
#define ATREVALUATOR_MQH

#include "IIQMEvaluator.mqh"
#include "../../Utils/MathUtils.mqh"

class CATREvaluator : public IIQMEvaluator
{
public:
   virtual double Evaluate(const CMarketContext& ctx, const CParameters& params) override
   {
      double point = SymbolInfoDouble(ctx.m_symbol, SYMBOL_POINT);
      if(point <= 0) return 0.5;
      
      double atrPoints = ctx.m_atr / point;
      double minAtr = params.m_minAtrPoints > 0 ? params.m_minAtrPoints : 5.0;
      double maxAtr = minAtr * 3.5; 
      
      double baseScore = CMathUtils::NormalizeScore(atrPoints, minAtr, maxAtr);
      
      // Bonus/Malus d'Efficacité : Ratio ATR / Spread
      if(ctx.m_spreadPoints > 0) {
         double atrSpreadRatio = atrPoints / ctx.m_spreadPoints;
         if(atrSpreadRatio < 2.0) baseScore *= 0.75; // Malus si l'ATR ne couvre pas au moins 2x le spread
         else if(atrSpreadRatio >= 4.0) baseScore = MathMin(1.0, baseScore * 1.15); // Bonus volatilité propre
      }
      
      return MathMin(1.0, MathMax(0.0, baseScore));
   }
   
   virtual string Name() override { return "ATR"; }
};

#endif
