# SQL Data Warehouse & Reporting Solution

*Oracle SQL + ETL*

## Business Problem
Reporting depended on inconsistent, siloed data with no centralized,
validated source of truth, causing discrepancies and slow turnaround.

## Business Impact
Improved data accuracy and reduced reconciliation effort while
accelerating report delivery.

## Dashboard Preview
![SQL Data Warehouse & Reporting Solution](https://karthikkumardataanalystportfolio-craft-521.lovable.app/assets/gallery-sql-B-47Ervb.jpg)

## Tech Stack
Oracle SQL, ETL, Data Validation

## What's Inside
- `DataWarehouse_ETL.sql` — staging table, validation view, MERGE-based
  load into the warehouse fact table, a source-vs-warehouse reconciliation
  report, and an exception report for failed records.

## How It Works
1. Raw data from multiple source systems lands in `STG_TRANSACTIONS`
   (a staging table) before anything touches the warehouse.
2. `VW_TRANSACTION_VALIDATION` flags records with missing fields,
   future-dated transactions, or zero-value transactions — nothing
   invalid reaches the warehouse.
3. A `MERGE` statement loads only validated records into
   `FACT_TRANSACTIONS`, safely re-runnable for the same batch without
   creating duplicates.
4. A reconciliation report compares daily warehouse totals by source
   system, used to catch load discrepancies early.
5. An exception report surfaces anything that failed validation, so it
   can be corrected at the source and reloaded.
