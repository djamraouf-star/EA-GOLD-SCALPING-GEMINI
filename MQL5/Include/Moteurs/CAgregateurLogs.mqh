#ifndef CAGREGATEURLOGS_MQH
#define CAGREGATEURLOGS_MQH

#include "../Contrats/IJournalier.mqh"

class CAgregateurLogs : public IJournalier {
public:
   virtual void      EcrireLog(string message, string niveau) {
      PrintFormat("[%s] %s", niveau, message);
   }
   virtual void      AlerteDerive(string indicateur, double chute_poids) {
      PrintFormat("[ALERTE] Dérive sur %s : chute de %f", indicateur, chute_poids);
   }
};

#endif
