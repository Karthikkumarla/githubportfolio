# VBA Macro: Automated Variance & Exception Flagging Tool

## Overview
Macro-driven tool that compares current vs. prior period data by key,
auto-highlights variances beyond a configurable threshold, and generates
a color-coded exception summary sheet for stakeholder review.

## Business Impact
Sped up reconciliation cycles by automatically surfacing only the line
items that moved beyond a defined threshold, instead of requiring a
manual line-by-line comparison of two periods.

## Tech Stack
- Excel VBA (Macros)
- Scripting.Dictionary for O(1) key lookups
- Conditional formatting via VBA (color-coded increase/decrease/new item)

## How It Works
1. Reads `CurrentPeriod` and `PriorPeriod` sheets (each: Key, Value columns).
2. Builds a dictionary lookup of prior-period values.
3. For each current-period row, calculates % variance vs. prior period.
4. Flags any row exceeding the threshold (default 10%, configurable via
   `VARIANCE_THRESHOLD_PCT`) into an `Exceptions` sheet, color-coded:
   - Green = increase beyond threshold
   - Red = decrease beyond threshold
   - Yellow = new item not present in prior period
5. Reports total exceptions flagged on completion.

## Setup
1. Import `VarianceExceptionFlagging.bas` into the VBA editor.
2. Create/populate `CurrentPeriod` and `PriorPeriod` sheets.
3. Run `RunVarianceCheck()`.

## Files
- `VarianceExceptionFlagging.bas` — VBA module source code
