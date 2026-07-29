//+------------------------------------------------------------------+
//|                                        Scalping_Experimental.mq5 |
//|                                                  Artisan Scalper |
//+------------------------------------------------------------------+
#property copyright "Artisan Scalper - Pur Terroir"
#property link      ""
#property version   "1.00"

#include "../../Include/Configuration/Parametres_Exposes.mqh"
#include "../../Include/Automate/CContexteTrading.mqh"
#include "../../Include/Automate/CEtatRepos.mqh"

// Objets globaux
CContexteTrading *g_contexte;
IAnalyseur       *g_analyseur;
IJournalier      *g_journalier;
IExecution       *g_execution;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Initialisation des Moteurs (Implémentations Concrètes)
   // g_journalier = new CAgregateurLogs();
   // g_analyseur = new CEvaluateurIQM();
   // g_execution = new CRouteurAsynchrone();
   
   // Injection de dépendances dans l'Automate
   // g_contexte = new CContexteTrading(g_analyseur, g_journalier, g_execution);
   
   // Démarrage de la machine à états sur l'état de Repos
   // g_contexte.ChangerEtat(new CEtatRepos());
   
   Print("L'Artisan Scalper est prêt (Affinage terminé).");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   // if(g_contexte != NULL) delete g_contexte;
   // if(g_analyseur != NULL) delete g_analyseur;
   // if(g_journalier != NULL) delete g_journalier;
   // if(g_execution != NULL) delete g_execution;
   Print("Extinction du four. À la prochaine !");
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   // if(g_contexte != NULL) {
   //    g_contexte.TraiterTick();
   // }
  }
//+------------------------------------------------------------------+
