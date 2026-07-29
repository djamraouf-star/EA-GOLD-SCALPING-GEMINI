#ifndef CROUTEURASYNCHRONE_MQH
#define CROUTEURASYNCHRONE_MQH

#include "../Contrats/IExecution.mqh"
#include <Trade/Trade.mqh>

class CRouteurAsynchrone : public IExecution {
private:
   CTrade            m_trade;
public:
                     CRouteurAsynchrone() { m_trade.SetExpertMagicNumber(777777); }
   virtual bool      EnvoyerOrdre(int type, double volume, double prix, double sl, double tp) {
      if(type == ORDER_TYPE_BUY) {
         return m_trade.Buy(volume, NULL, prix, sl, tp, "Artisan Buy");
      } else if(type == ORDER_TYPE_SELL) {
         return m_trade.Sell(volume, NULL, prix, sl, tp, "Artisan Sell");
      }
      return false;
   }
};

#endif
