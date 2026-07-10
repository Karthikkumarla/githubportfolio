# Featured Case Studies — Sync Package

This folder contains the 4 "Featured Case Studies" from the portfolio site,
with real SQL/DAX/Power Query code and README docs matching each project
card exactly.

## Projects included

| # | Folder | Project | Portfolio Card |
|---|--------|---------|-----------------|
| 1 | `01-claims-analytics-dashboard` | Claims Analytics Dashboard | SQL + Power BI + DAX |
| 2 | `02-sales-performance-dashboard` | Sales Performance Dashboard | SQL + Power BI + Excel |
| 3 | `03-hr-analytics-dashboard` | HR Analytics Dashboard | Power BI + Excel |
| 4 | `04-sql-data-warehouse-reporting` | SQL Data Warehouse & Reporting Solution | Oracle SQL + ETL |

Each folder's README includes an inline dashboard preview image pointing
to the correct portfolio domain, so it renders directly on GitHub.

## Important fix: image domain mismatch

Your existing profile README's dashboard images pointed to
`karthikresume-craft-521.lovable.app`, but your live portfolio is at
`karthikkumardataanalystportfolio-craft-521.lovable.app`. That mismatch is
why the dashboard images showed as broken links. All READMEs in this
package use the correct domain.

## How to sync into your repo

```bash
cd "C:/Users/karthik05/OneDrive/Documents/Projects"
# after extracting featured-projects.zip here

cd githubportfolio
mkdir -p featured-projects
cp -r ../featured-projects/* featured-projects/
git add .
git commit -m "Add Featured Case Studies with SQL/DAX/Power Query code"
git push
```

Then update each "View Code" link on the portfolio's Featured Case Studies
cards to point to:
```
https://github.com/Karthikkumarla/githubportfolio/tree/main/featured-projects/01-claims-analytics-dashboard
https://github.com/Karthikkumarla/githubportfolio/tree/main/featured-projects/02-sales-performance-dashboard
https://github.com/Karthikkumarla/githubportfolio/tree/main/featured-projects/03-hr-analytics-dashboard
https://github.com/Karthikkumarla/githubportfolio/tree/main/featured-projects/04-sql-data-warehouse-reporting
```
