//+------------------------------------------------------------------+
//|                                           StatisticalEdge.mqh    |
//+------------------------------------------------------------------+
#ifndef STATISTICALEDGE_MQH
#define STATISTICALEDGE_MQH

#include "../Core/Context.mqh"
#include "../Config/Parameters.mqh"

// Define a simple structure to hold the stats for a specific "state"
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
   // Lookup table for states. 
   // We define State as an integer hash of features:
   // Feature 1: Trend (0 = down, 1 = up, 2 = flat)
   // Feature 2: ADX (0 = weak, 1 = strong)
   // Feature 3: RSI (0 = Oversold, 1 = Overbought, 2 = Neutral)
   // Hash = Trend * (2*3) + ADX * (3) + RSI
   // Total states = 3 * 2 * 3 = 18
   SEdgeStats m_stats[18];
   
   bool m_isCalculated;

   int GetStateHash(int trend, int adxStrong, int rsiState)
   {
      return trend * 6 + adxStrong * 3 + rsiState;
   }

public:
   CStatisticalEdge() : m_isCalculated(false) {}

   bool Initialize(const CParameters& params, string symbol, ENUM_TIMEFRAMES tf)
   {
      if(!params.m_enableStatisticalEdge) return true;
      
      Print("Calculating Statistical Edge over ", params.m_statEdgeLookback, " bars...");
      
      MqlRates rates[];
      ArraySetAsSeries(rates, true);
      int copied = CopyRates(symbol, tf, 1, params.m_statEdgeLookback + 50, rates); // +50 for indicator warmup
      if(copied < params.m_statEdgeLookback) {
         Print("Failed to copy enough rates for Statistical Edge");
         return false;
      }
      
      // We need indicators values historically. 
      // Instead of full indicators, we can use simple approximations or load buffers.
      int emaFastHandle = iMA(symbol, tf, params.m_emaFastPeriod, 0, MODE_EMA, PRICE_CLOSE);
      int emaSlowHandle = iMA(symbol, tf, params.m_emaSlowPeriod, 0, MODE_EMA, PRICE_CLOSE);
      int adxHandle = iADX(symbol, tf, params.m_adxPeriod);
      int rsiHandle = iRSI(symbol, tf, params.m_rsiPeriod, PRICE_CLOSE);
      
      double emaFast[], emaSlow[], adx[], rsi[];
      ArraySetAsSeries(emaFast, true); ArraySetAsSeries(emaSlow, true);
      ArraySetAsSeries(adx, true); ArraySetAsSeries(rsi, true);
      
      CopyBuffer(emaFastHandle, 0, 1, params.m_statEdgeLookback, emaFast);
      CopyBuffer(emaSlowHandle, 0, 1, params.m_statEdgeLookback, emaSlow);
      CopyBuffer(adxHandle, 0, 0, 1, params.m_statEdgeLookback, adx);
      CopyBuffer(rsiHandle, 0, 0, 1, params.m_statEdgeLookback, rsi);

      // Loop through historical bars (from oldest to newest)
      // Index 0 is the most recent closed bar (shift 1).
      // So we loop i from params.m_statEdgeLookback - 1 down to 1
      for(int i = params.m_statEdgeLookback - 1; i > 0; i--) {
         // Determine state at bar i
         int trend = 2; // Flat
         if(emaFast[i] > emaSlow[i]) trend = 1;
         else if(emaFast[i] < emaSlow[i]) trend = 0;
         
         int adxStrong = (adx[i] >= params.m_adxThreshold) ? 1 : 0;
         
         int rsiState = 2; // Neutral
         if(rsi[i] < params.m_rsiBuyThreshold) rsiState = 0; // Oversold
         else if(rsi[i] > params.m_rsiSellThreshold) rsiState = 1; // Overbought
         
         int hash = GetStateHash(trend, adxStrong, rsiState);
         
         // Outcome is bar i-1 (the next bar)
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
      
      // Calculate averages
      for(int i=0; i<18; i++) {
         if(m_stats[i].nextBarUp > 0) m_stats[i].averageUpMove /= m_stats[i].nextBarUp;
         if(m_stats[i].nextBarDown > 0) m_stats[i].averageDownMove /= m_stats[i].nextBarDown;
         
         if(m_stats[i].totalOccurrences > 50) {
            double winRateUp = (double)m_stats[i].nextBarUp / m_stats[i].totalOccurrences * 100.0;
            double winRateDown = (double)m_stats[i].nextBarDown / m_stats[i].totalOccurrences * 100.0;
            PrintFormat("State %d | Occur: %d | Up: %.1f%% | Down: %.1f%%", i, m_stats[i].totalOccurrences, winRateUp, winRateDown);
         }
      }
      
      IndicatorRelease(emaFastHandle);
      IndicatorRelease(emaSlowHandle);
      IndicatorRelease(adxHandle);
      IndicatorRelease(rsiHandle);
      
      m_isCalculated = true;
      return true;
   }

   bool IsAllowed(const CMarketContext& ctx, const CParameters& params, int tradeType, string &reason)
   {
      if(!params.m_enableStatisticalEdge) return true;
      if(!m_isCalculated) return true;
      
      int trend = 2;
      if(ctx.m_emaFast > ctx.m_emaSlow) trend = 1;
      else if(ctx.m_emaFast < ctx.m_emaSlow) trend = 0;
      
      int adxStrong = (ctx.m_adx >= params.m_adxThreshold) ? 1 : 0;
      
      int rsiState = 2;
      if(ctx.m_rsi < params.m_rsiBuyThreshold) rsiState = 0;
      else if(ctx.m_rsi > params.m_rsiSellThreshold) rsiState = 1;
      
      int hash = GetStateHash(trend, adxStrong, rsiState);
      
      if(m_stats[hash].totalOccurrences < 50) {
         reason = "Not enough statistical data for current state";
         return false; // Not enough edge
      }
      
      double winRateUp = (double)m_stats[hash].nextBarUp / m_stats[hash].totalOccurrences * 100.0;
      double winRateDown = (double)m_stats[hash].nextBarDown / m_stats[hash].totalOccurrences * 100.0;
      
      if(tradeType == ORDER_TYPE_BUY) {
         if(winRateUp < params.m_statEdgeMinWinRate) {
            reason = StringFormat("Stat Edge Buy too low: %.1f%% < %.1f%%", winRateUp, params.m_statEdgeMinWinRate);
            return false;
         }
      } else {
         if(winRateDown < params.m_statEdgeMinWinRate) {
            reason = StringFormat("Stat Edge Sell too low: %.1f%% < %.1f%%", winRateDown, params.m_statEdgeMinWinRate);
            return false;
         }
      }
      
      return true;
   }
};

#endif
