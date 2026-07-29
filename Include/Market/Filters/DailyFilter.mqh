//+------------------------------------------------------------------+
//|                                                 DailyFilter.mqh  |
//+------------------------------------------------------------------+
#ifndef DAILYFILTER_MQH
#define DAILYFILTER_MQH

#include "../../Core/Context.mqh"
#include "../../Config/Parameters.mqh"
#include "../../Statistics/DailyManager.mqh"

class CDailyFilter
{
public:
   static bool IsAllowed(CDailyManager* dailyManager, string &reason)
   {
      if(dailyManager != NULL) {
         if(!dailyManager.CanTrade()) {
            reason = "Limites journalières atteintes (Max Perte / Profit / Trades)";
            return false;
         }
      }
      return true;
   }
};

#endif
