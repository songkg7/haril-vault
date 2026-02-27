---
updated: 2026-02-27T20:46
title: 2026-02-27 Quant Backtest Strategy Decomposition
date: 2026-02-27T12:33:31+09:00
aliases:
tags:
  - quant
description:
---
# Deep Research Report — Quant Backtest Strategy Decomposition (Updated)

- Updated: 2026-02-27 13:07 KST
- Universe: Nasdaq 30 basket
- Period: 2025-02-27 ~ 2026-02-26 (1Y)
- Timeframe: 15Min
- Initial cash: $100,000
- Costs: commission 1 bps, slippage 2 bps
- Objective: 전략별 승률/기대값 분해 + 현재 실매매 유사 프로필(ConsensusFast) 타당성 확인

## Result Snapshot (latest rerun)

| Strategy       | Win Rate | Trades | Profit Factor | Total Return | Max DD |    CAGR | Sharpe |
| -------------- | -------: | -----: | ------------: | -----------: | -----: | ------: | -----: |
| MACrossover    |   29.17% |  7,783 |         1.006 |       +1.79% | 11.44% |  +1.80% | +0.025 |
| MACD           |   34.49% | 13,892 |         0.910 |      -16.10% | 21.23% | -16.15% | -0.137 |
| RSI            |   64.11% |  1,513 |         1.274 |      +16.46% | 14.96% | +16.52% | +0.126 |
| BollingerBands |   61.60% |  2,828 |         1.152 |      +12.53% | 15.64% | +12.58% | +0.110 |
| ConsensusFast  |   50.19% | 12,055 |         0.864 |      -20.52% | 22.57% | -20.58% | -0.196 |

## Win-rate Ranking (worst → best)
1. MACrossover (29.17%)
2. MACD (34.49%)
3. ConsensusFast (50.19%)
4. BollingerBands (61.60%)
5. RSI (64.11%)

## Interpretation
- **승률이 가장 약한 축:** MACrossover, MACD
- **실매매 유사 프로필(ConsensusFast):** 승률 50%대지만 PF<1 + 비용 누적로 기대값 음수
- **상대 강점:** RSI, BollingerBands는 승률/PF/수익률이 동시 양호

## Reproducibility (latest run_id)
- MACrossover: `958b2debfb294fe1b7abd11743c4e173`
- MACD: `1332296e6d81458991877b34f971aa2b`
- RSI: `3cac33a85e764837aa060f751a6a08b1`
- BollingerBands: `fb2abae875a54ea4a198e002e99b3006`
- ConsensusFast: `0ecaccfe8fe741dd95e0d04f0ad75afe`

## Bottom Line
현재 조건(나스닥30, 15분봉, 비용반영)에서는 **MACrossover/MACD 승률이 가장 취약**하고,
**ConsensusFast는 승률 대비 손익비가 약해 음수 기대값**을 보인다. 운영 전 파라미터/필터/빈도 제어가 필수다.
