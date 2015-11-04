inherited FrmChlOperatorCA: TFrmChlOperatorCA
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcTskChlOperator: TSvcRptCfgChoiceTask
    Sequences = <
      item
        Name = 'IdtOperator'
        DataType = pftString
        RangeLength = 21
        Title = 'Num'#233'ro hote(sse) de caisse'
        ParamValueSequence = 'Operator.IdtOperator'
      end
      item
        Name = 'TxtName'
        DataType = pftString
        RangeLength = 30
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'TxtName'
        Title = 'Name'
        ParamValueSequence = 'TxtSrcName'
      end>
    ReportFields = <
      item
        Name = 'IdtOperator'
        DataType = pftString
        RangeLength = 21
        IdtLabel = 'IdtOperator2'
        DataFieldName = 'Operator.IdtOperator'
        ReportWidth = 21
      end
      item
        Name = 'TxtName'
        DataType = pftString
        RangeLength = 30
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'Operator.TxtSrcName'
        IdtLabel = 'TxtName'
        DataFieldName = 'Operator.TxtName'
        ReportWidth = 30
      end
      item
        Name = 'CodSecurity'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '99999'
        RangeLength = 5
        RangeOptions = [rioRangeList]
        SprRangeItems = DmdFpnUtils.SprCnvCodes
        PrmRangeItems = 'Operator.CodSecurity'
        IdtLabel = 'CodSecurity'
        DataFieldName = 'Operator.CodSecurity'
        ReportWidth = 30
      end
      item
        Name = 'IdtBadge'
        DataType = pftString
        RangeLength = 30
        IdtLabel = 'IdtBadge'
        DataFieldName = 'Operator.TxtPassword'
        ReportWidth = 30
      end
      item
        Name = 'IdtLanguage'
        DataType = pftString
        RangeLength = 3
        IdtLabel = 'LnkLanguage'
        DataFieldName = 'Operator.IdtLanguage'
        ReportWidth = 8
      end
      item
        Name = 'FlgTenderCount'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '1'
        RangeLength = 1
        IdtLabel = 'FlgTenderCount'
        DataFieldName = 'FlgTenderCount'
        Title = 'Tender count'
        ReportWidth = 5
      end
      item
        Name = 'DatCreate'
        DataType = pftDate
        RangeLo = '01.01.1800'
        RangeHi = '31.12.3999'
        AllowSubString = False
        RangeLength = 10
        IdtLabel = 'DatCreate'
        DataFieldName = 'Operator.DatCreate'
        Alignment = taRightJustify
        ReportWidth = 10
      end
      item
        Name = 'DatModify'
        DataType = pftDate
        RangeLo = '01.01.1800'
        RangeHi = '31.12.3999'
        AllowSubString = False
        RangeLength = 10
        IdtLabel = 'DatModify'
        DataFieldName = 'Operator.DatModify'
        Alignment = taRightJustify
        ReportWidth = 10
      end>
    ExportFiles = <
      item
        Name = 'TRptExportFiles_0'
        FileDescription = 'CSV (Semicolon delimited)'
        FileMask = '*.csv'
        DefaultExtension = 'csv'
        SeparatorColumn = ';'
        SeparatorRow = '#13#10'
        IncludeReportHeader = False
        IncludeTableHeader = False
        IncludeReportComment = False
        IncludeReportFooter = False
      end
      item
        Name = 'TRptExportFiles_1'
        FileDescription = 'CSV (TAB delimited)'
        FileMask = '*.csv'
        DefaultExtension = 'csv'
        SeparatorColumn = '#9'
        SeparatorRow = '#13#10'
        IncludeReportHeader = False
        IncludeTableHeader = False
        IncludeReportComment = False
        IncludeReportFooter = False
      end
      item
        Name = 'TRptExportFiles_2'
        FileDescription = 'Text (Semicolon delimited)'
        FileMask = '*.txt'
        DefaultExtension = 'txt'
        SeparatorColumn = ';'
        SeparatorRow = '#13#10'
        IncludeReportHeader = False
        IncludeTableHeader = False
        IncludeReportComment = False
        IncludeReportFooter = False
      end
      item
        Name = 'TRptExportFiles_3'
        FileDescription = 'Text (TAB delimited)'
        FileMask = '*.txt'
        DefaultExtension = 'txt'
        SeparatorColumn = '#9'
        SeparatorRow = '#13#10'
        IncludeReportHeader = False
        IncludeTableHeader = False
        IncludeReportComment = False
        IncludeReportFooter = False
      end>
  end
end
