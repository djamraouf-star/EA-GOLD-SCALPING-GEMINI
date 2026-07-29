//+------------------------------------------------------------------+
//|                                          ADXFilter.mqh           |
//|  Combo A : SuperTrend (tendance) + RSI continuation (momentum)   |
//|            + OBV (volume) + ATR (volatilite / SL-TP dynamique)   |
//|  Scalping XAUUSD en M1                                           |
//+------------------------------------------------------------------+
#property copyright "ScalpOr"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>
CTrade trade;

//---------------------------------------------------------------- Inputs
input group "=== General ==="
input double InpLotSize        = 0.01;
input int    InpMagicNumber    = 20260726;

input group "=== SuperTrend ==="
input int    InpATRPeriodST    = 10;      // Periode ATR utilisee par le SuperTrend
input double InpATRMultST      = 3.0;     // Multiplicateur ATR pour les bandes SuperTrend

input group "=== RSI (continuation) ==="
input int    InpRSIPeriod      = 14;      // RSI utilise en filtre de direction (>50 haussier / <50 baissier)

input group "=== OBV (volume) ==="
input int    InpOBVMAPeriod    = 20;      // Periode de la moyenne mobile appliquee a l'OBV

input group "=== ATR (SL / TP dynamiques) ==="
input int    InpATRPeriodRisk  = 14;      // Periode ATR pour le calcul du SL/TP (peut differer de l'ATR SuperTrend)
input double InpATRMultSL      = 1.5;
input double InpATRMultTP      = 2.0;

input group "=== ADX (filtre de force de tendance) ==="
input int    InpADXPeriod      = 14;
input double InpADXMinLevel    = 22.0;    // Seuil minimum d'ADX pour autoriser une entree (filtre le range)

input group "=== Divers ==="
input int    InpLookback       = 200;     // Nb de bougies utilisees pour recalculer le SuperTrend a chaque nouvelle bougie
input int    InpOBVSlopeBars   = 5;       // Nb de bougies pour juger la pente de l'OBV

//---------------------------------------------------------------- Handles indicateurs
int hATR_ST;     // ATR pour le SuperTrend
int hATR_Risk;   // ATR pour SL/TP
int hRSI;
int hOBV;
int hADX;

datetime lastBarTime = 0;

// --- Compteurs de diagnostic ---
long dbgBarsProcessed = 0;
long dbgSuperTrendUp = 0, dbgSuperTrendDown = 0;
long dbgRsiCrossUp = 0, dbgRsiCrossDown = 0;
long dbgObvRising = 0, dbgObvFalling = 0;
long dbgLongMatch = 0, dbgShortMatch = 0;
long dbgAdxStrong = 0;

//+------------------------------------------------------------------+
int OnInit()
  {
   hATR_ST   = iATR(_Symbol, PERIOD_M1, InpATRPeriodST);
   hATR_Risk = iATR(_Symbol, PERIOD_M1, InpATRPeriodRisk);
   hRSI      = iRSI(_Symbol, PERIOD_M1, InpRSIPeriod, PRICE_CLOSE);
   hOBV      = iOBV(_Symbol, PERIOD_M1, VOLUME_TICK);
   hADX      = iADX(_Symbol, PERIOD_M1, InpADXPeriod);

   if(hATR_ST==INVALID_HANDLE || hATR_Risk==INVALID_HANDLE ||
      hRSI==INVALID_HANDLE || hOBV==INVALID_HANDLE || hADX==INVALID_HANDLE)
     {
      Print("Erreur creation handle indicateur");
      return(INIT_FAILED);
     }

   trade.SetExpertMagicNumber(InpMagicNumber);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   PrintFormat("=== DIAGNOSTIC ScalpOr ComboA ===");
   PrintFormat("Bougies traitees        : %d", dbgBarsProcessed);
   PrintFormat("SuperTrend haussier     : %d  |  baissier : %d", dbgSuperTrendUp, dbgSuperTrendDown);
   PrintFormat("RSI cross up (survente) : %d  |  cross down (surachat) : %d", dbgRsiCrossUp, dbgRsiCrossDown);
   PrintFormat("OBV haussier            : %d  |  baissier : %d", dbgObvRising, dbgObvFalling);
   PrintFormat("ADX >= seuil            : %d", dbgAdxStrong);
   PrintFormat("Conjonction LONG        : %d", dbgLongMatch);
   PrintFormat("Conjonction SHORT       : %d", dbgShortMatch);

   IndicatorRelease(hATR_ST);
   IndicatorRelease(hATR_Risk);
   IndicatorRelease(hRSI);
   IndicatorRelease(hOBV);
   IndicatorRelease(hADX);
  }

