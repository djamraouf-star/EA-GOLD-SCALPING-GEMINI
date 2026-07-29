//+------------------------------------------------------------------+
//|                                                     StopLoss.mqh |
//+------------------------------------------------------------------+
#ifndef STOPLOSS_MQH
#define STOPLOSS_MQH

#include "../Core/Context.mqh"
#include "../Config/Parameters.mqh"

class CStopLoss
{
public:
   static double CalculateSLDistance(const CMarketContext &ctx, const CParameters &params, bool &outCanTrade)
   {
      outCanTrade = true;

      double atrCoeff = params.m_slAtrMultiplier;

      if(params.m_enableDynamicIqmSl) {
         double score = ctx.m_marketQualityScore;
         if(score >= 90.0) {
            atrCoeff = 1.10;
         } else if(score >= 80.0) {
            atrCoeff = 1.25;
         } else if(score >= 70.0) {
            atrCoeff = 1.35;
         } else {
            outCanTrade = false;
            return 0.0;
         }
      }

      double slDistance = ctx.m_atr * atrCoeff;

      double point = SymbolInfoDouble(ctx.m_symbol, SYMBOL_POINT);
      if(point > 0) {
         if(params.m_minSlPoints > 0) {
            double minDist = params.m_minSlPoints * point;
            if(slDistance < minDist) slDistance = minDist;
         }
         if(params.m_maxSlPoints > 0) {
            double maxDist = params.m_maxSlPoints * point;
            if(slDistance > maxDist) slDistance = maxDist;
         }
      }

      return slDistance;
   }
};

#endif
