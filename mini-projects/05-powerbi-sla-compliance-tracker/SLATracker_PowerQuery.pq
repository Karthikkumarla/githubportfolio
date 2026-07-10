// ============================================================================
// Power Query (M) — Self-Refreshing SLA Compliance Tracker
// Author: Karthik Kumar L A
//
// Purpose:
//   Feeds a Power BI SLA/productivity dashboard with an auto-refreshing data
//   model built on top of the KPI_Daily_Snapshot SQL table (see project 04),
//   with team and time-period columns ready for drill-through.
// ============================================================================

let
    Source = Sql.Database("YourSqlServer", "OperationsDB"),
    KPI_Table = Source{[Schema="dbo", Item="KPI_Daily_Snapshot"]}[Data],

    // Keep only the trailing 90 days to control model size
    FilteredDates = Table.SelectRows(
        KPI_Table,
        each [SnapshotDate] >= Date.AddDays(DateTime.Date(DateTime.LocalNow()), -90)
    ),

    // Add calendar attributes used for drill-through and slicers
    AddYear = Table.AddColumn(FilteredDates, "Year", each Date.Year([SnapshotDate]), Int64.Type),
    AddMonth = Table.AddColumn(AddYear, "Month", each Date.Month([SnapshotDate]), Int64.Type),
    AddMonthName = Table.AddColumn(AddMonth, "MonthName", each Date.ToText([SnapshotDate], "MMMM"), type text),
    AddWeekNum = Table.AddColumn(AddMonthName, "WeekOfYear", each Date.WeekOfYear([SnapshotDate]), Int64.Type),

    // Flag SLA breaches for conditional formatting in the report
    AddSLAFlag = Table.AddColumn(
        AddWeekNum,
        "SLA_Status",
        each if [SLA_CompliancePct] >= 95 then "On Target"
             else if [SLA_CompliancePct] >= 85 then "At Risk"
             else "Breach",
        type text
    ),

    Reordered = Table.ReorderColumns(
        AddSLAFlag,
        {"SnapshotDate", "Year", "Month", "MonthName", "WeekOfYear", "Department",
         "TotalTransactions", "AvgHandlingTimeMins", "SLA_CompliancePct",
         "SLA_Status", "QualityScorePct"}
    )
in
    Reordered
