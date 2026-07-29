//+------------------------------------------------------------------+
//|                                                AdxHardFilter.mqh |
//+------------------------------------------------------------------+
#ifndef ADXHARDFILTER_MQH
#define ADXHARDFILTER_MQH

#include "../../Core/Context.mqh"
#include "../../Config/Parameters.mqh"

class CAdxHardFilter
{
public:
   static bool IsAllowed(const CMarketContext& ctx, const CParameters& params, string &reason)
   {
      if(!params.m_enableAdxFilter) return true; // Si désactivé, on autorise
      
      if(ctx.m_adx < params.m_adxThreshold) {
         reason = StringFormat("Tendance trop faible (ADX = %.1f < Seuil %.1f)", ctx.m_adx, params.m_adxThreshold);
         return false;
      }
      return true;
   }
};
#endif
