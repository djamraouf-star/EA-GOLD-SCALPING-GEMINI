#ifndef ETATS_MQH
#define ETATS_MQH

#include "../Contrats/IEtat.mqh"
#include "CContexteTrading.mqh"

// Forward declarations
class CEtatRepos;
class CEtatAnalyse;
class CEtatExecution;

//--- CEtatRepos
class CEtatRepos : public IEtat {
private:
   datetime m_last_check;
public:
   virtual void      OnTick(CContexteTrading *contexte);
   virtual void      Entrer(CContexteTrading *contexte);
   virtual void      Sortir(CContexteTrading *contexte);
};

//--- CEtatAnalyse
class CEtatAnalyse : public IEtat {
public:
   virtual void      OnTick(CContexteTrading *contexte);
   virtual void      Entrer(CContexteTrading *contexte);
   virtual void      Sortir(CContexteTrading *contexte);
};

//--- CEtatExecution
class CEtatExecution : public IEtat {
public:
   virtual void      OnTick(CContexteTrading *contexte);
   virtual void      Entrer(CContexteTrading *contexte);
   virtual void      Sortir(CContexteTrading *contexte);
};

//--- Implémentations CEtatRepos
void CEtatRepos::Entrer(CContexteTrading *contexte) {
   m_last_check = TimeCurrent();
}
void CEtatRepos::Sortir(CContexteTrading *contexte) {}
void CEtatRepos::OnTick(CContexteTrading *contexte) {
   // Pour la démo, on lance une analyse toutes les 4 heures
   if(TimeCurrent() - m_last_check > 14400) { 
      contexte.ChangerEtat(new CEtatAnalyse());
   }
}

//--- Implémentations CEtatAnalyse
void CEtatAnalyse::Entrer(CContexteTrading *contexte) {
   contexte.GetJournalier().EcrireLog("Dégustation des probabilités (Analyse IQM)...", "INFO");
}
void CEtatAnalyse::Sortir(CContexteTrading *contexte) {}
void CEtatAnalyse::OnTick(CContexteTrading *contexte) {
   if(contexte.GetAnalyseur().CalculerProbabilites()) {
      contexte.ChangerEtat(new CEtatExecution());
   } else {
      contexte.ChangerEtat(new CEtatRepos());
   }
}

//--- Implémentations CEtatExecution
void CEtatExecution::Entrer(CContexteTrading *contexte) {
   contexte.GetJournalier().EcrireLog("Le cru est bon ! Passage à l'acte (Envoi de l'ordre).", "INFO");
   
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   
   // Achat basique pour la démo
   contexte.GetExecution().EnvoyerOrdre(ORDER_TYPE_BUY, 0.01, ask, bid - 100 * point, ask + 100 * point);
   
   contexte.ChangerEtat(new CEtatRepos());
}
void CEtatExecution::Sortir(CContexteTrading *contexte) {
   contexte.GetJournalier().EcrireLog("Bouteille refermée. Retour au cellier.", "INFO");
}
void CEtatExecution::OnTick(CContexteTrading *contexte) {
   // Vide, on est déjà retourné en repos via Entrer()
}

#endif
