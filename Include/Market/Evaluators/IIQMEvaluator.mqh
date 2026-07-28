//+------------------------------------------------------------------+
//|                                             IIQMEvaluator.mqh    |
//+------------------------------------------------------------------+
#ifndef IIQMEVALUATOR_MQH
#define IIQMEVALUATOR_MQH

#include "../../Core/Context.mqh"
#include "../../Config/Parameters.mqh"

class IIQMEvaluator
{
public:
   virtual double Evaluate(const CMarketContext& ctx, const CParameters& params) = 0;
   virtual string Name() = 0;
};

#endif
