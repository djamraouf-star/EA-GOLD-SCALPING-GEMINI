//+------------------------------------------------------------------+
//|                                                       Engine.mqh |
//+------------------------------------------------------------------+
#ifndef ENGINE_MQH
#define ENGINE_MQH

#include "../Config/Parameters.mqh"
#include "Context.mqh"
#include "StateManager.mqh"
#include "../Market/MarketFilter.mqh"
#include "../Signals/SignalManager.mqh"
#include "../Risk/RiskManager.mqh"
#include "../Trade/OrderManager.mqh"
#include "../Trade/PositionManager.mqh"
#include "../Statistics/DailyManager.mqh"
#include "../Statistics/Logger.mqh"
#include "../Utils/TimeUtils.mqh"

class CEngine
{
private:
   datetime             m_lastBarTime;

   CParameters          m_params;
   CLogger              m_logger;
   CStateManager        m_stateManager;
   CMarketContext       m_context;
   CMarketFilter        m_marketFilter;
   CSignalManager       m_signalManager;
   CRiskManager         m_riskManager;
   COrderManager        m_orderManager;
   CPositionManager     m_positionManager;
   CDailyManager        m_dailyManager;

public:
   CEngine() : m_lastBarTime(0) {}

   int OnInit()
   {
      m_logger.Init("GoldScalperEA_FSM");
      m_stateManager.Init();
      m_stateManager.TransitionTo(FSM_INITIALISATION, FSM_EVENT_NONE, m_logger, "Démarrage du moteur FSM GoldScalperEA...");

      if(!m_params.Init()) {
         m_logger.Log("ERROR", "Engine", "Échec du chargement des paramètres.");
         m_stateManager.TransitionTo(FSM_INITIALISATION, FSM_EVENT_INIT_FAILED, m_logger, "Paramètres invalides");
         return INIT_FAILED;
      }

      if(!m_context.Init(Symbol(), Period(), m_params)) {
         m_logger.Log("ERROR", "Engine", "Échec d'initialisation du MarketContext.");
         m_stateManager.TransitionTo(FSM_INITIALISATION, FSM_EVENT_INIT_FAILED, m_logger, "Context invalide");
         return INIT_FAILED;
      }

      m_orderManager.Init(m_params.m_magicNumber, m_params.m_maxSlippagePoints);
      m_dailyManager.Init(m_params);

      m_stateManager.TransitionTo(FSM_ATTENTE, FSM_EVENT_INIT_SUCCESS, m_logger, "Initialisation FSM réussie.");
      return INIT_SUCCEEDED;
   }

   void OnDeinit(const int reason)
   {
      m_logger.Log("INFO", "Engine", StringFormat("Fermeture du Moteur FSM. Raison: %d", reason));
      m_context.Deinit();
      m_logger.Deinit();
   }

