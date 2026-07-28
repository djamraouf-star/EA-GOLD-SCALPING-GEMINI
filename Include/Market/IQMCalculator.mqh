//+------------------------------------------------------------------+
//|                                              IQMCalculator.mqh   |
//+------------------------------------------------------------------+
#ifndef IQMCALCULATOR_MQH
#define IQMCALCULATOR_MQH

#include "IQMResult.mqh"
#include "IQMWeights.mqh"
#include "Evaluators/SpreadEvaluator.mqh"
#include "Evaluators/ATREvaluator.mqh"
#include "Evaluators/TrendEvaluator.mqh"
#include "Evaluators/RSIEvaluator.mqh"
#include "Evaluators/SessionEvaluator.mqh"
#include "Evaluators/CandleEvaluator.mqh"
#include "Evaluators/PullbackEvaluator.mqh"

class CIQMCalculator
{
private:
   CSpreadEvaluator   m_spreadEval;
   CATREvaluator      m_atrEval;
   CTrendEvaluator    m_trendEval;
   CRSIEvaluator      m_rsiEval;
   CSessionEvaluator  m_sessionEval;
   CCandleEvaluator   m_candleEval;
   CPullbackEvaluator m_pullbackEval;

public:
   SIQMResult Calculate(const CMarketContext& ctx, const CParameters& params)
   {
      SIQMResult result;
      result.marketAllowed = true;
      result.rejectReason = "";
      
      // 1. Appel des 7 Évaluateurs
      result.spreadScore   = m_spreadEval.Evaluate(ctx, params);
      result.atrScore      = m_atrEval.Evaluate(ctx, params);
      result.trendScore    = m_trendEval.Evaluate(ctx, params);
      result.rsiScore      = m_rsiEval.Evaluate(ctx, params);
      result.sessionScore  = m_sessionEval.Evaluate(ctx, params);
      result.candleScore   = m_candleEval.Evaluate(ctx, params);
      result.pullbackScore = m_pullbackEval.Evaluate(ctx, params);
      
      // 2. Application des Pondérations Centralisées
      SIQMWeights weights;
      weights.spread   = params.m_weightSpread;
      weights.atr      = params.m_weightAtr;
      weights.trend    = params.m_weightTrend;
      weights.rsi      = params.m_weightRsi;
      weights.session  = params.m_weightSession;
      weights.candles  = params.m_weightCandles;
      weights.pullback = params.m_weightPullback;
      
      double totalWeight = weights.total();
      
      // 3. Normalisation sur 100
      if(totalWeight > 0.0) {
         double weightedSum = (
            result.spreadScore   * weights.spread +
            result.atrScore      * weights.atr +
            result.trendScore    * weights.trend +
            result.rsiScore      * weights.rsi +
            result.sessionScore  * weights.session +
            result.candleScore   * weights.candles +
            result.pullbackScore * weights.pullback
         );
         
         result.finalScore = (weightedSum / totalWeight) * 100.0;
      } else {
         result.finalScore = 0.0;
      }
      
      return result;
   }
};

#endif
