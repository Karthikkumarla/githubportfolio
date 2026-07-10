Attribute VB_Name = "EmailReportDistribution"
'==================================================================================
' MODULE:      EmailReportDistribution
' PURPOSE:     Generates a formatted summary report from live workbook data and
'              auto-distributes it to a stakeholder list via Outlook, on demand
'              or via a scheduled Windows Task calling this macro.
' AUTHOR:      Karthik Kumar L A
' REQUIRES:    Reference to "Microsoft Outlook XX.0 Object Library"
'              (Tools > References in the VBA editor)
'==================================================================================

Option Explicit

Private Const RECIPIENT_SHEET As String = "Distribution_List"
Private Const REPORT_SHEET As String = "Report_Summary"

Public Sub RunAutomatedReportDistribution()

    Dim wb As Workbook
    Dim wsReport As Worksheet
    Dim wsRecipients As Worksheet
    Dim htmlBody As String
    Dim recipients As String
    Dim ccList As String
    Dim reportPath As String

    Set wb = ThisWorkbook
    Set wsReport = wb.Worksheets(REPORT_SHEET)
    Set wsRecipients = wb.Worksheets(RECIPIENT_SHEET)

    reportPath = ExportReportAsPDF(wsReport)
    htmlBody = BuildHTMLSummary(wsReport)
    recipients = BuildRecipientList(wsRecipients, "To")
    ccList = BuildRecipientList(wsRecipients, "CC")

    SendReportEmail recipients, ccList, htmlBody, reportPath

    MsgBox "Report distributed to: " & recipients, vbInformation

End Sub

Private Function ExportReportAsPDF(ByVal ws As Worksheet) As String
    Dim outputPath As String
    outputPath = ThisWorkbook.Path & "\Report_" & Format(Date, "yyyy-mm-dd") & ".pdf"
    ws.ExportAsFixedFormat Type:=xlTypePDF, Filename:=outputPath, Quality:=xlQualityStandard
    ExportReportAsPDF = outputPath
End Function

Private Function BuildRecipientList(ByVal ws As Worksheet, ByVal recipientType As String) As String
    Dim lastRow As Long, r As Long
    Dim result As String

    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    For r = 2 To lastRow
        If UCase(ws.Cells(r, 3).Value) = UCase(recipientType) Then
            result = result & ws.Cells(r, 2).Value & ";"
        End If
    Next r

    If Len(result) > 0 Then result = Left(result, Len(result) - 1)
    BuildRecipientList = result
End Function

Private Function BuildHTMLSummary(ByVal ws As Worksheet) As String
    Dim lastRow As Long, lastCol As Long
    Dim r As Long, c As Long
    Dim html As String

    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    lastCol = ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column

    html = "<p>Hi team,</p><p>Please find the automated summary report below, attached as PDF.</p>"
    html = html & "<table border='1' style='border-collapse:collapse;font-family:Calibri;font-size:11pt;'>"

    For r = 1 To lastRow
        html = html & "<tr>"
        For c = 1 To lastCol
            If r = 1 Then
                html = html & "<td style='background:#1F4E79;color:#FFFFFF;padding:4px 8px;'><b>" & _
                       ws.Cells(r, c).Text & "</b></td>"
            Else
                html = html & "<td style='padding:4px 8px;'>" & ws.Cells(r, c).Text & "</td>"
            End If
        Next c
        html = html & "</tr>"
    Next r

    html = html & "</table><p>This is an automated distribution. Full detail is attached.</p>"
    BuildHTMLSummary = html
End Function

Private Sub SendReportEmail(ByVal toList As String, ByVal ccList As String, _
                            ByVal htmlBody As String, ByVal attachmentPath As String)

    Dim outApp As Object
    Dim outMail As Object

    Set outApp = CreateObject("Outlook.Application")
    Set outMail = outApp.CreateItem(0) ' olMailItem

    With outMail
        .To = toList
        .CC = ccList
        .Subject = "Automated Summary Report - " & Format(Date, "dd-mmm-yyyy")
        .HTMLBody = htmlBody
        .Attachments.Add attachmentPath
        .Send   ' use .Display instead of .Send to review before sending
    End With

    Set outMail = Nothing
    Set outApp = Nothing

End Sub
