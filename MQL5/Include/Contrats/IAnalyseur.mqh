//+------------------------------------------------------------------+
//|                                                   IAnalyseur.mqh |
//+------------------------------------------------------------------+
#property copyright "Artisan Scalper"

interface IAnalyseur {
public:
   virtual bool      CalculerProbabilites() = 0;
   virtual double    ObtenirScoreIQM() = 0;
};
