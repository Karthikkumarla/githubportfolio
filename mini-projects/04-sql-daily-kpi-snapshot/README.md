# SQL: Automated Daily KPI Snapshot Job

## Overview
A scheduled SQL stored procedure that extracts daily KPI metrics
(transaction volume, handling time, SLA compliance, quality score) from
operational tables, stores historical snapshots, and feeds a Power BI
dashboard directly — removing manual daily data pulls.

## Business Impact
Eliminated a manual daily export-and-refresh routine by giving the
dashboard a self-maintaining historical KPI table, enabling trend
analysis (e.g., day-over-day SLA movement) that a manual pull couldn't
support.

## Tech Stack
- SQL Server / Oracle SQL
- Stored Procedures
- Window functions (`LAG`) for trend comparisons
- SQL Agent / DBMS_SCHEDULER for automation

## How It Works
1. `KPI_Daily_Snapshot` table stores one row per department per day.
2. `usp_Load_KPI_Daily_Snapshot` stored procedure aggregates the prior
   day's transactions into KPI metrics and inserts/refreshes that day's
   snapshot (idempotent — safe to re-run for the same date).
3. A trend query (Step 3) exposes the last 30 days with a `LAG()`-based
   prior-day comparison column, used directly as the Power BI data source.
4. The procedure is scheduled to run daily via SQL Server Agent (or
   `DBMS_SCHEDULER` in Oracle).

## Setup
1. Run the `CREATE TABLE` statement once to create the snapshot table.
2. Deploy the stored procedure.
3. Schedule `EXEC dbo.usp_Load_KPI_Daily_Snapshot;` to run daily.
4. Point Power BI at the trend query (Step 3) or directly at
   `KPI_Daily_Snapshot`.

## Files
- `DailyKPISnapshot.sql` — table definition, stored procedure, and trend query
