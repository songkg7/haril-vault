# RSIBollingerHybrid vs Baselines (15Min, Nasdaq30)

- Date: 2026-02-27 (KST)
- Universe: Nasdaq 30
- Period: 2025-02-27 ~ 2026-02-26
- Timeframe: 15Min
- Costs: commission 1bps, slippage 2bps
- Initial Cash: $100,000

## Summary Table

| Strategy | Win Rate | Trades | Profit Factor | Total Return | Max DD | CAGR | Sharpe |
|---|---:|---:|---:|---:|---:|---:|---:|
| RSIBollingerHybrid | 59.76% | 1,804 | 1.249 | **+18.00%** | 15.94% | **+18.07%** | **0.150** |
| RSI | 64.11% | 1,513 | 1.274 | +16.46% | 14.96% | +16.52% | 0.126 |
| BollingerBands | 61.60% | 2,828 | 1.152 | +12.53% | 15.64% | +12.58% | 0.110 |
| ConsensusFast | 50.19% | 12,055 | 0.864 | -20.52% | 22.57% | -20.58% | -0.196 |

## Latest Run IDs
- RSIBollingerHybrid: `80f44ae825ea4108ba4004c902840ffc`
- RSI: `f78b349f07894d79b56a6fabc8f7f99f`
- BollingerBands: `f432e84f2af64e50a6ed5dde059bd923`
- ConsensusFast: `95f128c480ed4683a4117aa54c35ea49`

## Key Findings
1. **Hybrid delivers best return/CAGR/Sharpe** among compared strategies in this setup.
2. RSI alone has higher win rate, but hybrid shows better reward profile (higher total return with still-solid PF).
3. ConsensusFast remains overtrading-heavy and negative expectancy under transaction costs.

## Practical Read
- If goal is pure hit-rate, RSI wins.
- If goal is risk-adjusted return and deployability, **RSIBollingerHybrid is the strongest candidate** from this batch.

## Next Experiments (recommended)
1. Hybrid threshold tuning: RSI 35/65 vs 30/70
2. Cooldown: 2/4/8 bars
3. Edge gate: 3/5/8 bps
4. Session filter: exclude first/last 30 minutes
5. Cost stress test: commission/slippage +50%
