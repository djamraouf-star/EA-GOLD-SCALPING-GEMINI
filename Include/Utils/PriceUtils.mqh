//+------------------------------------------------------------------+
//|                                                   PriceUtils.mqh |
//+------------------------------------------------------------------+
#ifndef PRICEUTILS_MQH
#define PRICEUTILS_MQH

class CPriceUtils
{
public:
   static double NormalizePrice(string symbol, double price)
   {
      int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
      return NormalizeDouble(price, digits);
   }

   static double GetPoint(string symbol)
   {
      return SymbolInfoDouble(symbol, SYMBOL_POINT);
   }
};

#endif
