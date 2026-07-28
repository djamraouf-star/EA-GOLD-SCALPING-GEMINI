//+------------------------------------------------------------------+
//|                                                SpreadFilter.mqh  |
//+------------------------------------------------------------------+
#ifndef SPREADFILTER_MQH
#define SPREADFILTER_MQH

#include "../../Core/Context.mqh"
#include "../../Config/Parameters.mqh"

class CSpreadFilter
{
public:
   static bool IsAllowed(const CMarketContext& ctx, const CParameters& params, string &reason)
   {
      if(ctx.m_spreadPoints > params.m_maxSpreadPoints) {
         reason = StringFormat("Spread trop élevé: %.1f > %.1f points", ctx.m_spreadPoints, params.m_maxSpreadPoints);
         return false;
      }
      return true;
   }
};

#endif
