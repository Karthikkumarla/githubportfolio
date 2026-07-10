/* ============================================================================
   Claims Analytics Dashboard — SQL Data Layer
   Author: Karthik Kumar L A
   Stack: SQL Server + Power BI + DAX

   Purpose:
     Gives leadership real-time visibility into claims processing
     productivity, SLA adherence, and quality metrics.
   ========================================================================= */

-- ----------------------------------------------------------------------------
-- STEP 1: Base extraction view — feeds the Power BI data model
-- ----------------------------------------------------------------------------
CREATE OR ALTER VIEW dbo.vw_Claims_Productivity AS
SELECT
    c.ClaimID,
    c.Department,
    c.AssignedAgent,
    c.ClaimReceivedDate,
    c.ClaimClosedDate,
    DATEDIFF(HOUR, c.ClaimReceivedDate, c.ClaimClosedDate)      AS TurnaroundHours,
    c.SLA_TargetHours,
    CASE WHEN DATEDIFF(HOUR, c.ClaimReceivedDate, c.ClaimClosedDate) <= c.SLA_TargetHours
         THEN 1 ELSE 0 END                                      AS MetSLA,
    c.QualityCheckResult,
    c.ClaimAmount,
    c.ClaimStatus
FROM dbo.Claims c
WHERE c.ClaimStatus IN ('Closed', 'In Progress');

-- ----------------------------------------------------------------------------
-- STEP 2: Daily aggregation used for the trend chart / KPI cards
-- ----------------------------------------------------------------------------
SELECT
    CAST(ClaimClosedDate AS DATE)                                AS ClosedDate,
    Department,
    COUNT(*)                                                      AS ClaimsClosed,
    AVG(CAST(TurnaroundHours AS DECIMAL(10,2)))                   AS AvgTurnaroundHours,
    100.0 * SUM(MetSLA) / NULLIF(COUNT(*), 0)                     AS SLA_CompliancePct,
    100.0 * SUM(CASE WHEN QualityCheckResult = 'Pass' THEN 1 ELSE 0 END)
          / NULLIF(COUNT(*), 0)                                  AS QualityScorePct
FROM dbo.vw_Claims_Productivity
WHERE ClaimStatus = 'Closed'
GROUP BY CAST(ClaimClosedDate AS DATE), Department
ORDER BY ClosedDate DESC;

-- ----------------------------------------------------------------------------
-- STEP 3: Agent-level leaderboard (drill-through target in Power BI)
-- ----------------------------------------------------------------------------
SELECT
    AssignedAgent,
    Department,
    COUNT(*)                                                      AS ClaimsHandled,
    AVG(CAST(TurnaroundHours AS DECIMAL(10,2)))                   AS AvgTurnaroundHours,
    100.0 * SUM(MetSLA) / NULLIF(COUNT(*), 0)                     AS SLA_CompliancePct
FROM dbo.vw_Claims_Productivity
GROUP BY AssignedAgent, Department
ORDER BY SLA_CompliancePct DESC;
