//+------------------------------------------------------------------+
//|                                                RsiIndicator.mqh  |
//+------------------------------------------------------------------+
#ifndef RSIINDICATOR_MQH
#define RSIINDICATOR_MQH

class CRsiIndicator
{
private:
   int m_handle;

public:
   CRsiIndicator() : m_handle(INVALID_HANDLE) {}

   bool Init(string symbol, ENUM_TIMEFRAMES period, int rsiPeriod)
   {
      m_handle = iRSI(symbol, period, rsiPeriod, PRICE_CLOSE);
      return (m_handle != INVALID_HANDLE);
   }

   void Deinit()
   {
      if(m_handle != INVALID_HANDLE) IndicatorRelease(m_handle);
   }

   double GetValue(int shift=0)
   {
      if(m_handle == INVALID_HANDLE) return 50.0;
      double val[1];
      if(CopyBuffer(m_handle, 0, shift, 1, val) > 0) return val[0];
      return 50.0;
   }
};

#endif
