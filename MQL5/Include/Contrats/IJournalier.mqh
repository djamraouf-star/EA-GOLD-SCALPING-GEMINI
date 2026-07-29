//+------------------------------------------------------------------+
//|                                                  IJournalier.mqh |
//+------------------------------------------------------------------+
#property copyright "Artisan Scalper"

interface IJournalier {
public:
   virtual void      EcrireLog(string message, string niveau) = 0;
   virtual void      AlerteDerive(string indicateur, double chute_poids) = 0;
};
