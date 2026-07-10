# Claims Analytics Dashboard

*SQL + Power BI + DAX*

## Business Problem
Leadership lacked real-time visibility into claims processing productivity,
SLA adherence, and quality metrics, resulting in delayed operational
decisions and reactive management.

## Business Impact
Reduced report turnaround from days to minutes and improved SLA compliance
visibility by 40%.

## Dashboard Preview
![Claims Analytics Dashboard](https://karthikkumardataanalystportfolio-craft-521.lovable.app/assets/gallery-claims-B04UsJfW.jpg)

## Tech Stack
SQL, Power BI, DAX

## What's Inside
- `ClaimsAnalytics.sql` — base extraction view, daily aggregation query for
  the trend chart, and an agent-level leaderboard query used for
  drill-through.
- `ClaimsAnalytics_DAX.txt` — DAX measures for turnaround time, SLA
  compliance %, quality score %, period-over-period change, and an
  On-Target/At-Risk/Breach status flag used for conditional formatting.

## How It Works
1. `vw_Claims_Productivity` view standardizes raw claims data and flags
   whether each claim met its SLA target.
2. Daily and agent-level aggregation queries feed the Power BI model.
3. DAX measures calculate SLA compliance, quality score, and trend deltas,
   used across KPI cards, trend charts, and a leaderboard drill-through page.
