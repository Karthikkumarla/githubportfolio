// ============================================================================
// HR Analytics Dashboard — Power Query (M) Data Prep
// Author: Karthik Kumar L A
// Stack: Power BI + Excel
//
// Purpose:
//   Gives HR leadership a single, real-time view of headcount trends,
//   attrition drivers, and hiring funnel efficiency, replacing disconnected
//   manual reports.
// ============================================================================

let
    Source = Excel.Workbook(File.Contents("C:\HRData\Workforce_Master.xlsx"), null, true),
    EmployeeTable = Source{[Item="Employees", Kind="Table"]}[Data],

    // Standardize types
    TypedEmployees = Table.TransformColumnTypes(
        EmployeeTable,
        {
            {"EmployeeID", type text},
            {"Department", type text},
            {"HireDate", type date},
            {"TerminationDate", type date},
            {"Status", type text}
        }
    ),

    // Add tenure in months (as of today, or termination date if exited)
    AddTenure = Table.AddColumn(
        TypedEmployees,
        "TenureMonths",
        each Duration.TotalDays(
                (if [Status] = "Active" then DateTime.Date(DateTime.LocalNow()) else [TerminationDate])
                - [HireDate]
             ) / 30.44,
        type number
    ),

    // Flag attrition
    AddAttritionFlag = Table.AddColumn(
        AddTenure,
        "IsAttrition",
        each if [Status] = "Terminated" then 1 else 0,
        Int64.Type
    ),

    // Bucket tenure for cohort analysis
    AddTenureBucket = Table.AddColumn(
        AddAttritionFlag,
        "TenureBucket",
        each if [TenureMonths] < 6 then "0-6 months"
             else if [TenureMonths] < 12 then "6-12 months"
             else if [TenureMonths] < 24 then "1-2 years"
             else "2+ years",
        type text
    )
in
    AddTenureBucket
