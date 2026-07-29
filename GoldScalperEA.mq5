//+------------------------------------------------------------------+
//|                                              GoldScalperEA.mq5   |
//|                        GoldScalperEA V1.0 - XAUUSD M1 Scalper    |
//|                 Architecture Modulaire FSM (Finite State Machine)|
//+------------------------------------------------------------------+
#property copyright "GoldScalperEA V1.0 - Scalping M1 XAUUSD"
#property link      "https://ai.studio"
#property version   "1.00"
#property description "Robot d'arbitrage M1 sur l'Or basé sur une Machine à États FSM"

// Inclusions de l'architecture modulaire
#include "Include/Config/Parameters.mqh"
#include "Include/Core/Engine.mqh"

// Instance globale du moteur FSM
CEngine g_engine;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   return g_engine.OnInit();
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   g_engine.OnDeinit(reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   g_engine.OnTick();
}

//+------------------------------------------------------------------+
//| Trade Transaction function                                       |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans, const MqlTradeRequest &request, const MqlTradeResult &result)
{
   g_engine.OnTradeTransaction(trans, request, result);
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
{
   g_engine.OnTimer();
}