//+------------------------------------------------------------------+
//| Recalcule le SuperTrend sur InpLookback bougies et renvoie la     |
//| direction (1 = haussier, -1 = baissier) de la bougie cloturee     |
//| shift=1 (derniere bougie fermee), avec la direction precedente    |
//| en shift=2 passee par reference (pour detecter le retournement)  |
//+------------------------------------------------------------------+
bool GetSuperTrend(int &dirCurrent, int &dirPrevious)
  {
   int n = InpLookback;
   double atr[];
   MqlRates rates[];
   ArraySetAsSeries(atr, true);
   ArraySetAsSeries(rates, true);

   if(CopyBuffer(hATR_ST, 0, 1, n, atr) < n) return(false);
   if(CopyRates(_Symbol, PERIOD_M1, 1, n, rates) < n) return(false);
   // CopyRates avec shift=1 revient en ordre chronologique croissant -> on le remet en "series"
   ArraySetAsSeries(rates, true);

   double finalUpper[], finalLower[];
   int    trend[];
   ArrayResize(finalUpper, n);
   ArrayResize(finalLower, n);
   ArrayResize(trend, n);

   // On parcourt de la plus ancienne (index n-1) vers la plus recente (index 0)
   for(int i = n-1; i >= 0; i--)
     {
      double hl2 = (rates[i].high + rates[i].low) / 2.0;
      double basicUpper = hl2 + InpATRMultST * atr[i];
      double basicLower = hl2 - InpATRMultST * atr[i];

      if(i == n-1)
        {
         finalUpper[i] = basicUpper;
         finalLower[i] = basicLower;
         trend[i] = (rates[i].close >= hl2) ? 1 : -1;
         continue;
        }

      // Bande superieure finale
      if(rates[i+1].close > finalUpper[i+1])
         finalUpper[i] = basicUpper;
      else
         finalUpper[i] = MathMin(basicUpper, finalUpper[i+1]);

      // Bande inferieure finale
      if(rates[i+1].close < finalLower[i+1])
         finalLower[i] = basicLower;
      else
         finalLower[i] = MathMax(basicLower, finalLower[i+1]);

      // Direction
      if(rates[i].close > finalUpper[i+1])
         trend[i] = 1;
      else if(rates[i].close < finalLower[i+1])
         trend[i] = -1;
      else
         trend[i] = trend[i+1];
     }

   dirCurrent  = trend[0];
   dirPrevious = trend[1];
   return(true);
  }

