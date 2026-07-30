//+------------------------------------------------------------------+
//|                                                 HardFilters.mqh  |
//+------------------------------------------------------------------+
#ifndef HARDFILTERS_MQH
#define HARDFILTERS_MQH

#include "../../Core/Context.mqh"
#include "../../Config/Parameters.mqh"
#include "../../Statistics/DailyManager.mqh"
#include "SpreadFilter.mqh"
#include "ATRFilter.mqh"
#include "SessionFilter.mqh"
#include "DailyFilter.mqh"

class CHardFilters
{
public:
   static bool CheckAll(const CMarketContext& ctx, const CParameters& params, CDailyManager* dailyManager, string &rejectReason)
   {
      if(!CSpreadFilter::IsAllowed(ctx, params, rejectReason)) return false;
      if(!CATRFilter::IsAllowed(ctx, params, rejectReason)) return false;
      if(!CSessionFilter::IsAllowed(ctx, params, rejectReason)) return false;
      if(!CDailyFilter::IsAllowed(dailyManager, rejectReason)) return false;
      
      rejectReason = "";
      return true;
   }
};

#endif
