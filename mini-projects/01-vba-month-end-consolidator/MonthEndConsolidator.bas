Attribute VB_Name = "MonthEndConsolidator"
'==================================================================================
' MODULE:      MonthEndConsolidator
' PURPOSE:     Consolidates multiple department Excel workbooks (stored in a single
'              source folder) into one master workbook, applies standard formatting,
'              and builds a summary tab with department-wise totals.
' AUTHOR:      Karthik Kumar L A
' USAGE:       Update SOURCE_FOLDER and run RunMonthEndConsolidation().
'==================================================================================

Option Explicit

Private Const SOURCE_FOLDER As String = "C:\MonthEndReports\Departments\"
Private Const MASTER_SHEET_NAME As String = "Master_Consolidated"
Private Const SUMMARY_SHEET_NAME As String = "Summary"

Public Sub RunMonthEndConsolidation()

    Dim wbMaster As Workbook
    Dim wsMaster As Worksheet
    Dim wsSummary As Worksheet
    Dim fileName As String
    Dim wbSource As Workbook
    Dim lastRowMaster As Long
    Dim lastRowSource As Long
    Dim startTime As Double

    startTime = Timer
    Application.ScreenUpdating = False
    Application.DisplayAlerts = False
    Application.Calculation = xlCalculationManual

    Set wbMaster = ThisWorkbook
    Set wsMaster = GetOrCreateSheet(wbMaster, MASTER_SHEET_NAME, True)
    Set wsSummary = GetOrCreateSheet(wbMaster, SUMMARY_SHEET_NAME, True)

    ' Write master header once
    wsMaster.Range("A1:E1").Value = Array("Department", "Category", "Amount", "Date", "SourceFile")
    FormatHeaderRow wsMaster.Range("A1:E1")

    fileName = Dir(SOURCE_FOLDER & "*.xlsx")

    Do While fileName <> ""
        Set wbSource = Workbooks.Open(SOURCE_FOLDER & fileName, ReadOnly:=True)

        With wbSource.Worksheets(1)
            lastRowSource = .Cells(.Rows.Count, "A").End(xlUp).Row
            If lastRowSource > 1 Then
                lastRowMaster = wsMaster.Cells(wsMaster.Rows.Count, "A").End(xlUp).Row + 1
                .Range("A2:C" & lastRowSource).Copy
                wsMaster.Range("A" & lastRowMaster).PasteSpecial xlPasteValues
                wsMaster.Range("D" & lastRowMaster & ":D" & lastRowMaster + lastRowSource - 2).Value = Date
                wsMaster.Range("E" & lastRowMaster & ":E" & lastRowMaster + lastRowSource - 2).Value = fileName
            End If
        End With

        wbSource.Close SaveChanges:=False
        fileName = Dir
    Loop

    Application.CutCopyMode = False
    wsMaster.Columns("A:E").AutoFit
    BuildSummaryTab wsMaster, wsSummary

    Application.Calculation = xlCalculationAutomatic
    Application.ScreenUpdating = True
    Application.DisplayAlerts = True

    MsgBox "Consolidation complete in " & Format(Timer - startTime, "0.0") & " seconds." & vbCrLf & _
           "Rows consolidated: " & (wsMaster.Cells(wsMaster.Rows.Count, "A").End(xlUp).Row - 1), vbInformation

End Sub

Private Sub BuildSummaryTab(ByVal wsMaster As Worksheet, ByVal wsSummary As Worksheet)

    Dim lastRow As Long, r As Long
    Dim dict As Object
    Dim key As Variant
    Dim outRow As Long

    Set dict = CreateObject("Scripting.Dictionary")
    lastRow = wsMaster.Cells(wsMaster.Rows.Count, "A").End(xlUp).Row

    For r = 2 To lastRow
        key = wsMaster.Cells(r, 1).Value
        If dict.Exists(key) Then
            dict(key) = dict(key) + wsMaster.Cells(r, 3).Value
        Else
            dict.Add key, wsMaster.Cells(r, 3).Value
        End If
    Next r

    wsSummary.Cells.Clear
    wsSummary.Range("A1:B1").Value = Array("Department", "Total Amount")
    FormatHeaderRow wsSummary.Range("A1:B1")

    outRow = 2
    For Each key In dict.Keys
        wsSummary.Cells(outRow, 1).Value = key
        wsSummary.Cells(outRow, 2).Value = dict(key)
        wsSummary.Cells(outRow, 2).NumberFormat = "#,##0.00"
        outRow = outRow + 1
    Next key

    wsSummary.Columns("A:B").AutoFit

End Sub

Private Function GetOrCreateSheet(ByVal wb As Workbook, ByVal sheetName As String, ByVal clearIfExists As Boolean) As Worksheet
    Dim ws As Worksheet
    On Error Resume Next
    Set ws = wb.Worksheets(sheetName)
    On Error GoTo 0
    If ws Is Nothing Then
        Set ws = wb.Worksheets.Add(After:=wb.Worksheets(wb.Worksheets.Count))
        ws.Name = sheetName
    ElseIf clearIfExists Then
        ws.Cells.Clear
    End If
    Set GetOrCreateSheet = ws
End Function

Private Sub FormatHeaderRow(ByVal rng As Range)
    With rng
        .Font.Bold = True
        .Interior.Color = RGB(31, 78, 121)
        .Font.Color = RGB(255, 255, 255)
    End With
End Sub
