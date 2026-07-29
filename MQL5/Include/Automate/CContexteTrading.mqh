//+------------------------------------------------------------------+
//|                                             CContexteTrading.mqh |
//+------------------------------------------------------------------+
#property copyright "Artisan Scalper"

#include "../Contrats/IEtat.mqh"
#include "../Contrats/IAnalyseur.mqh"
#include "../Contrats/IJournalier.mqh"
#include "../Contrats/IExecution.mqh"

class CContexteTrading {
private:
   IEtat          *m_etat_actuel;
   IAnalyseur     *m_analyseur;
   IJournalier    *m_journalier;
   IExecution     *m_execution;

public:
                     CContexteTrading(IAnalyseur *analyseur, IJournalier *journalier, IExecution *execution);
                    ~CContexteTrading();
                    
   void              ChangerEtat(IEtat *nouvel_etat);
   void              TraiterTick();
   
   IAnalyseur*       GetAnalyseur() { return m_analyseur; }
   IJournalier*      GetJournalier() { return m_journalier; }
   IExecution*       GetExecution() { return m_execution; }
};

CContexteTrading::CContexteTrading(IAnalyseur *analyseur, IJournalier *journalier, IExecution *execution) {
   m_analyseur = analyseur;
   m_journalier = journalier;
   m_execution = execution;
   m_etat_actuel = NULL;
}

CContexteTrading::~CContexteTrading() {
   if (m_etat_actuel != NULL) delete m_etat_actuel;
}

void CContexteTrading::ChangerEtat(IEtat *nouvel_etat) {
   if (m_etat_actuel != NULL) {
      m_etat_actuel.Sortir(GetPointer(this));
      delete m_etat_actuel;
   }
   m_etat_actuel = nouvel_etat;
   if (m_etat_actuel != NULL) {
      m_etat_actuel.Entrer(GetPointer(this));
   }
}

void CContexteTrading::TraiterTick() {
   if (m_etat_actuel != NULL) {
      m_etat_actuel.OnTick(GetPointer(this));
   }
}
