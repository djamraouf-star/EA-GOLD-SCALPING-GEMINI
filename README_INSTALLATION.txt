====================================================================
GOLD SCALPER EA V1.0 - MetaTrader 5 (XAUUSD M1)
ARCHITECTURE MODULAIRE POO & MACHINE À ÉTATS (FSM)
====================================================================

INSTRUCTIONS D'INSTALLATION DANS METATRADER 5 :

1. Ouvrez MetaTrader 5.
2. Allez dans le menu "Fichier" -> "Ouvrir le dossier des données" (Open Data Folder).
3. Naviguez vers le dossier : MQL5\Experts\
4. Copiez le dossier complet "GoldScalperEA" de cette archive dans MQL5\Experts\ :
   
   Structure copiée dans MQL5\Experts\GoldScalperEA\ :
   ├── GoldScalperEA.mq5
   └── Include\
       ├── Config\
       │      Parameters.mqh
       ├── Core\
       │      Engine.mqh
       │      Context.mqh
       ├── Market\
       │      MarketFilter.mqh
       │      DynamicScore.mqh
       │      FixedScore.mqh
       ├── Indicators\
       │      ATR.mqh
       │      EMA.mqh
       │      RSI.mqh
       ├── Signals\
       │      SignalManager.mqh
       │      BuySignal.mqh
       │      SellSignal.mqh
       ├── Risk\
       │      RiskManager.mqh
       │      StopLoss.mqh
       │      TakeProfit.mqh
       │      BreakEven.mqh
       │      TrailingStop.mqh
       ├── Trade\
       │      OrderManager.mqh
       │      PositionManager.mqh
       ├── Statistics\
       │      DailyManager.mqh
       │      Logger.mqh
       │      Performance.mqh
       └── Utils\
              TimeUtils.mqh
              PriceUtils.mqh
              MathUtils.mqh

5. Dans MetaTrader 5, ouvrez MetaEditor (touche F4).
6. Dans le navigateur de gauche, ouvrez Experts -> GoldScalperEA -> double-cliquez sur "GoldScalperEA.mq5".
7. Cliquez sur le bouton "Compiler" (F7) en haut.
8. Vérifiez dans le journal qu'il y a "0 errors, 0 warnings".
9. Retournez sur MT5, glissez-déposez l'EA sur un graphique XAUUSD M1.
10. Activez le bouton "Algo Trading" dans la barre d'outils MT5.
