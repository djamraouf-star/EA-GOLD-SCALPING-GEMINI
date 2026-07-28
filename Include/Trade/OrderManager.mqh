//+------------------------------------------------------------------+
//|                                                 OrderManager.mqh |
//+------------------------------------------------------------------+
#ifndef ORDERMANAGER_MQH
#define ORDERMANAGER_MQH

#include <Trade\Trade.mqh>
#include "../Statistics/Logger.mqh"

class COrderManager
{
private:
   CTrade m_trade;

public:
   void Init(ulong magicNumber, int deviation)
   {
      m_trade.SetExpertMagicNumber(magicNumber);
      m_trade.SetDeviationInPoints(deviation);
      m_trade.SetTypeFilling(ORDER_FILLING_FOK);
   }

   ulong OpenBuy(string symbol, double volume, double price, double sl, double tp, CLogger &logger)
   {
      logger.Log("INFO", "OrderManager", StringFormat("Envoi ordre BUY: Vol=%.2f, Price=%.2f, SL=%.2f, TP=%.2f", volume, price, sl, tp));
      if(m_trade.Buy(volume, symbol, price, sl, tp, "GoldScalperEA_Buy")) {
         return m_trade.ResultOrder();
      }
      logger.Log("ERROR", "OrderManager", "Échec d'ouverture BUY. Code: " + IntegerToString(m_trade.ResultRetcode()));
      return 0;
   }

   ulong OpenSell(string symbol, double volume, double price, double sl, double tp, CLogger &logger)
   {
      logger.Log("INFO", "OrderManager", StringFormat("Envoi ordre SELL: Vol=%.2f, Price=%.2f, SL=%.2f, TP=%.2f", volume, price, sl, tp));
      if(m_trade.Sell(volume, symbol, price, sl, tp, "GoldScalperEA_Sell")) {
         return m_trade.ResultOrder();
      }
      logger.Log("ERROR", "OrderManager", "Échec d'ouverture SELL. Code: " + IntegerToString(m_trade.ResultRetcode()));
      return 0;
   }

   bool ClosePartial(ulong ticket, double volume, CLogger &logger)
   {
      if(m_trade.PositionClosePartial(ticket, volume)) {
         logger.Log("INFO", "OrderManager", StringFormat("Clôture partielle réussie sur ticket #%d: Vol=%.2f", ticket, volume));
         return true;
      }
      logger.Log("ERROR", "OrderManager", StringFormat("Échec clôture partielle sur ticket #%d", ticket));
      return false;
   }

   bool ModifySLTP(ulong ticket, double sl, double tp, CLogger &logger)
   {
      if(m_trade.PositionModify(ticket, sl, tp)) {
         logger.Log("INFO", "OrderManager", StringFormat("Modification SL/TP réussie ticket #%d: SL=%.2f, TP=%.2f", ticket, sl, tp));
         return true;
      }
      return false;
   }
};

#endif
