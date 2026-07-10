# VBA Macro: Automated Email Report Distribution

## Overview
Macro that generates a formatted summary report from live workbook data,
exports it as PDF, builds an HTML email summary, and auto-distributes it
to a stakeholder list via Outlook — on a set schedule or on demand.

## Business Impact
Eliminated manual report circulation: report generation, formatting, and
distribution to 10+ stakeholders that previously took ~30 minutes per
cycle now runs in seconds with a single click (or fully unattended via
Windows Task Scheduler).

## Tech Stack
- Excel VBA (Macros)
- Outlook Object Model (COM automation)
- HTML email generation from live worksheet data

## How It Works
1. Reads report data from a `Report_Summary` sheet.
2. Exports that sheet as a PDF attachment.
3. Builds an HTML table summary directly from the sheet's live values.
4. Reads a `Distribution_List` sheet (Name, Email, Type — To/CC) to build
   recipient lists.
5. Sends the email via Outlook automation with the PDF attached.

## Setup
1. In the VBA editor: **Tools → References** → check "Microsoft Outlook
   XX.0 Object Library".
2. Import `EmailReportDistribution.bas`.
3. Create `Report_Summary` and `Distribution_List` sheets in the workbook.
4. Run `RunAutomatedReportDistribution()`, or schedule it via a Windows
   Task calling the workbook with `/e` and an Auto_Open macro trigger.

> Tip: Change `.Send` to `.Display` in `SendReportEmail` while testing, so
> you can review the email before it actually sends.

## Files
- `EmailReportDistribution.bas` — VBA module source code
