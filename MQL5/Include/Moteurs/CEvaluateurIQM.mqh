#ifndef CEVALUATEURIQM_MQH
#define CEVALUATEURIQM_MQH

#include "../Contrats/IAnalyseur.mqh"

class CEvaluateurIQM : public IAnalyseur {
public:
   virtual bool      CalculerProbabilites() {
      // Simulation artisanale : 1 chance sur 5 de trouver une belle pomme (opportunité)
      return (MathRand() % 5 == 0); 
   }
   virtual double    ObtenirScoreIQM() {
      return 0.85; 
   }
};

#endif