   void OnTick()
   {
      if(!m_context.UpdateTick()) return;

      m_positionManager.ManagePositions(m_context, m_params, m_orderManager, m_logger);

      if(!CTimeUtils::IsNewBar(Symbol(), Period(), m_lastBarTime)) return;

      m_stateManager.TransitionTo(FSM_ANALYSE_MARCHE, FSM_EVENT_NEW_BAR, m_logger, "Nouvelle bougie M1 détectée");

      if(!m_dailyManager.CanTradeToday(m_params, m_logger)) {
         m_stateManager.TransitionTo(FSM_ATTENTE, FSM_EVENT_LIMITS_EXCEEDED, m_logger, "Limites journalières atteintes");
         return;
      }

      SIQMResult iqm = m_marketFilter.CalculateScore(m_context, m_params, GetPointer(m_dailyManager));
      m_context.m_iqmResult = iqm;
      m_context.m_marketQualityScore = iqm.finalScore;

      m_logger.Log("INFO", "IQM", StringFormat("Spread: %.1f, ATR: %.1f, Trend: %.1f, RSI: %.1f, Session: %.1f, Candle: %.1f, PB: %.1f -> Total: %.1f/100",
         iqm.spreadScore * 100, iqm.atrScore * 100, iqm.trendScore * 100, iqm.rsiScore * 100, iqm.sessionScore * 100, iqm.candleScore * 100, iqm.pullbackScore * 100, iqm.finalScore));

      if(!iqm.marketAllowed) {
         m_stateManager.TransitionTo(FSM_ATTENTE, FSM_EVENT_IQM_REJECTED, m_logger, StringFormat("Marché refusé par IQM: %s", iqm.rejectReason));
         return;
      }

      m_logger.Log("INFO", "Engine", StringFormat("IQM Validé: %.1f >= %.1f", iqm.finalScore, m_params.m_minMarketScore));

      ENUM_SIGNAL_TYPE signal = m_signalManager.CheckSignal(m_context);
      if(signal == SIGNAL_NONE) {
         m_stateManager.TransitionTo(FSM_ATTENTE, FSM_EVENT_NONE, m_logger, "Aucun signal EMA/RSI");
         return;
      }

      ENUM_FSM_EVENT sigEvt = (signal == SIGNAL_BUY) ? FSM_EVENT_SIGNAL_BUY : FSM_EVENT_SIGNAL_SELL;
      m_stateManager.TransitionTo(FSM_SIGNAL_DETECTE, sigEvt, m_logger, 
         StringFormat("Signal Détecté: %s (IQM: %.1f)", (signal == SIGNAL_BUY ? "BUY" : "SELL"), iqm.finalScore));

      m_stateManager.TransitionTo(FSM_VALIDATION_RISQUE, FSM_EVENT_NONE, m_logger, "Calcul du lot et des niveaux SL/TP");
      TradeRiskParams riskParams;
      if(!m_riskManager.PrepareTrade(signal, m_context, m_params, riskParams)) {
         m_stateManager.TransitionTo(FSM_ATTENTE, FSM_EVENT_RISK_REJECTED, m_logger, "Validation du risque échouée");
         return;
      }

      m_stateManager.TransitionTo(FSM_OUVERTURE_POSITION, FSM_EVENT_RISK_APPROVED, m_logger, 
         StringFormat("Préparation envoi ordre: %s %.2f lots", (signal == SIGNAL_BUY ? "BUY" : "SELL"), riskParams.lots));

      ulong ticket = 0;
      if(riskParams.type == POSITION_TYPE_BUY) {
         ticket = m_orderManager.OpenBuy(m_context.m_symbol, riskParams.lots, riskParams.price, riskParams.sl, riskParams.tp, m_logger);
      } else {
         ticket = m_orderManager.OpenSell(m_context.m_symbol, riskParams.lots, riskParams.price, riskParams.sl, riskParams.tp, m_logger);
      }

      if(ticket > 0) {
         m_stateManager.TransitionTo(FSM_GESTION_POSITION, FSM_EVENT_ORDER_OPENED, m_logger, StringFormat("Ticket #%d ouvert", ticket));
      } else {
         m_stateManager.TransitionTo(FSM_ATTENTE, FSM_EVENT_ORDER_FAILED, m_logger, "Échec ouverture ordre");
      }
   }

   void OnTradeTransaction(const MqlTradeTransaction &trans, const MqlTradeRequest &request, const MqlTradeResult &result)
   {
      if(trans.type == TRADE_TRANSACTION_DEAL_ADD) {
         if(HistoryDealSelect(trans.deal)) {
            long entry = HistoryDealGetInteger(trans.deal, DEAL_ENTRY);
            if(entry == DEAL_ENTRY_OUT || entry == DEAL_ENTRY_OUT_BY) {
               double profit = HistoryDealGetDouble(trans.deal, DEAL_PROFIT);
               m_dailyManager.RegisterClosedTrade(profit);
               m_stateManager.TransitionTo(FSM_ATTENTE, FSM_EVENT_POSITION_CLOSED, m_logger, StringFormat("Trade Clôturé. Profit: %.2f $", profit));
            }
         }
      }
   }

   void OnTimer()
   {
      m_dailyManager.CheckNewDay();
   }

   ENUM_FSM_STATE GetState() const { return m_stateManager.GetState(); }
   CStateManager* GetStateManager() { return &m_stateManager; }
};

#endif
