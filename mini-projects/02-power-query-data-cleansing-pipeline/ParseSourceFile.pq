// ============================================================================
// Power Query (M) — Helper function used by DataCleansingPipeline.pq
// Parses a single binary file (CSV or XLSX) into a standard table shape.
// Create this as a separate Query named "ParseSourceFile" in your model.
// ============================================================================

(fileContent as binary, fileExtension as text) as table =>
let
    ParsedTable =
        if fileExtension = ".csv" then
            Csv.Document(fileContent, [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv])
        else
            let
                workbook = Excel.Workbook(fileContent, null, true),
                firstSheet = workbook{0}[Data]
            in
                firstSheet,

    PromotedHeaders = Table.PromoteHeaders(ParsedTable, [PromoteAllScalars=true])
in
    PromotedHeaders
