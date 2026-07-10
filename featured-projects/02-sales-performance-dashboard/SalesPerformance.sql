/* ============================================================================
   Sales Performance Dashboard — SQL Data Layer
   Author: Karthik Kumar L A
   Stack: SQL + Power BI + Excel

   Purpose:
     Gives sales leadership a unified, real-time view of revenue trends,
     win rates, and regional performance instead of fragmented spreadsheets.
   ========================================================================= */

-- ----------------------------------------------------------------------------
-- STEP 1: Consolidated sales fact view
-- ----------------------------------------------------------------------------
CREATE OR ALTER VIEW dbo.vw_Sales_Performance AS
SELECT
    s.OpportunityID,
    s.Region,
    s.SalesRep,
    s.ProductLine,
    s.OpportunityStage,
    s.DealAmount,
    s.CreatedDate,
    s.CloseDate,
    CASE WHEN s.OpportunityStage = 'Closed Won' THEN 1 ELSE 0 END AS IsWon,
    CASE WHEN s.OpportunityStage IN ('Closed Won', 'Closed Lost') THEN 1 ELSE 0 END AS IsClosed
FROM dbo.SalesOpportunities s;

-- ----------------------------------------------------------------------------
-- STEP 2: Monthly revenue trend by region (feeds the main trend chart)
-- ----------------------------------------------------------------------------
SELECT
    Region,
    DATEFROMPARTS(YEAR(CloseDate), MONTH(CloseDate), 1)   AS RevenueMonth,
    SUM(CASE WHEN IsWon = 1 THEN DealAmount ELSE 0 END)   AS RevenueClosed,
    COUNT(CASE WHEN IsWon = 1 THEN 1 END)                 AS DealsWon
FROM dbo.vw_Sales_Performance
WHERE IsClosed = 1
GROUP BY Region, DATEFROMPARTS(YEAR(CloseDate), MONTH(CloseDate), 1)
ORDER BY RevenueMonth, Region;

-- ----------------------------------------------------------------------------
-- STEP 3: Win rate by sales rep (leaderboard / drill-through)
-- ----------------------------------------------------------------------------
SELECT
    SalesRep,
    Region,
    COUNT(*)                                                AS TotalOpportunities,
    SUM(IsClosed)                                            AS ClosedOpportunities,
    SUM(IsWon)                                               AS WonOpportunities,
    100.0 * SUM(IsWon) / NULLIF(SUM(IsClosed), 0)            AS WinRatePct,
    SUM(CASE WHEN IsWon = 1 THEN DealAmount ELSE 0 END)      AS TotalRevenue
FROM dbo.vw_Sales_Performance
GROUP BY SalesRep, Region
ORDER BY TotalRevenue DESC;

-- ----------------------------------------------------------------------------
-- STEP 4: Target vs. actual — used against an Excel-maintained targets table
-- ----------------------------------------------------------------------------
SELECT
    a.Region,
    a.RevenueMonth,
    a.RevenueClosed,
    t.TargetRevenue,
    100.0 * a.RevenueClosed / NULLIF(t.TargetRevenue, 0)     AS PctOfTarget
FROM (
    SELECT Region, DATEFROMPARTS(YEAR(CloseDate), MONTH(CloseDate), 1) AS RevenueMonth,
           SUM(CASE WHEN IsWon = 1 THEN DealAmount ELSE 0 END) AS RevenueClosed
    FROM dbo.vw_Sales_Performance
    WHERE IsClosed = 1
    GROUP BY Region, DATEFROMPARTS(YEAR(CloseDate), MONTH(CloseDate), 1)
) a
LEFT JOIN dbo.SalesTargets t
    ON a.Region = t.Region AND a.RevenueMonth = t.TargetMonth
ORDER BY a.RevenueMonth, a.Region;
