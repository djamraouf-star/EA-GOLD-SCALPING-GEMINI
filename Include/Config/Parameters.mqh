//+------------------------------------------------------------------+
//|                                                   Parameters.mqh |
//|                        GoldScalperEA V1.0 - Config & Parameters  |
//+------------------------------------------------------------------+
#ifndef PARAMETERS_MQH
#define PARAMETERS_MQH

// --- PARAMÈTRES D'ENTRÉE DU ROBOT ---
input group "=== 1. PARAMÈTRES GÉNÉRAUX ==="
input ulong          InpMagicNumber          = 888101;         // Magic Number unique
input double         InpLotSize              = 0.01;          // Lot Fixe (Si RiskAuto = false)
input bool           InpUseAutoRisk          = true;       // Calcul Automatique de Lot par Risk %
input double         InpRiskPercent          = 1;          // % du Solde risqué par Trade
input int            InpMaxSlippagePoints    = 20;          // Slippage Max toléré (points)

input group "=== 2. INDICE DE QUALITÉ DU MARCHÉ (IQM) ==="
input double         InpMinMarketScore       = 55;        // Score IQM Minimum pour Trader (0 - 100)
input double         InpMaxSpreadPoints      = 60;        // Spread Max Autorisé (points)
input double         InpMinAtrSpreadRatio    = 2.5;       // Ratio Min ATR / Spread (0.0 = Désactivé)

input group "=== 3. ARMEE ET ADAPTATION DU STOP LOSS (SL/TP) ==="
input double         InpSlAtrMultiplier      = 1.2;        // Coefficient SL ATR Initial (Ex: 1.30)
input bool           InpEnableDynamicIqmSl   = true; // Adaptation SL selon IQM
input double         InpMinSlPoints          = 40;            // Borne Minimum du Stop Loss (points)
input double         InpMaxSlPoints          = 250;            // Borne Maximum Cap du Stop Loss (points)
input double         InpTp1AtrMultiplier     = 2.2;        // Multiplicateur TP1 (ATR)

input group "=== 4. GESTION DYNAMIQUE DE POSITION ==="
input bool           InpEnablePartialClose   = true;       // Clôture Partielle à TP1
input double         InpPartialClosePercent  = 50;       // % à clôturer à TP1
input bool           InpEnableBreakEven      = true;       // Passage au Break Even
input double         InpBreakEvenAtrTrigger  = 0.7;       // Déclencheur BE (Multiplicateur ATR)
input double         InpBreakEvenLockPoints  = 10;        // Points de profit garantis au BE
input bool           InpEnableTrailingStop   = true;       // Trailing Stop ATR
input double         InpTrailingStartAtr     = 1.1;       // Trailing Start (ATR)
input double         InpTrailingStepAtr      = 0.3;        // Trailing Step (ATR)

input group "=== 5. INDICATEURS ET POIDS STRATÉGIQUES ==="
input int            InpAtrPeriod            = 14;          // Période ATR
input double         InpMinAtrPoints         = 5;       // Volatilité Minimum (Points)
input int            InpEmaFastPeriod        = 9;          // Période EMA Rapide
input int            InpEmaSlowPeriod        = 21;          // Période EMA Lente
input int            InpRsiPeriod            = 14;          // Période RSI
input double         InpRsiBuyThreshold      = 50;    // Seuil RSI Achat
input double         InpRsiSellThreshold     = 50;   // Seuil RSI Vente
input double         InpWeightSpread         = 33;       // Poids du Spread dans l'IQM
input double         InpWeightAtr            = 22;          // Poids de la Volatilité (ATR)
input double         InpWeightTrend          = 11;        // Poids de la Tendance dans l'IQM
input double         InpWeightRsi            = 16;          // Poids du RSI Momentum dans l'IQM
input double         InpWeightSession        = 11;       // Poids de la Session
input double         InpWeightCandles        = 2;        // Poids des Bougies
input double         InpWeightPullback       = 5;       // Poids du Pullback

input group "=== 6. LIMITES D'EXPOSITION JOURNALIÈRE ==="
input bool           InpEnableDailyLimits    = true;       // Activer les Limites Journalières
input double         InpMaxDailyLossAmount   = 150;       // Perte Max Journalière ($)
input double         InpMaxDailyProfitAmount = 400;     // Objectif Profit Journalier ($)
input int            InpMaxDailyTrades       = 12;          // Nombre Max de Trades / Jour
input int            InpPauseAfterLosses     = 2; // Nb Pertes avant Pause
input int            InpPauseDurationMin     = 30;    // Durée de la Pause (Min)

input group "=== 7. FILTRES HORAIRES ET SESSIONS ==="
input bool           InpEnableSessionFilter  = false;     // Activer les Filtres de Session
input string         InpLondonStart          = "08:00";       // Début Session Londres
input string         InpLondonEnd            = "17:30";         // Fin Session Londres
input string         InpNyStart              = "14:30";           // Début Session NY
input string         InpNyEnd                = "21:00";             // Fin Session NY
input bool           InpFilterAsianSession   = false;      // Interdire Session Asiatique

