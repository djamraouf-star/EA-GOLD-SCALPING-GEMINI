//+------------------------------------------------------------------+
//|                                                   ATRFilter.mqh  |
//+------------------------------------------------------------------+
#ifndef ATRFILTER_MQH
#define ATRFILTER_MQH

#include "../../Core/Context.mqh"
#include "../../Config/Parameters.mqh"

class CATRFilter
{
public:
   static bool IsAllowed(const CMarketContext& ctx, const CParameters& params, string &reason)
   {
      double point = SymbolInfoDouble(ctx.m_symbol, SYMBOL_POINT);
      if(point > 0) {
         double atrPoints = ctx.m_atr / point;
         if(params.m_minAtrPoints > 0 && atrPoints < params.m_minAtrPoints) {
            reason = StringFormat("ATR trop faible: %.1f < %.1f points", atrPoints, params.m_minAtrPoints);
            return false;
         }
         
         if(params.m_minAtrSpreadRatio > 0 && ctx.m_spreadPoints > 0) {
            double ratio = atrPoints / ctx.m_spreadPoints;
            if(ratio < params.m_minAtrSpreadRatio) {
               reason = StringFormat("Ratio ATR/Spread insuffisant: %.2f < %.2f", ratio, params.m_minAtrSpreadRatio);
               return false;
            }
         }
      }
      return true;
   }
};

#endif
