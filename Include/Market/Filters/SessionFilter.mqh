//+------------------------------------------------------------------+
//|                                               SessionFilter.mqh  |
//+------------------------------------------------------------------+
#ifndef SESSIONFILTER_MQH
#define SESSIONFILTER_MQH

#include "../../Core/Context.mqh"
#include "../../Config/Parameters.mqh"
#include "../../Utils/TimeUtils.mqh"

class CSessionFilter
{
public:
   static bool IsAllowed(const CMarketContext& ctx, const CParameters& params, string &reason)
   {
      if(!params.m_enableSessionFilter) return true;
      
      bool inAsia = CTimeUtils::IsWithinHours(1, 7);
      if(inAsia && params.m_filterAsianSession) {
         reason = "Session Asiatique interdite dans la configuration";
         return false;
      }
      return true;
   }
};

#endif
