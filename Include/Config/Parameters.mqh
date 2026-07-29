//+------------------------------------------------------------------+
//|                                                   Parameters.mqh |
//|                        GoldScalperEA V1.0 - Config & Parameters  |
//+------------------------------------------------------------------+
#ifndef PARAMETERS_MQH
#define PARAMETERS_MQH

// --- PARAMÈTRES D'ENTRÉE DU ROBOT ---
input group "=== 1. PARAMÈTRES GÉNÉRAUX ==="
input ulong          InpMagicNumber          = 888101;         // [InpMagicNumber] Magic Number unique
input double         InpLotSize              = 0.01;          // [InpLotSize] Lot Fixe (Si RiskAuto = false)
input bool           InpUseAutoRisk          = true;       // [InpUseAutoRisk] Calcul Automatique de Lot par Risk %
input double         InpRiskPercent          = 1;          // [InpRiskPercent] % du Solde risqué par Trade
input int            InpMaxSlippagePoints    = 20;          // [InpMaxSlippagePoints] Slippage Max toléré (points)

input group "=== 2. INDICE DE QUALITÉ DU MARCHÉ (IQM) ==="
input double         InpMinMarketScore       = 71.5;        // [InpMinMarketScore] Score IQM Minimum pour Trader (0 - 100)
input double         InpMaxSpreadPoints      = 60;        // [InpMaxSpreadPoints] Spread Max Autorisé (points)
input double         InpMinAtrSpreadRatio    = 2.5;       // [InpMinAtrSpreadRatio] Ratio Min ATR / Spread (0.0 = Désactivé)

input group "=== 3. ARMEE ET ADAPTATION DU STOP LOSS (SL/TP) ==="
input double         InpSlAtrMultiplier      = 1.2;        // [InpSlAtrMultiplier] Coefficient SL ATR Initial (Ex: 1.30)
input bool           InpEnableDynamicIqmSl   = true; // [InpEnableDynamicIqmSl] Adaptation SL selon IQM
input double         InpMinSlPoints          = 40;            // [InpMinSlPoints] Borne Minimum du Stop Loss (points)
input double         InpMaxSlPoints          = 250;            // [InpMaxSlPoints] Borne Maximum Cap du Stop Loss (points)
input double         InpTp1AtrMultiplier     = 2.15;        // [InpTp1AtrMultiplier] Multiplicateur TP1 (ATR)

input group "=== 4. GESTION DYNAMIQUE DE POSITION ==="
input bool           InpEnablePartialClose   = true;       // [InpEnablePartialClose] Clôture Partielle à TP1
input double         InpPartialClosePercent  = 75;       // [InpPartialClosePercent] % à clôturer à TP1
input bool           InpEnableBreakEven      = true;       // [InpEnableBreakEven] Passage au Break Even
input double         InpBreakEvenAtrTrigger  = 0.7;       // [InpBreakEvenAtrTrigger] Déclencheur BE (Multiplicateur ATR)
input double         InpBreakEvenLockPoints  = 30;        // [InpBreakEvenLockPoints] Points de profit garantis au BE
input bool           InpEnableTrailingStop   = true;       // [InpEnableTrailingStop] Trailing Stop ATR
input double         InpTrailingStartAtr     = 1.1;       // [InpTrailingStartAtr] Trailing Start (ATR)
input double         InpTrailingStepAtr      = 0.3;        // [InpTrailingStepAtr] Trailing Step (ATR)

input group "=== 5. INDICATEURS ET POIDS STRATÉGIQUES ==="
input int            InpAtrPeriod            = 14;          // [InpAtrPeriod] Période ATR
input double         InpMinAtrPoints         = 5;       // [InpMinAtrPoints] Volatilité Minimum (Points)
input int            InpEmaFastPeriod        = 9;          // [InpEmaFastPeriod] Période EMA Rapide
input int            InpEmaSlowPeriod        = 21;          // [InpEmaSlowPeriod] Période EMA Lente
input int            InpRsiPeriod            = 14;          // [InpRsiPeriod] Période RSI
input double         InpRsiBuyThreshold      = 50;    // [InpRsiBuyThreshold] Seuil RSI Achat
input double         InpRsiSellThreshold     = 50;   // [InpRsiSellThreshold] Seuil RSI Vente

input group "=== FILTRE ADX (FORCE DE TENDANCE) ==="
input bool           InpEnableAdxFilter      = true;        // [InpEnableAdxFilter] Activer le filtre ADX
input int            InpAdxPeriod            = 14;          // [InpAdxPeriod] Période de l'ADX
input double         InpAdxThreshold         = 22;          // [InpAdxThreshold] Seuil minimum de l'ADX (ex: 22)

input group "=== 6. LIMITES D'EXPOSITION JOURNALIÈRE ==="
input bool           InpEnableDailyLimits    = true;       // [InpEnableDailyLimits] Activer les Limites Journalières
input double         InpMaxDailyLossAmount   = 150;       // [InpMaxDailyLossAmount] Perte Max Journalière ($)
input double         InpMaxDailyProfitAmount = 400;     // [InpMaxDailyProfitAmount] Objectif Profit Journalier ($)
input int            InpMaxDailyTrades       = 20;          // [InpMaxDailyTrades] Nombre Max de Trades / Jour
input int            InpPauseAfterLosses     = 3; // [InpPauseAfterLosses] Nb Pertes avant Pause
input int            InpPauseDurationMin     = 30;    // [InpPauseDurationMin] Durée de la Pause (Min)

input group "=== 7. FILTRES HORAIRES ET SESSIONS ==="
input bool           InpEnableSessionFilter  = false;     // [InpEnableSessionFilter] Activer les Filtres de Session
input string         InpLondonStart          = "08:00";       // [InpLondonStart] Début Session Londres
input string         InpLondonEnd            = "17:30";         // [InpLondonEnd] Fin Session Londres
input string         InpNyStart              = "14:30";           // [InpNyStart] Début Session NY
input string         InpNyEnd                = "21:00";             // [InpNyEnd] Fin Session NY
input bool           InpFilterAsianSession   = true;      // [InpFilterAsianSession] Interdire Session Asiatique

input group "=== 8. STATISTICAL EDGE ==="
input bool           InpEnableStatisticalEdge = true;     // [InpEnableStatisticalEdge] Utiliser Stat Edge
input double         InpStatEdgeMinWinRate    = 55.0;     // [InpStatEdgeMinWinRate] Edge Minimum (%)
input int            InpStatEdgeLookback      = 10000;    // [InpStatEdgeLookback] Bougies à analyser

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

   bool     m_enableAdxFilter;
   int      m_adxPeriod;
   double   m_adxThreshold;

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
   
   bool     m_enableStatisticalEdge;
   double   m_statEdgeMinWinRate;
   int      m_statEdgeLookback;

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

      m_enableAdxFilter      = InpEnableAdxFilter;
      m_adxPeriod            = MathMax(1, InpAdxPeriod);
      m_adxThreshold         = MathMax(0.0, InpAdxThreshold);

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
      
      m_enableStatisticalEdge = InpEnableStatisticalEdge;
      m_statEdgeMinWinRate   = InpStatEdgeMinWinRate;
      m_statEdgeLookback     = MathMax(100, InpStatEdgeLookback);

      return true;
   }
};

#endif
