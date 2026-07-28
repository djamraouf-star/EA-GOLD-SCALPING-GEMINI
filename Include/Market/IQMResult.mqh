//+------------------------------------------------------------------+
//|                                                   IQMResult.mqh  |
//+------------------------------------------------------------------+
#ifndef IQMRESULT_MQH
#define IQMRESULT_MQH

struct SIQMResult
{
   bool   marketAllowed;

   double spreadScore;
   double atrScore;
   double trendScore;
   double rsiScore;
   double sessionScore;
   double candleScore;
   double pullbackScore;

   double finalScore;

   string rejectReason;
};

#endif
