//+------------------------------------------------------------------+
//|                                                   IExecution.mqh |
//+------------------------------------------------------------------+
#property copyright "Artisan Scalper"

interface IExecution {
public:
   virtual bool      EnvoyerOrdre(int type, double volume, double prix, double sl, double tp) = 0;
};
