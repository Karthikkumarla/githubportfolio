Attribute VB_Name = "VarianceExceptionFlagging"
'==================================================================================
' MODULE:      VarianceExceptionFlagging
' PURPOSE:     Compares current vs. prior period data (matched by key column),
'              auto-highlights variances beyond a configurable threshold, and
'              generates an exception summary sheet for stakeholder review.
' AUTHOR:      Karthik Kumar L A
' USAGE:       Populate "CurrentPeriod" and "PriorPeriod" sheets with a Key
'              column and a Value column, then run RunVarianceCheck().
'==================================================================================

Option Explicit

Private Const CURRENT_SHEET As String = "CurrentPeriod"
Private Const PRIOR_SHEET As String = "PriorPeriod"
Private Const EXCEPTIONS_SHEET As String = "Exceptions"
Private Const VARIANCE_THRESHOLD_PCT As Double = 0.1   ' 10% variance threshold

Public Sub RunVarianceCheck()

    Dim wb As Workbook
    Dim wsCurrent As Worksheet, wsPrior As Worksheet, wsExceptions As Worksheet
    Dim priorDict As Object
    Dim lastRowCurrent As Long, lastRowPrior As Long
    Dim r As Long, exceptionRow As Long
    Dim key As Variant
    Dim currentVal As Double, priorVal As Double, variancePct As Double
    Dim flaggedCount As Long

    Set wb = ThisWorkbook
    Set wsCurrent = wb.Worksheets(CURRENT_SHEET)
    Set wsPrior = wb.Worksheets(PRIOR_SHEET)
    Set wsExceptions = GetOrCreateSheet(wb, EXCEPTIONS_SHEET)

    ' Build a lookup dictionary of prior-period values by key
    Set priorDict = CreateObject("Scripting.Dictionary")
    lastRowPrior = wsPrior.Cells(wsPrior.Rows.Count, "A").End(xlUp).Row
    For r = 2 To lastRowPrior
        priorDict(wsPrior.Cells(r, 1).Value) = wsPrior.Cells(r, 2).Value
    Next r

    ' Prepare exceptions output sheet
    wsExceptions.Cells.Clear
    wsExceptions.Range("A1:E1").Value = Array("Key", "Current", "Prior", "Variance %", "Status")
    With wsExceptions.Range("A1:E1")
        .Font.Bold = True
        .Interior.Color = RGB(31, 78, 121)
        .Font.Color = RGB(255, 255, 255)
    End With

    lastRowCurrent = wsCurrent.Cells(wsCurrent.Rows.Count, "A").End(xlUp).Row
    exceptionRow = 2
    flaggedCount = 0

    For r = 2 To lastRowCurrent
        key = wsCurrent.Cells(r, 1).Value
        currentVal = wsCurrent.Cells(r, 2).Value

        If priorDict.Exists(key) Then
            priorVal = priorDict(key)
            If priorVal <> 0 Then
                variancePct = (currentVal - priorVal) / Abs(priorVal)
            Else
                variancePct = IIf(currentVal = 0, 0, 1)
            End If

            If Abs(variancePct) >= VARIANCE_THRESHOLD_PCT Then
                wsExceptions.Cells(exceptionRow, 1).Value = key
                wsExceptions.Cells(exceptionRow, 2).Value = currentVal
                wsExceptions.Cells(exceptionRow, 3).Value = priorVal
                wsExceptions.Cells(exceptionRow, 4).Value = variancePct
                wsExceptions.Cells(exceptionRow, 4).NumberFormat = "0.0%"
                wsExceptions.Cells(exceptionRow, 5).Value = IIf(variancePct > 0, "Increase", "Decrease")

                HighlightRow wsExceptions, exceptionRow, variancePct
                exceptionRow = exceptionRow + 1
                flaggedCount = flaggedCount + 1
            End If
        Else
            ' Key exists in current period but not in prior period at all
            wsExceptions.Cells(exceptionRow, 1).Value = key
            wsExceptions.Cells(exceptionRow, 2).Value = currentVal
            wsExceptions.Cells(exceptionRow, 3).Value = "N/A"
            wsExceptions.Cells(exceptionRow, 5).Value = "New Item"
            wsExceptions.Rows(exceptionRow).Interior.Color = RGB(255, 235, 156)
            exceptionRow = exceptionRow + 1
            flaggedCount = flaggedCount + 1
        End If
    Next r

    wsExceptions.Columns("A:E").AutoFit

    MsgBox flaggedCount & " exception(s) flagged at a " & Format(VARIANCE_THRESHOLD_PCT, "0%") & _
           " variance threshold. See '" & EXCEPTIONS_SHEET & "' tab.", vbInformation

End Sub

Private Sub HighlightRow(ByVal ws As Worksheet, ByVal rowNum As Long, ByVal variancePct As Double)
    If variancePct > 0 Then
        ws.Rows(rowNum).Interior.Color = RGB(198, 239, 206)   ' green-ish: increase
    Else
        ws.Rows(rowNum).Interior.Color = RGB(255, 199, 206)   ' red-ish: decrease
    End If
End Sub

Private Function GetOrCreateSheet(ByVal wb As Workbook, ByVal sheetName As String) As Worksheet
    Dim ws As Worksheet
    On Error Resume Next
    Set ws = wb.Worksheets(sheetName)
    On Error GoTo 0
    If ws Is Nothing Then
        Set ws = wb.Worksheets.Add(After:=wb.Worksheets(wb.Worksheets.Count))
        ws.Name = sheetName
    End If
    Set GetOrCreateSheet = ws
End Function
