/* ============================================================================
   SQL: Automated Daily KPI Snapshot Job
   Author: Karthik Kumar L A

   Purpose:
     Extracts daily KPI metrics from operational tables, stores historical
     snapshots in a dedicated table, and feeds a Power BI dashboard directly
     off that table — removing the need for a manual daily data pull.

   Compatible with: SQL Server / Oracle (minor syntax notes inline)
   ========================================================================= */

-- ----------------------------------------------------------------------------
-- STEP 1: Snapshot table (create once)
-- ----------------------------------------------------------------------------
CREATE TABLE dbo.KPI_Daily_Snapshot (
    SnapshotDate        DATE            NOT NULL,
    Department          VARCHAR(100)    NOT NULL,
    TotalTransactions   INT             NOT NULL,
    AvgHandlingTimeMins DECIMAL(10,2)   NULL,
    SLA_CompliancePct   DECIMAL(5,2)    NULL,
    QualityScorePct     DECIMAL(5,2)    NULL,
    CreatedAt           DATETIME        DEFAULT GETDATE(),
    CONSTRAINT PK_KPI_Daily_Snapshot PRIMARY KEY (SnapshotDate, Department)
);

-- ----------------------------------------------------------------------------
-- STEP 2: Stored procedure — run daily via SQL Agent job / scheduled task
-- ----------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE dbo.usp_Load_KPI_Daily_Snapshot
    @SnapshotDate DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @SnapshotDate IS NULL
        SET @SnapshotDate = CAST(GETDATE() - 1 AS DATE);  -- default: yesterday

    -- Avoid duplicate snapshot for the same date
    DELETE FROM dbo.KPI_Daily_Snapshot WHERE SnapshotDate = @SnapshotDate;

    INSERT INTO dbo.KPI_Daily_Snapshot
        (SnapshotDate, Department, TotalTransactions, AvgHandlingTimeMins,
         SLA_CompliancePct, QualityScorePct)
    SELECT
        @SnapshotDate                                          AS SnapshotDate,
        t.Department,
        COUNT(*)                                                AS TotalTransactions,
        AVG(CAST(t.HandlingTimeMins AS DECIMAL(10,2)))          AS AvgHandlingTimeMins,
        100.0 * SUM(CASE WHEN t.MetSLA = 1 THEN 1 ELSE 0 END)
              / NULLIF(COUNT(*), 0)                             AS SLA_CompliancePct,
        100.0 * SUM(CASE WHEN t.QualityFlag = 'Pass' THEN 1 ELSE 0 END)
              / NULLIF(COUNT(*), 0)                             AS QualityScorePct
    FROM dbo.Transactions t
    WHERE CAST(t.TransactionDateTime AS DATE) = @SnapshotDate
    GROUP BY t.Department;

    PRINT 'KPI snapshot loaded for ' + CONVERT(VARCHAR(10), @SnapshotDate, 120);
END;
GO

-- ----------------------------------------------------------------------------
-- STEP 3: Trend query used directly by the Power BI dashboard
-- ----------------------------------------------------------------------------
SELECT
    SnapshotDate,
    Department,
    TotalTransactions,
    AvgHandlingTimeMins,
    SLA_CompliancePct,
    QualityScorePct,
    LAG(SLA_CompliancePct) OVER (PARTITION BY Department ORDER BY SnapshotDate)
        AS Prior_SLA_CompliancePct
FROM dbo.KPI_Daily_Snapshot
WHERE SnapshotDate >= DATEADD(DAY, -30, CAST(GETDATE() AS DATE))
ORDER BY Department, SnapshotDate;

-- ----------------------------------------------------------------------------
-- STEP 4 (scheduling): SQL Server Agent job — daily at 06:00
--   EXEC dbo.usp_Load_KPI_Daily_Snapshot;
-- For Oracle: wrap the procedure logic in PL/SQL and schedule via DBMS_SCHEDULER.
-- ----------------------------------------------------------------------------
