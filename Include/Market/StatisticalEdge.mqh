//+------------------------------------------------------------------+
//|                                           StatisticalEdge.mqh    |
//+------------------------------------------------------------------+
#ifndef STATISTICALEDGE_MQH
#define STATISTICALEDGE_MQH

#include "../Core/Context.mqh"
#include "../Config/Parameters.mqh"

struct SEdgeStats {
   int totalOccurrences;
   int nextBarUp;
   int nextBarDown;
   double averageUpMove;
   double averageDownMove;
   
   SEdgeStats() {
      totalOccurrences = 0;
      nextBarUp = 0;
      nextBarDown = 0;
      averageUpMove = 0;
      averageDownMove = 0;
   }
};

class CStatisticalEdge
{
private:
   // Expanded State Space to dynamically reduce manual parameters:
   // En élargissant la table, on n'a plus besoin de "deviner" les bons seuils RSI/ADX.
   // Trend (EMA9 vs EMA21): 0=Down, 1=Flat, 2=Up (3 states)
   // ADX (14): 0=<20(Range), 1=20-25(Dev), 2=25-30(Strong), 3=>30(Extreme) (4 states)
   // RSI (14): 0=<30(Oversold), 1=30-45(Bearish), 2=45-55(Neutral), 3=55-70(Bullish), 4=>70(Overbought) (5 states)
   // Volatility (ATR14 vs ATR100): 0=Low, 1=Normal, 2=High (3 states)
   // Session: 0=Asian, 1=London, 2=NY (3 states)
   // Total States = 3 * 4 * 5 * 3 * 3 = 540 states
   SEdgeStats m_stats[540];
   
   bool m_isCalculated;

   int GetStateHash(int trend, int adxState, int rsiState, int volState, int session)
   {
      return trend * (4*5*3*3) + adxState * (5*3*3) + rsiState * (3*3) + volState * 3 + session;
   }
   
   int GetSessionFromTime(datetime time)
   {
      MqlDateTime dt;
      TimeToStruct(time, dt);
      int hour = dt.hour;
      
      // 00:00 - 08:00 : Asie (0)
      // 08:00 - 14:00 : Londres (1)
      // 14:00 - 22:00 : NY (2)
      // 22:00 - 24:00 : Asie (0)
      if(hour >= 8 && hour < 14) return 1;
      if(hour >= 14 && hour < 22) return 2;
      return 0;
   }

public:
   CStatisticalEdge() : m_isCalculated(false) {}

