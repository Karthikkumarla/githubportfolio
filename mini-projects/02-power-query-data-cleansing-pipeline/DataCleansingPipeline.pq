// ============================================================================
// Power Query (M) — Automated Data Cleansing & Merge Pipeline
// Author: Karthik Kumar L A
//
// Purpose:
//   Ingests raw CSV/Excel exports from multiple source systems, standardizes
//   column names/formats, removes duplicates, and merges everything into a
//   single analysis-ready table refreshable with one click.
//
// Usage:
//   In Power BI / Excel: Home > Get Data > Blank Query > Advanced Editor,
//   paste this script, then update SourceFolderPath below.
// ============================================================================

let
    SourceFolderPath = "C:\DataFeeds\Raw\",

    // Step 1: Pull every file in the source folder
    SourceFiles = Folder.Files(SourceFolderPath),

    // Step 2: Keep only supported extensions
    FilteredFiles = Table.SelectRows(
        SourceFiles,
        each Text.EndsWith([Extension], ".csv") or Text.EndsWith([Extension], ".xlsx")
    ),

    // Step 3: Load and normalize each file into a table via a custom function
    AddParsedTable = Table.AddColumn(FilteredFiles, "ParsedTable", each ParseSourceFile([Content], [Extension])),

    // Step 4: Expand all parsed tables into one flat table
    ExpandedTables = Table.Combine(AddParsedTable[ParsedTable]),

    // Step 5: Standardize column names across sources
    RenamedColumns = Table.RenameColumns(
        ExpandedTables,
        {
            {"Trans_Date", "TransactionDate"},
            {"Txn_Date", "TransactionDate"},
            {"Amt", "Amount"},
            {"Dept", "Department"},
            {"Dept_Name", "Department"}
        },
        MissingField.Ignore
    ),

    // Step 6: Enforce data types
    TypedTable = Table.TransformColumnTypes(
        RenamedColumns,
        {
            {"TransactionDate", type date},
            {"Amount", type number},
            {"Department", type text}
        }
    ),

    // Step 7: Trim/clean text columns
    TrimmedText = Table.TransformColumns(
        TypedTable,
        {{"Department", each Text.Trim(Text.Proper(_)), type text}}
    ),

    // Step 8: Remove exact duplicate rows
    DedupedTable = Table.Distinct(TrimmedText),

    // Step 9: Remove rows with nulls in key fields
    FinalTable = Table.SelectRows(
        DedupedTable,
        each [TransactionDate] <> null and [Amount] <> null and [Department] <> null
    )
in
    FinalTable
