inherited FrmChlCustomerCA: TFrmChlCustomerCA
  Caption = 'FrmChlCustomerCA'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcTskChlCustomer: TSvcRptCfgChoiceTask
    Sequences = <
      item
        Name = 'IdtCustomer'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '2147483647'
        RangeLength = 21
        Title = 'Customer Number'
        ParamValueSequence = 'Customer.IdtCustomer'
      end
      item
        Name = 'TxtPublName'
        DataType = pftString
        RangeLength = 30
        RangeOptions = [rioConvertToKeyStr]
        Title = 'Name'
        ParamValueSequence = 'Customer.TxtPublName'
      end>
    ReportFields = <
      item
        Name = 'IdtCustomer'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '2147483647'
        RangeLength = 10
        RangePicture = '2147483647'
        IdtLabel = 'IdtCustomer'
        DataFieldName = 'Customer.IdtCustomer'
        ReportWidth = 10
      end
      item
        Name = 'TxtPublName'
        DataType = pftString
        RangeLength = 10
        RangeOptions = [rioConvertToKeyStr]
        IdtLabel = 'TxtPublName'
        DataFieldName = 'Address.TxtName'
        ReportWidth = 25
      end
      item
        Name = 'TxtTitle'
        DataType = pftString
        RangeLength = 10
        IdtLabel = 'TxtTitle'
        DataFieldName = 'Address.TxtTitle'
        ReportWidth = 10
      end
      item
        Name = 'TxtStreet'
        DataType = pftString
        RangeLength = 10
        IdtLabel = 'TxtStreet'
        DataFieldName = 'Address.TxtStreet'
        ReportWidth = 10
      end
      item
        Name = 'TxtNameMunicipality'
        DataType = pftString
        RangeLength = 10
        DataFieldRange = 'Municipality.TxtName'
        IdtLabel = 'TxtNameMunicipality'
        DataFieldName = 'TxtNameMunicipality=Municipality.TxtName'
        ReportWidth = 8
      end
      item
        Name = 'TxtCodPost'
        DataType = pftString
        RangeLength = 10
        IdtLabel = 'TxtCodPost'
        DataFieldName = 'Municipality.TxtCodPost'
        ReportWidth = 8
      end
      item
        Name = 'TxtProvince'
        DataType = pftString
        RangeLength = 10
        IdtLabel = 'Province'
        DataFieldName = 'Customer.TxtProvince'
        ReportWidth = 8
      end
      item
        Name = 'TxtNameCountry'
        DataType = pftString
        RangeLength = 10
        DataFieldRange = 'Country.TxtName'
        IdtLabel = 'TxtNameCountry'
        DataFieldName = 'TxtNameCountry=Country.TxtName'
        ReportWidth = 8
      end
      item
        Name = 'IdtCustPrcCat'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '2147483647'
        RangeLength = 10
        IdtLabel = 'IdtCustPrcCat'
        DataFieldName = 'CustPrcCat.IdtCustPrcCat'
        ReportWidth = 8
      end
      item
        Name = 'TxtExplanation'
        DataType = pftString
        RangeLength = 10
        IdtLabel = 'TxtExplanation'
        DataFieldName = 'CustPrcCat.TxtExplanation'
        ReportWidth = 11
      end
      item
        Name = 'TxtINN'
        DataType = pftString
        RangeLength = 10
        IdtLabel = 'INN'
        DataFieldName = 'Customer.TxtINN'
        ReportWidth = 8
      end
      item
        Name = 'TxtKPP'
        DataType = pftString
        RangeLength = 10
        IdtLabel = 'KPP'
        DataFieldName = 'Customer.TxtKPP'
        ReportWidth = 8
      end
      item
        Name = 'TxtOKPO'
        DataType = pftString
        RangeLength = 10
        IdtLabel = 'OKPO'
        DataFieldName = 'Customer.TxtOKPO'
        ReportWidth = 8
      end
      item
        Name = 'TxtTypeCompany'
        DataType = pftString
        RangeLength = 10
        IdtLabel = 'TxtTypeCompany'
        DataFieldName = 'Customer.TxtCompanyType'
        ReportWidth = 8
      end
      item
        Name = 'FlgCreditLim'
        DataType = pftBoolean
        AllowSubString = False
        RangeLength = 5
        RangePicture = '9'
        IdtLabel = 'FlgCreditLim'
        DataFieldName = 'Customer.FlgCreditLim'
        ReportWidth = 5
      end
      item
        Name = 'ValCreditLim'
        DataType = pftLongInt
        RangeLength = 10
        IdtLabel = 'ValCreditLim'
        DataFieldName = 'Customer.ValCreditLim'
        ReportWidth = 10
      end
      item
        Name = 'IdtCurrency'
        DataType = pftString
        RangeLength = 10
        IdtLabel = 'IdtCurrency'
        DataFieldName = 'Customer.IdtCurrency'
        ReportWidth = 10
      end
      item
        Name = 'ValSale'
        DataType = pftLongInt
        RangeLength = 10
        IdtLabel = 'ValSale'
        DataFieldName = 'Customer.ValSale'
        ReportWidth = 10
      end
      item
        Name = 'TxtNumVAT'
        DataType = pftString
        RangeLength = 0
        IdtLabel = 'TxtNumVAT'
        DataFieldName = 'Customer.TxtNumVAT'
        ReportWidth = 10
      end
      item
        Name = 'CodVATSystem'
        DataType = pftBoolean
        AllowSubString = False
        RangeLength = 1
        RangePicture = '9'
        RangeOptions = [rioRangeList]
        SprRangeItems = DmdFpnUtils.SprCnvCodes
        PrmRangeItems = 'Customer.CodVATSystem'
        IdtLabel = 'CodVATSystem'
        DataFieldName = 'Customer.CodVATSystem'
        ReportWidth = 10
      end
      item
        Name = 'QtyCopyInv'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '9'
        RangeLength = 10
        IdtLabel = 'QtyCopyInv'
        DataFieldName = 'Customer.QtyCopyInv'
        ReportWidth = 10
      end
      item
        Name = 'NumInvExpDays'
        DataType = pftLongInt
        RangeLength = 10
        IdtLabel = 'NumInvExpDays'
        DataFieldName = 'Customer.NumInvExpDays'
        ReportWidth = 10
      end
      item
        Name = 'TxtCompanyType'
        DataType = pftString
        RangeLength = 0
        IdtLabel = 'TxtCompanyType'
        DataFieldName = 'Customer.TxtCompanyType'
        ReportWidth = 15
      end
      item
        Name = 'CustCommunication'
        DataType = pftString
        RangeLength = 0
        IdtLabel = 'CustCommunication'
        DataFieldName = 'Customer.CustCommunication'
        ReportWidth = 15
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
    Top = 72
  end
end
