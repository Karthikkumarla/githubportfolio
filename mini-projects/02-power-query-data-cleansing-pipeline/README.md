# Power Query: Automated Data Cleansing & Merge Pipeline

## Overview
A reusable Power Query pipeline that ingests raw CSV/Excel exports from
multiple operational source systems, standardizes column names/types,
removes duplicates, and merges everything into a single analysis-ready
table — refreshable with one click.

## Business Impact
Removed recurring manual cleanup (renaming columns, deduping, retyping)
across multiple monthly source feeds, cutting data-prep time from hours
to a single refresh and eliminating inconsistent column naming across
departments feeding the same report.

## Tech Stack
- Power Query (M language)
- Power BI / Excel Data Model

## How It Works
1. `ParseSourceFile.pq` — helper function that reads either a CSV or XLSX
   file and returns a standardized table.
2. `DataCleansingPipeline.pq` — main query that:
   - Scans a folder for all `.csv`/`.xlsx` files
   - Parses each with the helper function
   - Renames inconsistent source-system column names to a common schema
   - Enforces correct data types
   - Trims/proper-cases text fields
   - Removes duplicate rows and rows with missing key fields

## Setup
1. In Power BI Desktop or Excel: **Home → Get Data → Blank Query**.
2. Create a query named `ParseSourceFile`, open the Advanced Editor, paste
   the contents of `ParseSourceFile.pq`.
3. Create a second query, paste `DataCleansingPipeline.pq`, and update
   `SourceFolderPath` to your data feed folder.
4. Click **Refresh** — the pipeline re-runs end to end.

## Files
- `DataCleansingPipeline.pq` — main pipeline query
- `ParseSourceFile.pq` — reusable file-parsing helper function
