//+------------------------------------------------------------------+
//|                                                    MathUtils.mqh |
//+------------------------------------------------------------------+
#ifndef MATHUTILS_MQH
#define MATHUTILS_MQH

class CMathUtils
{
public:
   static double NormalizeScore(double val, double minVal, double maxVal)
   {
      if (maxVal <= minVal) return 0.0;
      double score = (val - minVal) / (maxVal - minVal);
      if (score < 0.0) score = 0.0;
      return score;
   }

   static double Clamp(double val, double minVal, double maxVal)
   {
      if (val < minVal) return minVal;
      if (val > maxVal) return maxVal;
      return val;
   }
};

#endif
