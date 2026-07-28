//+------------------------------------------------------------------+
//|                                                    BreakEven.mqh |
//+------------------------------------------------------------------+
#ifndef BREAKEVEN_MQH
#define BREAKEVEN_MQH

#include "../Config/Parameters.mqh"
#include "../Utils/PriceUtils.mqh"

class CBreakEven
{
public:
   static double CalculateBreakEvenPrice(ENUM_POSITION_TYPE type, double openPrice, double currentSL, const CParameters &params, string symbol)
   {
      double point = CPriceUtils::GetPoint(symbol);
      if(point <= 0) return currentSL;

      double lockDistance = params.m_breakEvenLockPoints * point;
      double newSL = (type == POSITION_TYPE_BUY) ? (openPrice + lockDistance) : (openPrice - lockDistance);

      bool isBetter = (type == POSITION_TYPE_BUY) ? (currentSL == 0 || newSL > currentSL)
                                                  : (currentSL == 0 || newSL < currentSL);

      return isBetter ? CPriceUtils::NormalizePrice(symbol, newSL) : currentSL;
   }
};

#endif
