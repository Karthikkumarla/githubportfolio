# Power BI + Power Query: Self-Refreshing SLA Compliance Tracker

## Overview
A Power BI dashboard connected to a Power Query-driven data model that
auto-refreshes SLA and productivity metrics from the `KPI_Daily_Snapshot`
table (see the SQL mini-project), with drill-through views by team and
time period.

## Business Impact
Gave operations leadership a live, breach-flagged view of SLA performance
by team instead of a static end-of-week report — breaches are visible
the same day they occur instead of during the next reporting cycle.

## Tech Stack
- Power BI Desktop
- Power Query (M language)
- DAX measures for RAG (Red/Amber/Green) status
- SQL Server data source (`KPI_Daily_Snapshot`)

## How It Works
1. Connects to the `KPI_Daily_Snapshot` SQL table.
2. Filters to a rolling 90-day window to keep the model lightweight.
3. Adds calendar attributes (Year, Month, Week) for slicers/drill-through.
4. Classifies each row into `On Target` / `At Risk` / `Breach` based on
   SLA compliance thresholds, used for conditional formatting on report
   visuals.
5. Report page includes: SLA trend line by department, current-period
   scorecards, and a drill-through page filtered to a single team.

## Setup
1. In Power BI Desktop: **Get Data → Blank Query → Advanced Editor**.
2. Paste `SLATracker_PowerQuery.pq`, update the server/database name.
3. Build visuals off the resulting table; use `SLA_Status` for
   conditional formatting rules (Green/Amber/Red).

## Files
- `SLATracker_PowerQuery.pq` — Power Query M script for the data model
