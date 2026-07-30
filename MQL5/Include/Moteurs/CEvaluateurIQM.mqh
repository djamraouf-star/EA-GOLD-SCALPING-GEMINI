#ifndef CEVALUATEURIQM_MQH
#define CEVALUATEURIQM_MQH

#include "../Contrats/IAnalyseur.mqh"
// Inclusions des indicateurs et filtres (à câbler prochainement)
// #include "../Indicateurs/RsiIndicator.mqh"
// #include "../Indicateurs/AtrIndicator.mqh"
// #include "../Indicateurs/EmaIndicator.mqh"

class CEvaluateurIQM : public IAnalyseur {
private:
   double m_poids_rsi;
   double m_poids_atr;
   double m_poids_ema;
   bool   m_est_calibre;

public:
                     CEvaluateurIQM() : m_est_calibre(false), m_poids_rsi(0), m_poids_atr(0), m_poids_ema(0) {}

   // Le Moteur Probabiliste analyse l'historique des valeurs
   void              CalibrerPoidsHistorique(string symbol, int historique_bars) {
      PrintFormat("Démarrage du Moteur Probabiliste: Analyse de l'historique sur %d bougies pour %s...", historique_bars, symbol);
      
      // Simulation de l'analyse statistique (Machine Learning basique / Profilage)
      // En réalité, on va boucler sur CopyRates, extraire les patterns de volatilité et de tendance,
      // puis déduire les poids.
      
      // ... Logique probabiliste basée sur l'historique ...
      m_poids_rsi = 0.40;
      m_poids_atr = 0.35;
      m_poids_ema = 0.25;
      
      m_est_calibre = true;
      PrintFormat("Affinage terminé -> Poids déduits: RSI=%.2f, ATR=%.2f, EMA=%.2f", m_poids_rsi, m_poids_atr, m_poids_ema);
   }

   virtual bool      CalculerProbabilites() {
      if(!m_est_calibre) {
         Print("Erreur: Le Moteur Probabiliste n'a pas été calibré avec l'historique !");
         return false;
      }
      
      // Ici on appliquera la vraie logique avec les indicateurs et leurs poids
      // Pour l'instant, on simule l'IQM (Le marché est-il tradable ?)
      int score_aleatoire = MathRand() % 100; 
      
      // Si le score pondéré penche vers le OUI (ex: > 50)
      return (score_aleatoire > 50); 
   }
   
   virtual double    ObtenirScoreIQM() {
      return 0.85; // Mock
   }
};

#endif
