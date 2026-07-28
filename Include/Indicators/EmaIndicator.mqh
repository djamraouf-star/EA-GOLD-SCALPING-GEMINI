//+------------------------------------------------------------------+
//|                                                EmaIndicator.mqh  |
//+------------------------------------------------------------------+
#ifndef EMAINDICATOR_MQH
#define EMAINDICATOR_MQH

class CEmaIndicator
{
private:
   int m_handleFast;
   int m_handleSlow;

public:
   CEmaIndicator() : m_handleFast(INVALID_HANDLE), m_handleSlow(INVALID_HANDLE) {}

   bool Init(string symbol, ENUM_TIMEFRAMES period, int fastPeriod, int slowPeriod)
   {
      m_handleFast = iMA(symbol, period, fastPeriod, 0, MODE_EMA, PRICE_CLOSE);
      m_handleSlow = iMA(symbol, period, slowPeriod, 0, MODE_EMA, PRICE_CLOSE);
      return (m_handleFast != INVALID_HANDLE && m_handleSlow != INVALID_HANDLE);
   }

   void Deinit()
   {
      if(m_handleFast != INVALID_HANDLE) IndicatorRelease(m_handleFast);
      if(m_handleSlow != INVALID_HANDLE) IndicatorRelease(m_handleSlow);
   }

   double GetFast(int shift=0)
   {
      if(m_handleFast == INVALID_HANDLE) return 0.0;
      double val[1];
      if(CopyBuffer(m_handleFast, 0, shift, 1, val) > 0) return val[0];
      return 0.0;
   }

   double GetSlow(int shift=0)
   {
      if(m_handleSlow == INVALID_HANDLE) return 0.0;
      double val[1];
      if(CopyBuffer(m_handleSlow, 0, shift, 1, val) > 0) return val[0];
      return 0.0;
   }
};

#endif
