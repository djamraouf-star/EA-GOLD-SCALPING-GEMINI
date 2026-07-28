//+------------------------------------------------------------------+
//|                                                 StateManager.mqh |
//+------------------------------------------------------------------+
#ifndef STATEMANAGER_MQH
#define STATEMANAGER_MQH

#include "../Statistics/Logger.mqh"

enum ENUM_FSM_STATE {
   FSM_INITIALISATION,
   FSM_ATTENTE,
   FSM_ANALYSE_MARCHE,
   FSM_SIGNAL_DETECTE,
   FSM_VALIDATION_RISQUE,
   FSM_OUVERTURE_POSITION,
   FSM_GESTION_POSITION,
   FSM_FERMETURE_POSITION
};

enum ENUM_FSM_EVENT {
   FSM_EVENT_NONE,
   FSM_EVENT_INIT_SUCCESS,
   FSM_EVENT_INIT_FAILED,
   FSM_EVENT_NEW_BAR,
   FSM_EVENT_IQM_OK,
   FSM_EVENT_IQM_REJECTED,
   FSM_EVENT_SIGNAL_BUY,
   FSM_EVENT_SIGNAL_SELL,
   FSM_EVENT_RISK_APPROVED,
   FSM_EVENT_RISK_REJECTED,
   FSM_EVENT_ORDER_OPENED,
   FSM_EVENT_ORDER_FAILED,
   FSM_EVENT_POSITION_CLOSED,
   FSM_EVENT_LIMITS_EXCEEDED
};

class CStateManager
{
private:
   ENUM_FSM_STATE m_currentState;
   ENUM_FSM_STATE m_previousState;

public:
   void Init()
   {
      m_currentState  = FSM_INITIALISATION;
      m_previousState = FSM_INITIALISATION;
   }

   ENUM_FSM_STATE GetState() const { return m_currentState; }

   void TransitionTo(ENUM_FSM_STATE newState, ENUM_FSM_EVENT evt, CLogger &logger, string comment="")
   {
      if(m_currentState != newState) {
         m_previousState = m_currentState;
         m_currentState  = newState;

         string logMsg = StringFormat("Transition FSM: [%s] -> [%s] | Event: %s | %s",
            StateToString(m_previousState),
            StateToString(m_currentState),
            EventToString(evt),
            comment);

         logger.Log("STATE", "FSM", logMsg);
      }
   }

   string StateToString(ENUM_FSM_STATE st)
   {
      switch(st) {
         case FSM_INITIALISATION:    return "INITIALISATION";
         case FSM_ATTENTE:           return "ATTENTE";
         case FSM_ANALYSE_MARCHE:    return "ANALYSE_MARCHE";
         case FSM_SIGNAL_DETECTE:    return "SIGNAL_DETECTE";
         case FSM_VALIDATION_RISQUE: return "VALIDATION_RISQUE";
         case FSM_OUVERTURE_POSITION:return "OUVERTURE_POSITION";
         case FSM_GESTION_POSITION:  return "GESTION_POSITION";
         case FSM_FERMETURE_POSITION:return "FERMETURE_POSITION";
      }
      return "UNKNOWN";
   }

   string EventToString(ENUM_FSM_EVENT evt)
   {
      switch(evt) {
         case FSM_EVENT_NONE:            return "NONE";
         case FSM_EVENT_INIT_SUCCESS:    return "INIT_SUCCESS";
         case FSM_EVENT_INIT_FAILED:     return "INIT_FAILED";
         case FSM_EVENT_NEW_BAR:         return "NEW_BAR";
         case FSM_EVENT_IQM_OK:           return "IQM_OK";
         case FSM_EVENT_IQM_REJECTED:     return "IQM_REJECTED";
         case FSM_EVENT_SIGNAL_BUY:      return "SIGNAL_BUY";
         case FSM_EVENT_SIGNAL_SELL:     return "SIGNAL_SELL";
         case FSM_EVENT_RISK_APPROVED:   return "RISK_APPROVED";
         case FSM_EVENT_RISK_REJECTED:   return "RISK_REJECTED";
         case FSM_EVENT_ORDER_OPENED:    return "ORDER_OPENED";
         case FSM_EVENT_ORDER_FAILED:    return "ORDER_FAILED";
         case FSM_EVENT_POSITION_CLOSED: return "POSITION_CLOSED";
         case FSM_EVENT_LIMITS_EXCEEDED: return "LIMITS_EXCEEDED";
      }
      return "UNKNOWN";
   }
};

#endif
