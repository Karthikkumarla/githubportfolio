# Sales Performance Dashboard

*SQL + Power BI + Excel*

## Business Problem
Sales leadership relied on fragmented spreadsheets that made it difficult
to monitor revenue trends, win rates, and regional performance in a
timely, consistent way.

## Business Impact
Improved sales visibility and enabled data-driven target tracking across
all regions in real time.

## Dashboard Preview
![Sales Performance Dashboard](https://karthikkumardataanalystportfolio-craft-521.lovable.app/assets/gallery-sales-Wol3ggFW.jpg)

## Tech Stack
SQL, Power BI, Excel

## What's Inside
- `SalesPerformance.sql` — consolidated sales fact view, monthly revenue
  trend by region, sales-rep win-rate leaderboard, and a target-vs-actual
  query joined against an Excel-maintained targets table.

## How It Works
1. `vw_Sales_Performance` view standardizes opportunity-level data and
   flags won/closed deals.
2. Monthly revenue trend query feeds the main Power BI trend chart,
   broken down by region.
3. Win-rate query powers a sales-rep leaderboard with drill-through by
   region.
4. Target-vs-actual query blends SQL revenue data with an Excel-based
   targets table maintained by the sales ops team, giving a live
   percent-of-target view without re-keying targets into the database.
