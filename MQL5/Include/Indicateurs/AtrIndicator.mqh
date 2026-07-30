//+------------------------------------------------------------------+
//|                                                AtrIndicator.mqh  |
//+------------------------------------------------------------------+
#ifndef ATRINDICATOR_MQH
#define ATRINDICATOR_MQH

class CAtrIndicator
{
private:
   int    m_handle;
   string m_symbol;
   ENUM_TIMEFRAMES m_period;

public:
   CAtrIndicator() : m_handle(INVALID_HANDLE) {}

   bool Init(string symbol, ENUM_TIMEFRAMES period, int atrPeriod)
   {
      m_symbol = symbol;
      m_period = period;
      m_handle = iATR(symbol, period, atrPeriod);
      return (m_handle != INVALID_HANDLE);
   }

   void Deinit()
   {
      if(m_handle != INVALID_HANDLE) {
         IndicatorRelease(m_handle);
         m_handle = INVALID_HANDLE;
      }
   }

   double GetValue(int shift=0)
   {
      if(m_handle == INVALID_HANDLE) return 0.0;
      double val[1];
      if(CopyBuffer(m_handle, 0, shift, 1, val) > 0) {
         return val[0];
      }
      return 0.0;
   }
};

#endif
