//+------------------------------------------------------------------+
//|                                                 MarketFilter.mqh |
//|                        GoldScalperEA V2.0 - Market Filter IQM    |
//+------------------------------------------------------------------+
#ifndef MARKETFILTER_MQH
#define MARKETFILTER_MQH

#include "../Core/Context.mqh"
#include "../Config/Parameters.mqh"
#include "../Statistics/DailyManager.mqh"
#include "IQMCalculator.mqh"
#include "Filters/HardFilters.mqh"

class CMarketFilter
{
private:
   CIQMCalculator m_calculator;

public:
   SIQMResult CalculateScore(const CMarketContext &ctx, const CParameters &params, CDailyManager* dailyManager)
   {
      SIQMResult result;
      result.finalScore = 0.0;
      
      string rejectReason = "";
      
      // 1. Validation des Hard Filters (RÉPOND OUI / NON)
      if(!CHardFilters::CheckAll(ctx, params, dailyManager, rejectReason)) {
         result.marketAllowed = false;
         result.rejectReason = rejectReason;
         return result;
      }
      
      // 2. Calcul de l'IQM via les Évaluateurs
      result = m_calculator.Calculate(ctx, params);
      
      // 3. Contrôle du Seuil Minimum IQM
      if(result.finalScore < params.m_minMarketScore) {
         result.marketAllowed = false;
         result.rejectReason = StringFormat("Score IQM insuffisant: %.1f < %.1f", result.finalScore, params.m_minMarketScore);
      } else {
         result.marketAllowed = true;
         result.rejectReason = "IQM Validé";
      }
      
      return result;
   }
};

#endif