class CParameters
{
public:
   ulong    m_magicNumber;
   double   m_lotSize;
   bool     m_useAutoRisk;
   double   m_riskPercent;
   int      m_maxSlippagePoints;

   double   m_minMarketScore;
   double   m_maxSpreadPoints;
   double   m_minAtrSpreadRatio;

   double   m_slAtrMultiplier;
   bool     m_enableDynamicIqmSl;
   double   m_minSlPoints;
   double   m_maxSlPoints;
   double   m_tp1AtrMultiplier;

   bool     m_enablePartialClose;
   double   m_partialClosePercent;
   bool     m_enableBreakEven;
   double   m_breakEvenAtrTrigger;
   double   m_breakEvenLockPoints;
   bool     m_enableTrailingStop;
   double   m_trailingStartAtr;
   double   m_trailingStepAtr;

   int      m_atrPeriod;
   double   m_minAtrPoints;
   int      m_emaFastPeriod;
   int      m_emaSlowPeriod;
   int      m_rsiPeriod;
   double   m_rsiBuyThreshold;
   double   m_rsiSellThreshold;
   double   m_weightSpread;
   double   m_weightAtr;
   double   m_weightTrend;
   double   m_weightRsi;
   double   m_weightSession;
   double   m_weightCandles;
   double   m_weightPullback;

   bool     m_enableDailyLimits;
   double   m_maxDailyLossAmount;
   double   m_maxDailyProfitAmount;
   int      m_maxDailyTrades;
   int      m_pauseAfterLosses;
   int      m_pauseDurationMin;

   bool     m_enableSessionFilter;
   string   m_londonStart;
   string   m_londonEnd;
   string   m_nyStart;
   string   m_nyEnd;
   bool     m_filterAsianSession;

   bool Init()
   {
      m_magicNumber          = InpMagicNumber;
      m_lotSize              = InpLotSize;
      m_useAutoRisk          = InpUseAutoRisk;
      m_riskPercent          = InpRiskPercent;
      m_maxSlippagePoints    = InpMaxSlippagePoints;

      m_minMarketScore       = MathMax(0.0, InpMinMarketScore);
      m_maxSpreadPoints      = MathMax(1.0, InpMaxSpreadPoints);
      m_minAtrSpreadRatio    = MathMax(0.0, InpMinAtrSpreadRatio);

      m_slAtrMultiplier      = InpSlAtrMultiplier;
      m_enableDynamicIqmSl   = InpEnableDynamicIqmSl;
      m_minSlPoints          = InpMinSlPoints;
      m_maxSlPoints          = InpMaxSlPoints;
      m_tp1AtrMultiplier     = InpTp1AtrMultiplier;

      m_enablePartialClose   = InpEnablePartialClose;
      m_partialClosePercent  = InpPartialClosePercent;
      m_enableBreakEven      = InpEnableBreakEven;
      m_breakEvenAtrTrigger  = InpBreakEvenAtrTrigger;
      m_breakEvenLockPoints  = InpBreakEvenLockPoints;
      m_enableTrailingStop   = InpEnableTrailingStop;
      m_trailingStartAtr     = InpTrailingStartAtr;
      m_trailingStepAtr      = InpTrailingStepAtr;

      m_atrPeriod            = InpAtrPeriod;
      m_minAtrPoints         = InpMinAtrPoints;
      m_emaFastPeriod        = InpEmaFastPeriod;
      m_emaSlowPeriod        = InpEmaSlowPeriod;
      m_rsiPeriod            = InpRsiPeriod;
      m_rsiBuyThreshold      = InpRsiBuyThreshold;
      m_rsiSellThreshold     = InpRsiSellThreshold;
      m_weightSpread         = MathMax(0.0, InpWeightSpread);
      m_weightAtr            = MathMax(0.0, InpWeightAtr);
      m_weightTrend          = MathMax(0.0, InpWeightTrend);
      m_weightRsi            = MathMax(0.0, InpWeightRsi);
      m_weightSession        = MathMax(0.0, InpWeightSession);
      m_weightCandles        = MathMax(0.0, InpWeightCandles);
      m_weightPullback       = MathMax(0.0, InpWeightPullback);

      m_enableDailyLimits    = InpEnableDailyLimits;
      m_maxDailyLossAmount   = InpMaxDailyLossAmount;
      m_maxDailyProfitAmount = InpMaxDailyProfitAmount;
      m_maxDailyTrades       = InpMaxDailyTrades;
      m_pauseAfterLosses     = InpPauseAfterLosses;
      m_pauseDurationMin     = InpPauseDurationMin;

      m_enableSessionFilter  = InpEnableSessionFilter;
      m_londonStart          = InpLondonStart;
      m_londonEnd            = InpLondonEnd;
      m_nyStart              = InpNyStart;
      m_nyEnd                = InpNyEnd;
      m_filterAsianSession   = InpFilterAsianSession;

      return true;
   }
};

#endif
