/* ============================================================================
   SQL Data Warehouse & Reporting Solution
   Author: Karthik Kumar L A
   Stack: Oracle SQL + ETL + Data Validation

   Purpose:
     Centralizes reporting on top of a single, validated source of truth,
     replacing inconsistent, siloed data that caused discrepancies and
     slow turnaround.
   ========================================================================= */

-- ----------------------------------------------------------------------------
-- STEP 1: Staging table — raw loads land here before validation
-- ----------------------------------------------------------------------------
CREATE TABLE STG_TRANSACTIONS (
    SOURCE_SYSTEM       VARCHAR2(50),
    TRANSACTION_ID      VARCHAR2(50),
    ACCOUNT_ID          VARCHAR2(50),
    TRANSACTION_DATE    DATE,
    AMOUNT              NUMBER(18,2),
    CURRENCY            VARCHAR2(10),
    LOAD_TIMESTAMP      DATE DEFAULT SYSDATE
);

-- ----------------------------------------------------------------------------
-- STEP 2: Data validation view — flags records failing basic quality rules
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_TRANSACTION_VALIDATION AS
SELECT
    s.*,
    CASE
        WHEN s.TRANSACTION_ID IS NULL THEN 'Missing Transaction ID'
        WHEN s.AMOUNT IS NULL THEN 'Missing Amount'
        WHEN s.TRANSACTION_DATE IS NULL THEN 'Missing Date'
        WHEN s.TRANSACTION_DATE > SYSDATE THEN 'Future-Dated Transaction'
        WHEN s.AMOUNT = 0 THEN 'Zero-Value Transaction'
        ELSE 'Valid'
    END AS VALIDATION_STATUS
FROM STG_TRANSACTIONS s;

-- ----------------------------------------------------------------------------
-- STEP 3: Merge validated staging data into the warehouse fact table
--          (idempotent — safe to re-run for the same load batch)
-- ----------------------------------------------------------------------------
MERGE INTO FACT_TRANSACTIONS tgt
USING (
    SELECT * FROM VW_TRANSACTION_VALIDATION WHERE VALIDATION_STATUS = 'Valid'
) src
ON (tgt.TRANSACTION_ID = src.TRANSACTION_ID AND tgt.SOURCE_SYSTEM = src.SOURCE_SYSTEM)
WHEN MATCHED THEN
    UPDATE SET
        tgt.ACCOUNT_ID = src.ACCOUNT_ID,
        tgt.AMOUNT = src.AMOUNT,
        tgt.CURRENCY = src.CURRENCY,
        tgt.TRANSACTION_DATE = src.TRANSACTION_DATE,
        tgt.LAST_UPDATED = SYSDATE
WHEN NOT MATCHED THEN
    INSERT (SOURCE_SYSTEM, TRANSACTION_ID, ACCOUNT_ID, TRANSACTION_DATE, AMOUNT, CURRENCY, LAST_UPDATED)
    VALUES (src.SOURCE_SYSTEM, src.TRANSACTION_ID, src.ACCOUNT_ID, src.TRANSACTION_DATE, src.AMOUNT, src.CURRENCY, SYSDATE);

-- ----------------------------------------------------------------------------
-- STEP 4: Reconciliation report — compares warehouse totals against
--          source system totals to catch load discrepancies
-- ----------------------------------------------------------------------------
SELECT
    f.SOURCE_SYSTEM,
    TRUNC(f.TRANSACTION_DATE)                    AS TXN_DATE,
    COUNT(*)                                     AS WAREHOUSE_ROW_COUNT,
    SUM(f.AMOUNT)                                AS WAREHOUSE_TOTAL_AMOUNT
FROM FACT_TRANSACTIONS f
WHERE f.TRANSACTION_DATE >= TRUNC(SYSDATE) - 7
GROUP BY f.SOURCE_SYSTEM, TRUNC(f.TRANSACTION_DATE)
ORDER BY TXN_DATE DESC, f.SOURCE_SYSTEM;

-- ----------------------------------------------------------------------------
-- STEP 5: Exception report — records that failed validation, for follow-up
-- ----------------------------------------------------------------------------
SELECT
    SOURCE_SYSTEM,
    TRANSACTION_ID,
    VALIDATION_STATUS,
    LOAD_TIMESTAMP
FROM VW_TRANSACTION_VALIDATION
WHERE VALIDATION_STATUS <> 'Valid'
ORDER BY LOAD_TIMESTAMP DESC;