//+------------------------------------------------------------------+
bool IsNewBar()
  {
   datetime t = iTime(_Symbol, PERIOD_M1, 0);
   if(t != lastBarTime)
     {
      lastBarTime = t;
      return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   if(!IsNewBar()) return;

   // --- SuperTrend ---
   int stCurrent, stPrevious;
   if(!GetSuperTrend(stCurrent, stPrevious)) return;
   bool superTrendJustFlippedUp   = (stPrevious == -1 && stCurrent == 1);
   bool superTrendJustFlippedDown = (stPrevious == 1  && stCurrent == -1);

   // --- RSI (continuation : simple filtre de direction >50 / <50) ---
   double rsi[];
   ArraySetAsSeries(rsi, true);
   if(CopyBuffer(hRSI, 0, 1, 1, rsi) < 1) return;
   bool rsiBullish = (rsi[0] > 50.0);
   bool rsiBearish = (rsi[0] < 50.0);

   // --- OBV : pente sur InpOBVSlopeBars bougies (alignee sur la bougie shift1) ---
   double obv[];
   ArraySetAsSeries(obv, true);
   int obvCount = InpOBVSlopeBars + 1;
   if(CopyBuffer(hOBV, 0, 1, obvCount, obv) < obvCount) return;
   bool obvRising  = (obv[0] > obv[obvCount-1]);
   bool obvFalling = (obv[0] < obv[obvCount-1]);

   // --- ADX : filtre de force de tendance (ne trade que si tendance suffisamment marquee) ---
   double adx[];
   ArraySetAsSeries(adx, true);
   if(CopyBuffer(hADX, 0, 1, 1, adx) < 1) return;
   bool adxStrongEnough = (adx[0] >= InpADXMinLevel);

   // --- ATR pour SL / TP ---
   double atrRisk[];
   ArraySetAsSeries(atrRisk, true);
   if(CopyBuffer(hATR_Risk, 0, 1, 1, atrRisk) < 1) return;
   double atrValue = atrRisk[0];

   // --- Compteurs de diagnostic ---
   dbgBarsProcessed++;
   if(stCurrent == 1) dbgSuperTrendUp++; else dbgSuperTrendDown++;
   if(rsiBullish) dbgRsiCrossUp++;
   if(rsiBearish) dbgRsiCrossDown++;
   if(obvRising) dbgObvRising++;
   if(obvFalling) dbgObvFalling++;
   if(adxStrongEnough) dbgAdxStrong++;
   if(stCurrent == 1 && rsiBullish && obvRising && adxStrongEnough) dbgLongMatch++;
   if(stCurrent == -1 && rsiBearish && obvFalling && adxStrongEnough) dbgShortMatch++;

   // --- Gestion des positions ouvertes : sortie anticipee si retournement SuperTrend ---
   ManageOpenPositions(superTrendJustFlippedUp, superTrendJustFlippedDown);

   if(PositionsTotalForSymbolMagic() > 0) return; // une seule position a la fois

   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);

   // --- Signal LONG ---
   if(stCurrent == 1 && rsiBullish && obvRising && adxStrongEnough)
     {
      double sl = NormalizeDouble(ask - InpATRMultSL * atrValue, digits);
      double tp = NormalizeDouble(ask + InpATRMultTP * atrValue, digits);
      trade.Buy(InpLotSize, _Symbol, ask, sl, tp, "ScalpOr ComboA long");
     }

   // --- Signal SHORT ---
   if(stCurrent == -1 && rsiBearish && obvFalling && adxStrongEnough)
     {
      double sl = NormalizeDouble(bid + InpATRMultSL * atrValue, digits);
      double tp = NormalizeDouble(bid - InpATRMultTP * atrValue, digits);
      trade.Sell(InpLotSize, _Symbol, bid, sl, tp, "ScalpOr ComboA short");
     }
  }

//+------------------------------------------------------------------+
int PositionsTotalForSymbolMagic()
  {
   int count = 0;
   for(int i = 0; i < PositionsTotal(); i++)
     {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
        {
         if(PositionGetString(POSITION_SYMBOL) == _Symbol &&
            PositionGetInteger(POSITION_MAGIC) == InpMagicNumber)
            count++;
        }
     }
   return(count);
  }

//+------------------------------------------------------------------+
//| Ferme les positions si le SuperTrend vient de se retourner        |
//| a l'oppose du sens de la position (sortie anticipee)              |
//+------------------------------------------------------------------+
void ManageOpenPositions(bool flippedUp, bool flippedDown)
  {
   for(int i = PositionsTotal()-1; i >= 0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagicNumber) continue;

      long type = PositionGetInteger(POSITION_TYPE);
      if(type == POSITION_TYPE_BUY && flippedDown)
         trade.PositionClose(ticket);
      else if(type == POSITION_TYPE_SELL && flippedUp)
         trade.PositionClose(ticket);
     }
  }
//+------------------------------------------------------------------+