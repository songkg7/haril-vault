---
title: 2026-02-27 Quant Backtest Improvement Experiment Matrix
date: 2026-02-27T12:35:42+09:00
aliases:
tags:
  - quant
  - report
  - ai-generated
description:
updated: 2026-02-27T20:46
---
# Quant Improvement Experiment Matrix (v1)

- Date: 2026-02-27 (KST)
- Base profile: `ConsensusFast` (MACrossoverFast + RSIFast + MACDFast)
- Base result reference:
  - Win rate: 50.19%
  - PF: 0.864
  - Total return: -20.52%
  - Trades: 12,055
- Goal: **PF > 1.05**, **Sharpe > 0.2**, **MDD < 18%**, while keeping sufficient trade count

## 1) Experiment Axes

### A. Signal Quality
- `min_confidence`: 0.45 (base) / 0.50 / 0.55 / 0.60
- Consensus rule:
  - A1: any weighted majority (base)
  - A2: strict 2-of-3 agreement
  - A3: 2-of-3 + RSI or Bollinger confirmation

### B. Frequency Control
- Cooldown bars after exit: 0 (base) / 2 / 4 / 8
- Per-symbol max trades per day: unlimited (base) / 8 / 5 / 3
- Session filter: full session (base) / avoid first 30m / avoid last 30m

### C. Cost-aware Guard
- Expected edge threshold (bps): 0 (base) / 3 / 5 / 8
- Spread/volatility gate: off (base) / on (skip high-spread windows)

### D. Risk/Execution
- Position sizing multiplier: 1.0 (base) / 0.75 / 0.5
- Stop-loss profile: current / tighter / ATR-scaled
- Take-profit profile: none(base) / partial TP 1R / trailing TP

## 2) Prioritized Test Batches

## Batch-1 (Low effort, high impact)
1. `min_confidence=0.55`
2. Cooldown=4 bars
3. Max trades/day/symbol=5
4. Expected edge threshold=5 bps

## Batch-2 (Quality-first)
1. strict 2-of-3 agreement
2. avoid first 30m + last 30m
3. spread/volatility gate ON

## Batch-3 (Risk smoothing)
1. size multiplier=0.75
2. ATR-scaled stop
3. optional trailing TP

## 3) Concrete Matrix (Run Plan)

| Run ID | Confidence | Consensus Rule | Cooldown | Max Trades/Day | Session Filter | Edge Gate | Size Mult | Notes |
|---|---:|---|---:|---:|---|---:|---:|---|
| R0 | 0.45 | Base | 0 | ∞ | Full | 0 bps | 1.0 | Baseline (existing) |
| R1 | 0.55 | Base | 4 | 5 | Full | 5 bps | 1.0 | First recommended |
| R2 | 0.55 | 2-of-3 | 4 | 5 | Full | 5 bps | 1.0 | Noise reduction |
| R3 | 0.55 | 2-of-3 | 4 | 5 | Mid-session only | 5 bps | 1.0 | Open/close churn cut |
| R4 | 0.60 | 2-of-3 | 8 | 3 | Mid-session only | 8 bps | 0.75 | Conservative profile |
| R5 | 0.50 | 2-of-3 + confirm | 4 | 5 | Full | 5 bps | 1.0 | Balanced alt |

## 4) Acceptance Rules

Promote candidate only if all are satisfied vs baseline:
1. PF improves to `>= 1.05`
2. Sharpe improves by `>= +0.20`
3. Max drawdown not worse than baseline (or improved)
4. Trade count not collapsing below usable threshold (e.g. > 1,000/year)

## 5) Reporting Template (per run)

- Config diff from baseline
- Metrics: return / MDD / win rate / PF / Sharpe / trades
- Cost sensitivity note (commission/slippage stress: +50%)
- Failure mode note (where performance deteriorated)
- Decision: promote / hold / reject

## 6) Immediate Next Action

Start with **R1 → R2 → R3**.  
If PF still <1, jump to **R4** (more conservative) before trying new strategy mix.
