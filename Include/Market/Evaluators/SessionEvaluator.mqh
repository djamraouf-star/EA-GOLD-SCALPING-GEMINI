//+------------------------------------------------------------------+
//|                                             SessionEvaluator.mqh |
//+------------------------------------------------------------------+
#ifndef SESSIONEVALUATOR_MQH
#define SESSIONEVALUATOR_MQH

#include "IIQMEvaluator.mqh"
#include "../../Utils/TimeUtils.mqh"

class CSessionEvaluator : public IIQMEvaluator
{
public:
   virtual double Evaluate(const CMarketContext& ctx, const CParameters& params) override
   {
      if(!params.m_enableSessionFilter) return 1.0;
      
      // Protection Rollover (23h00 - 01h00): Spreads bancaires élargis
      MqlDateTime dt;
      TimeToStruct(TimeCurrent(), dt);
      if(dt.hour == 23 || dt.hour == 0) return 0.2; // Pénalité rollover
      
      bool inLondon = CTimeUtils::IsWithinHours(8, 17);
      bool inNY     = CTimeUtils::IsWithinHours(13, 21);
      bool inAsia   = CTimeUtils::IsWithinHours(1, 7);
      
      if(inLondon && inNY) return 1.0;  // Overlap Londres / NY
      if(inLondon)         return 0.9;  // Londres
      if(inNY)             return 0.8;  // NY
      if(inAsia)           return 0.7;  // Asie / Pré-Europe (Très rentable sur Gold si spread bas)
      
      return 0.5;
   }
   
   virtual string Name() override { return "Session"; }
};

#endif
