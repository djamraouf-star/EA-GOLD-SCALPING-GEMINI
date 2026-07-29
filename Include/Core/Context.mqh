//+------------------------------------------------------------------+
//|                                                     Context.mqh  |
//+------------------------------------------------------------------+
#ifndef CONTEXT_MQH
#define CONTEXT_MQH

#include "../Config/Parameters.mqh"
#include "../Indicators/AtrIndicator.mqh"
#include "../Indicators/EmaIndicator.mqh"
#include "../Indicators/RsiIndicator.mqh"
#include "../Indicators/AdxIndicator.mqh"
#include "../Market/IQMResult.mqh"

class CMarketContext
{
public:
   string             m_symbol;
   ENUM_TIMEFRAMES    m_timeframe;

   double             m_bid;
   double             m_ask;
   double             m_spreadPoints;

   double             m_atr;
   double             m_emaFast;
   double             m_emaSlow;
   double             m_rsi;
   double             m_adx;

   double             m_marketQualityScore;
   SIQMResult         m_iqmResult;

private:
   CAtrIndicator      m_indAtr;
   CEmaIndicator      m_indEma;
   CRsiIndicator      m_indRsi;
   CAdxIndicator      m_indAdx;

public:
   bool Init(string symbol, ENUM_TIMEFRAMES tf, const CParameters &params)
   {
      m_symbol    = symbol;
      m_timeframe = tf;

      if(!m_indAtr.Init(symbol, tf, params.m_atrPeriod)) return false;
      if(!m_indEma.Init(symbol, tf, params.m_emaFastPeriod, params.m_emaSlowPeriod)) return false;
      if(!m_indRsi.Init(symbol, tf, params.m_rsiPeriod)) return false;
      if(!m_indAdx.Init(symbol, tf, params.m_adxPeriod)) return false;

      return true;
   }

   void Deinit()
   {
      m_indAtr.Deinit();
      m_indEma.Deinit();
      m_indRsi.Deinit();
      m_indAdx.Deinit();
   }

   bool UpdateTick()
   {
      m_ask = SymbolInfoDouble(m_symbol, SYMBOL_ASK);
      m_bid = SymbolInfoDouble(m_symbol, SYMBOL_BID);
      double point = SymbolInfoDouble(m_symbol, SYMBOL_POINT);
      
      if(point > 0) {
         m_spreadPoints = (m_ask - m_bid) / point;
      } else {
         m_spreadPoints = 0;
      }

      m_atr     = m_indAtr.GetValue(0);
      m_emaFast = m_indEma.GetFast(0);
      m_emaSlow = m_indEma.GetSlow(0);
      m_rsi     = m_indRsi.GetValue(0);
      m_adx     = m_indAdx.GetValue(0);

      return (m_ask > 0 && m_bid > 0);
   }
};

#endif
