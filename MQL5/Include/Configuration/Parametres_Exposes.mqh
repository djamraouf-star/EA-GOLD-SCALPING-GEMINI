//+------------------------------------------------------------------+
//|                                           Parametres_Exposes.mqh |
//+------------------------------------------------------------------+
#property copyright "Artisan Scalper"

// Inputs MQL5 (Approche Boîte Noire)
input string   InpCalibrationFile   = "calibration_v1.csv"; // Fichier de Calibration (Cave)
input double   InpMaxRiskPerTrade   = 1.0;                  // Risque Max par Trade (%)
input int      InpMaxSpreadPoints   = 15;                   // Spread Maximum (Points)
input ulong    InpMagicNumber       = 777777;               // Numéro Magique
