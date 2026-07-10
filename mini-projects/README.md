# Mini Projects & Skill Demos — Sync Package

This folder contains 6 ready-to-upload mini projects matching the
"Mini Projects & Skill Demos" section on the portfolio site
(karthikkumardataanalystportfolio-craft-521.lovable.app), replacing the
old Python-based demos with automation/macro/SQL/Power BI projects that
match your actual skill set.

## Projects included

| # | Folder | Project | Maps to portfolio card |
|---|--------|---------|--------------------------|
| 1 | `01-vba-month-end-consolidator` | One-Click Month-End Report Consolidator | VBA Macro: One-Click Month-End Report Consolidator |
| 2 | `02-power-query-data-cleansing-pipeline` | Automated Data Cleansing & Merge Pipeline | Power Query: Automated Data Cleansing & Merge Pipeline |
| 3 | `03-vba-variance-exception-flagging` | Automated Variance & Exception Flagging Tool | VBA Macro: Automated Variance & Exception Flagging Tool |
| 4 | `04-sql-daily-kpi-snapshot` | Automated Daily KPI Snapshot Job | SQL: Automated Daily KPI Snapshot Job |
| 5 | `05-powerbi-sla-compliance-tracker` | Self-Refreshing SLA Compliance Tracker | Power BI + Power Query: Self-Refreshing SLA Compliance Tracker |
| 6 | `06-vba-email-report-distribution` | Automated Email Report Distribution | VBA Macro: Automated Email Report Distribution |

Each folder has its own `README.md` with the business problem, impact,
tech stack, and setup steps — same structure as your Featured Case
Studies, sized for a mini-project.

## How to sync this into your GitHub repo

1. Go to `https://github.com/Karthikkumarla/githubportfolio`.
2. **Remove** any existing Python-based mini-project folders/files that
   are no longer on the portfolio site (Student Grade Calculator,
   Automated File Organizer, Excel Report Generator with Python, Email
   Report Scheduler with Python).
3. Create a `mini-projects/` folder in the repo (if it doesn't already
   exist) and upload these 6 folders into it — either via:
   - **GitHub web UI**: "Add file → Upload files", drag in each folder, or
   - **Git CLI**:
     ```bash
     git clone https://github.com/Karthikkumarla/githubportfolio.git
     cp -r mini-projects/* githubportfolio/mini-projects/
     cd githubportfolio
     git add .
     git commit -m "Replace Python mini-projects with automation/macro/SQL/Power BI projects"
     git push
     ```
4. Update each "View Code" link on the portfolio site's Mini Projects
   cards to point to the matching subfolder, e.g.:
   `https://github.com/Karthikkumarla/githubportfolio/tree/main/mini-projects/01-vba-month-end-consolidator`

## Note on visible dashboards

I wasn't able to browse your GitHub repo directly (GitHub blocks
automated crawling), so I couldn't diagnose exactly why some dashboards
aren't rendering. The most common causes for "dashboard not visible" on
GitHub:
- **Power BI `.pbix` files don't render in-browser on GitHub** — GitHub
  only shows a download link, not a live preview. If you want dashboards
  visible directly on GitHub, add a screenshot/GIF of the dashboard in
  each project's README (GitHub renders images inline) alongside the
  `.pbix` file for download.
- **Large files** (`.pbix` over ~25MB) may fail to upload via the web UI
  and need Git LFS.
- If a repo/folder was recently pushed, GitHub's file browser can lag a
  few minutes before showing new content.

If you paste the repo's file/folder listing here, I can tell you exactly
what's missing or misconfigured.
