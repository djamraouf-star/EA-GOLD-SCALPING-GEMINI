//+------------------------------------------------------------------+
//|                                                    TimeUtils.mqh |
//+------------------------------------------------------------------+
#ifndef TIMEUTILS_MQH
#define TIMEUTILS_MQH

class CTimeUtils
{
public:
   static bool IsNewBar(string symbol, ENUM_TIMEFRAMES period, datetime &lastBarTime)
   {
      datetime currentBarTime = iTime(symbol, period, 0);
      if(currentBarTime == 0) return false;

      if(currentBarTime != lastBarTime) {
         lastBarTime = currentBarTime;
         return true;
      }
      return false;
   }

   static bool IsWithinHours(int startHour, int endHour)
   {
      MqlDateTime dt;
      TimeToStruct(TimeCurrent(), dt);
      if(startHour <= endHour) {
         return (dt.hour >= startHour && dt.hour < endHour);
      } else {
         return (dt.hour >= startHour || dt.hour < endHour);
      }
   }
};

#endif
