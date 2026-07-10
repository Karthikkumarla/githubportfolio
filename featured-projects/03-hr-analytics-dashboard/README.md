# HR Analytics Dashboard

*Power BI + Excel*

## Business Problem
HR teams struggled to track headcount trends, attrition drivers, and
hiring funnel efficiency from disconnected manual reports.

## Business Impact
Gave HR leadership a single, real-time view of workforce health and
reduced manual reporting effort.

## Dashboard Preview
![HR Analytics Dashboard](https://karthikkumardataanalystportfolio-craft-521.lovable.app/assets/gallery-hr-ChsMt16P.jpg)

## Tech Stack
Power BI, Excel

## What's Inside
- `HRAnalytics_PowerQuery.pq` — data prep pipeline that standardizes
  employee data, calculates tenure, flags attrition, and buckets tenure
  into cohorts for analysis.
- `HRAnalytics_DAX.txt` — DAX measures for headcount, attrition rate,
  average tenure, new hires, time-to-fill, and offer acceptance rate.

## How It Works
1. Power Query pulls employee data from an Excel workforce master file
   and calculates tenure in months (using termination date for exited
   employees, current date for active ones).
2. Employees are flagged for attrition and bucketed into tenure cohorts
   (0-6 months, 6-12 months, 1-2 years, 2+ years) to identify early
   attrition risk patterns.
3. DAX measures power headcount trend cards, an attrition-rate trend
   chart, and hiring funnel metrics (time-to-fill, offer acceptance rate)
   pulled from a linked requisitions table.
