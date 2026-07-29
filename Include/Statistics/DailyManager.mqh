//+------------------------------------------------------------------+
//|                                                 DailyManager.mqh |
//+------------------------------------------------------------------+
#ifndef DAILYMANAGER_MQH
#define DAILYMANAGER_MQH

#include "../Config/Parameters.mqh"
#include "Logger.mqh"

class CDailyManager
{
private:
   datetime m_currentDay;
   double   m_dailyProfit;
   int      m_dailyTrades;
   int      m_consecutiveLosses;
   datetime m_pauseUntil;

public:
   CDailyManager() : m_currentDay(0), m_dailyProfit(0), m_dailyTrades(0), m_consecutiveLosses(0), m_pauseUntil(0) {}

   void Init(const CParameters &params)
   {
      CheckNewDay();
   }

   void CheckNewDay()
   {
      MqlDateTime dt;
      TimeToStruct(TimeCurrent(), dt);
      datetime today = StructToTime(dt) - (dt.hour * 3600 + dt.min * 60 + dt.sec);

      if(today != m_currentDay) {
         m_currentDay = today;
         m_dailyProfit = 0.0;
         m_dailyTrades = 0;
         m_consecutiveLosses = 0;
         m_pauseUntil = 0;
      }
   }

   bool CanTrade()
   {
      CheckNewDay();
      if(TimeCurrent() < m_pauseUntil) return false;
      return true;
   }

   bool CanTradeToday(const CParameters &params, CLogger &logger)
   {
      CheckNewDay();

      if(!params.m_enableDailyLimits) return true;

      if(TimeCurrent() < m_pauseUntil) {
         logger.Log("WARN", "DailyManager", "EA en pause suite à pertes consécutives.");
         return false;
      }

      if(params.m_maxDailyLossAmount > 0 && m_dailyProfit <= -params.m_maxDailyLossAmount) {
         logger.Log("WARN", "DailyManager", StringFormat("Limite perte journalière atteinte: %.2f $", m_dailyProfit));
         return false;
      }

      if(params.m_maxDailyProfitAmount > 0 && m_dailyProfit >= params.m_maxDailyProfitAmount) {
         logger.Log("INFO", "DailyManager", StringFormat("Objectif profit journalier atteint: %.2f $", m_dailyProfit));
         return false;
      }

      if(params.m_maxDailyTrades > 0 && m_dailyTrades >= params.m_maxDailyTrades) {
         logger.Log("WARN", "DailyManager", StringFormat("Nombre max de trades atteint aujourd'hui: %d", m_dailyTrades));
         return false;
      }

      return true;
   }

   void RegisterClosedTrade(double profit)
   {
      CheckNewDay();
      m_dailyProfit += profit;
      m_dailyTrades++;

      if(profit < 0) {
         m_consecutiveLosses++;
      } else {
         m_consecutiveLosses = 0;
      }
   }
};

#endif
