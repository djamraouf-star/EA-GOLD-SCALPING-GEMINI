//+------------------------------------------------------------------+
//|                                                  Performance.mqh |
//+------------------------------------------------------------------+
#ifndef PERFORMANCE_MQH
#define PERFORMANCE_MQH

class CPerformance
{
public:
   static double GetProfitFactor()
   {
      double grossProfit = AccountInfoDouble(ACCOUNT_PROFIT);
      return grossProfit > 0 ? grossProfit : 1.0;
   }
};

#endif
