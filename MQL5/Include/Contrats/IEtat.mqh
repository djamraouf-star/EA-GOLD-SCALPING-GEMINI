//+------------------------------------------------------------------+
//|                                                        IEtat.mqh |
//+------------------------------------------------------------------+
#property copyright "Artisan Scalper"

class CContexteTrading;

interface IEtat {
public:
   virtual void      OnTick(CContexteTrading *contexte) = 0;
   virtual void      Entrer(CContexteTrading *contexte) = 0;
   virtual void      Sortir(CContexteTrading *contexte) = 0;
};
