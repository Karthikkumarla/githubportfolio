# VBA Macro: One-Click Month-End Report Consolidator

## Overview
Automates month-end reporting by pulling data from multiple department Excel
workbooks in a shared folder, consolidating them into a single master report,
applying standard formatting, and generating a department-wise summary tab.

## Business Impact
Reduced a ~3-hour manual consolidation task to under 2 minutes, while removing
copy-paste errors and ensuring a consistent report format across departments.

## Tech Stack
- Excel VBA (Macros)
- Scripting.Dictionary for aggregation
- Native Excel formatting APIs

## How It Works
1. Loops through every `.xlsx` file in a source folder (one file per department).
2. Copies transaction-level rows into a `Master_Consolidated` sheet, tagging each
   row with source file name and consolidation date.
3. Aggregates totals per department into a `Summary` sheet.
4. Reports total run time and row count on completion.

## Setup
1. Open `MonthEndConsolidator.bas` in the VBA editor (Alt+F11 → File → Import File).
2. Update the `SOURCE_FOLDER` constant to point to your department reports folder.
3. Run `RunMonthEndConsolidation()` from a workbook with macros enabled.

## Files
- `MonthEndConsolidator.bas` — VBA module source code
