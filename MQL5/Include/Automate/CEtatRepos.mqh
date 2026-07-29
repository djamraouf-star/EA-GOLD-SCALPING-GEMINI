//+------------------------------------------------------------------+
//|                                                   CEtatRepos.mqh |
//+------------------------------------------------------------------+
#property copyright "Artisan Scalper"

#include "../Contrats/IEtat.mqh"
#include "CContexteTrading.mqh"

class CEtatRepos : public IEtat {
public:
   virtual void      OnTick(CContexteTrading *contexte);
   virtual void      Entrer(CContexteTrading *contexte);
   virtual void      Sortir(CContexteTrading *contexte);
};

void CEtatRepos::Entrer(CContexteTrading *contexte) {
   contexte.GetJournalier().EcrireLog("Entrée en phase de repos. Attente de conditions propices...", "INFO");
}

void CEtatRepos::Sortir(CContexteTrading *contexte) {
   contexte.GetJournalier().EcrireLog("Sortie du repos. Dégustation imminente.", "INFO");
}

void CEtatRepos::OnTick(CContexteTrading *contexte) {
   // Vérification préliminaire (ex: Spread)
   // Transition vers CEtatAnalyse si OK
}