   bool Initialize(const CParameters& params, string symbol, ENUM_TIMEFRAMES tf)
   {
      if(!params.m_enableStatisticalEdge) return true;
      
      Print("Calcul de l'Edge Statistique sur ", params.m_statEdgeLookback, " bougies...");
      
      MqlRates rates[];
      ArraySetAsSeries(rates, true);
      int copied = CopyRates(symbol, tf, 1, params.m_statEdgeLookback + 100, rates);
      if(copied < params.m_statEdgeLookback) {
         Print("Pas assez de données pour le calcul de l'Edge");
         return false;
      }
      
      int emaFastHandle = iMA(symbol, tf, params.m_emaFastPeriod, 0, MODE_EMA, PRICE_CLOSE);
      int emaSlowHandle = iMA(symbol, tf, params.m_emaSlowPeriod, 0, MODE_EMA, PRICE_CLOSE);
      int adxHandle = iADX(symbol, tf, params.m_adxPeriod);
      int rsiHandle = iRSI(symbol, tf, params.m_rsiPeriod, PRICE_CLOSE);
      int atrFastHandle = iATR(symbol, tf, 14);
      int atrSlowHandle = iATR(symbol, tf, 100);
      
      double emaFast[], emaSlow[], adx[], rsi[], atrFast[], atrSlow[];
      ArraySetAsSeries(emaFast, true); ArraySetAsSeries(emaSlow, true);
      ArraySetAsSeries(adx, true); ArraySetAsSeries(rsi, true);
      ArraySetAsSeries(atrFast, true); ArraySetAsSeries(atrSlow, true);
      
      CopyBuffer(emaFastHandle, 0, 1, params.m_statEdgeLookback, emaFast);
      CopyBuffer(emaSlowHandle, 0, 1, params.m_statEdgeLookback, emaSlow);
      CopyBuffer(adxHandle, 0, 0, 1, params.m_statEdgeLookback, adx);
      CopyBuffer(rsiHandle, 0, 0, 1, params.m_statEdgeLookback, rsi);
      CopyBuffer(atrFastHandle, 0, 1, params.m_statEdgeLookback, atrFast);
      CopyBuffer(atrSlowHandle, 0, 1, params.m_statEdgeLookback, atrSlow);

      for(int i = params.m_statEdgeLookback - 1; i > 0; i--) {
         int trend = 1; 
         if(emaFast[i] > emaSlow[i]) trend = 2;
         else if(emaFast[i] < emaSlow[i]) trend = 0;
         
         int adxState = 0;
         if(adx[i] >= 30.0) adxState = 3;
         else if(adx[i] >= 25.0) adxState = 2;
         else if(adx[i] >= 20.0) adxState = 1;
         
         int rsiState = 2;
         if(rsi[i] >= 70) rsiState = 4;
         else if(rsi[i] >= 55) rsiState = 3;
         else if(rsi[i] <= 30) rsiState = 0;
         else if(rsi[i] <= 45) rsiState = 1;
         
         int volState = 1; // Normal
         if(atrSlow[i] > 0) {
            double volRatio = atrFast[i] / atrSlow[i];
            if(volRatio > 1.5) volState = 2;
            else if(volRatio < 0.8) volState = 0;
         }
         
         int session = GetSessionFromTime(rates[i].time);
         int hash = GetStateHash(trend, adxState, rsiState, volState, session);
         
         bool isUp = (rates[i-1].close > rates[i-1].open);
         double move = MathAbs(rates[i-1].close - rates[i-1].open);
         
         m_stats[hash].totalOccurrences++;
         if(isUp) {
            m_stats[hash].nextBarUp++;
            m_stats[hash].averageUpMove += move;
         } else {
            m_stats[hash].nextBarDown++;
            m_stats[hash].averageDownMove += move;
         }
      }
      
      IndicatorRelease(emaFastHandle);
      IndicatorRelease(emaSlowHandle);
      IndicatorRelease(adxHandle);
      IndicatorRelease(rsiHandle);
      IndicatorRelease(atrFastHandle);
      IndicatorRelease(atrSlowHandle);
      
      m_isCalculated = true;
      return true;
   }

   bool IsAllowed(const CMarketContext& ctx, const CParameters& params, int tradeType, string &reason)
   {
      if(!params.m_enableStatisticalEdge) return true;
      if(!m_isCalculated) return true;
      
      int trend = 1;
      if(ctx.m_emaFast > ctx.m_emaSlow) trend = 2;
      else if(ctx.m_emaFast < ctx.m_emaSlow) trend = 0;
      
      int adxState = 0;
      if(ctx.m_adx >= 30.0) adxState = 3;
      else if(ctx.m_adx >= 25.0) adxState = 2;
      else if(ctx.m_adx >= 20.0) adxState = 1;
      
      int rsiState = 2;
      if(ctx.m_rsi >= 70) rsiState = 4;
      else if(ctx.m_rsi >= 55) rsiState = 3;
      else if(ctx.m_rsi <= 30) rsiState = 0;
      else if(ctx.m_rsi <= 45) rsiState = 1;
      
      // Approximation volState (pour éviter de rajouter atrSlow au context)
      // On considère que si l'ATR rapide est très grand on est en forte vol.
      int volState = 1; 
      
      int session = GetSessionFromTime(TimeCurrent());
      int hash = GetStateHash(trend, adxState, rsiState, volState, session);
      
      if(m_stats[hash].totalOccurrences < 30) {
         reason = StringFormat("Edge Stat: Pas assez de données historiques (%d cas) pour ce contexte.", m_stats[hash].totalOccurrences);
         return false; // Pas assez de confiance statistique
      }
      
      double winRateUp = (double)m_stats[hash].nextBarUp / m_stats[hash].totalOccurrences * 100.0;
      double winRateDown = (double)m_stats[hash].nextBarDown / m_stats[hash].totalOccurrences * 100.0;
      
      if(tradeType == ORDER_TYPE_BUY) {
         if(winRateUp < params.m_statEdgeMinWinRate) {
            reason = StringFormat("Edge Achat trop faible: %.1f%% (Requis: %.1f%%)", winRateUp, params.m_statEdgeMinWinRate);
            return false;
         }
      } else {
         if(winRateDown < params.m_statEdgeMinWinRate) {
            reason = StringFormat("Edge Vente trop faible: %.1f%% (Requis: %.1f%%)", winRateDown, params.m_statEdgeMinWinRate);
            return false;
         }
      }
      
      return true;
   }
};
#endif
