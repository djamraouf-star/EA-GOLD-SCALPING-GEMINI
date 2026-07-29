//+------------------------------------------------------------------+
//|                                                  IQMWeights.mqh  |
//+------------------------------------------------------------------+
#ifndef IQMWEIGHTS_MQH
#define IQMWEIGHTS_MQH

struct SIQMWeights
{
   double spread;
   double atr;
   double trend;
   double rsi;
   double session;
   double candles;
   double pullback;

   double total() const
   {
      return spread + atr + trend + rsi + session + candles + pullback;
   }
};

#endif
