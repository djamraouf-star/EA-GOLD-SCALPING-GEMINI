//+------------------------------------------------------------------+
//|                                                SignalManager.mqh |
//+------------------------------------------------------------------+
#ifndef SIGNALMANAGER_MQH
#define SIGNALMANAGER_MQH

#include "../Core/Context.mqh"
#include "BuySignal.mqh"
#include "SellSignal.mqh"

enum ENUM_SIGNAL_TYPE {
   SIGNAL_NONE,
   SIGNAL_BUY,
   SIGNAL_SELL
};

class CSignalManager
{
public:
   ENUM_SIGNAL_TYPE CheckSignal(const CMarketContext &ctx)
   {
      if(CBuySignal::Evaluate(ctx))  return SIGNAL_BUY;
      if(CSellSignal::Evaluate(ctx)) return SIGNAL_SELL;
      return SIGNAL_NONE;
   }
};

#endif
