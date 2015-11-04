inherited FrmChlArticleCA: TFrmChlArticleCA
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcTskChlArticle: TSvcRptCfgChoiceTask
    ReportFields = <
      item
        Name = 'IdtArticle'
        DataType = pftString
        RangeLength = 14
        IdtLabel = 'IdtArticle'
        DataFieldName = 'Article.IdtArticle'
        Title = 'IdtArticle'
        ReportWidth = 14
      end
      item
        Name = 'ArticleTxtPublDescr'
        DataType = pftString
        RangeLength = 40
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'Article.TxtSrcPubl'
        IdtLabel = 'TxtPublDescr'
        DataFieldName = 'ArticleTxtPublDescr=Article.TxtPublDescr'
        Title = 'TxtPublDescr'
        ReportWidth = 40
      end
      item
        Name = 'FlgDeliverable'
        DataType = pftBoolean
        AllowSubString = False
        RangeLength = 5
        RangePicture = '9'
        IdtLabel = 'FlgDeliverable'
        DataFieldName = 'ArtAssort.FlgDeliverable'
        Title = 'FlgDeliverable'
        ReportWidth = 5
      end
      item
        Name = 'NumPLU'
        DataType = pftString
        RangeLength = 21
        RangeOptions = [rioLeftPaddedZero]
        DataFieldRange = 'ArtPLU.TxtSrcNumPLU'
        IdtLabel = 'NumPLU'
        DataFieldName = 'ArtPLU.NumPLU'
        Title = 'NumPLU'
        Alignment = taRightJustify
        ReportWidth = 22
      end
      item
        Name = 'IdtClassification'
        DataType = pftString
        RangeLength = 14
        IdtLabel = 'LnkClassification'
        DataFieldName = 'ArtAssort.IdtClassification'
        Title = 'LnkClassification'
        ReportWidth = 14
      end
      item
        Name = 'ClassificationTxtPublDescr'
        DataType = pftString
        RangeLength = 30
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'Classification.TxtSrcPubl'
        IdtLabel = 'TxtPublDescrClassification'
        DataFieldName = 'ClassificationTxtPublDescr=Classification.TxtPublDescr'
        Title = 'TxtPublDescrClassification'
        ReportWidth = 30
      end
      item
        Name = 'IdtOrderBook'
        DataType = pftString
        RangeLength = 6
        IdtLabel = 'IdtOrderBook'
        DataFieldName = 'OrderBookLine.IdtOrderBook'
        Title = 'IdtOrderBook'
        ReportWidth = 6
      end
      item
        Name = 'TxtOrderBookLine'
        DataType = pftString
        RangeLength = 10
        IdtLabel = 'TxtOrderBookLine'
        DataFieldName = 'OrderBookLine.TxtOrderBookLine'
        Title = 'TxtOrderBookLine'
        ReportWidth = 10
      end
      item
        Name = 'PrcPurch'
        DataType = pftLongInt
        AllowSubString = False
        RangeLength = 0
        IdtLabel = 'PrcPurch'
        DataFieldName = 'ArtPricePurch.PrcPurch'
        Title = 'Purchase price'
        Alignment = taRightJustify
        ReportWidth = 13
      end
      item
        Name = 'PrcPurchCamp'
        DataType = pftLongInt
        AllowSubString = False
        RangeLength = 0
        IdtLabel = 'PrcPurchCamp'
        DataFieldName = 'ArtPricePurchCamp.PrcPurchCamp'
        Title = 'Purchase Price Campaign'
        PrintTitle = 'Purch.Price Campaign'
        Alignment = taRightJustify
        ReportWidth = 13
      end
      item
        Name = 'PrcSale'
        DataType = pftLongInt
        AllowSubString = False
        RangeLength = 0
        IdtLabel = 'PrcSale'
        DataFieldName = 'ArtPriceSale.PrcSale'
        Title = 'Selling-price'
        Alignment = taRightJustify
        ReportWidth = 13
      end
      item
        Name = 'PrcCamp'
        DataType = pftLongInt
        AllowSubString = False
        RangeLength = 0
        IdtLabel = 'PrcCamp'
        DataFieldName = 'ArtPriceCamp.PrcCamp'
        Title = 'Campaign price'
        Alignment = taRightJustify
        ReportWidth = 13
      end
      item
        Name = 'IdtArtMake'
        DataType = pftString
        RangeLength = 10
        IdtLabel = 'LnkArtMake'
        DataFieldName = 'ArtMake.IdtArtMake'
        Title = 'LnkArtMake'
        ReportWidth = 10
      end
      item
        Name = 'ArtMakeTxtName'
        DataType = pftString
        RangeLength = 30
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'ArtMake.TxtSrcName'
        DataFieldName = 'ArtMake.TxtName'
        Title = 'Name manufacturer'
        ReportWidth = 30
      end
      item
        Name = 'PctPersDisc'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '100'
        RangeLength = 3
        RangePicture = '999'
        IdtLabel = 'PctPersDisc'
        DataFieldName = 'PersDiscount.PctPersDisc'
        Title = 'PctPersDisc'
        Alignment = taRightJustify
        ReportWidth = 6
      end
      item
        Name = 'DatOutAssort'
        DataType = pftDate
        RangeLo = '01.01.1800'
        RangeHi = '31.12.3999'
        AllowSubString = False
        RangeLength = 10
        IdtLabel = 'DatOutAssort'
        DataFieldName = 'Article.DatOutAssort'
        Title = 'DatOutAssort'
        Alignment = taRightJustify
        ReportWidth = 12
      end
      item
        Name = 'IdtArtMain'
        DataType = pftString
        RangeLength = 14
        IdtLabel = 'IdtArtMain'
        DataFieldName = 'Article.IdtArtMain'
        Title = 'IdtArtMain'
        ReportWidth = 14
      end
      item
        Name = 'CodPrcStop'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '99999'
        RangeLength = 5
        RangePicture = '99999'
        RangeOptions = [rioRangeList]
        SprRangeItems = DmdFpnUtils.SprCnvCodes
        PrmRangeItems = 'Article.CodPrcStop'
        IdtLabel = 'CodPrcStop'
        DataFieldName = 'Article.CodPrcStop'
        Title = 'CodPrcStop'
        ReportWidth = 10
      end
      item
        Name = 'CodSalesUnit'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '99999'
        RangeLength = 5
        RangePicture = '99999'
        RangeOptions = [rioRangeList]
        SprRangeItems = DmdFpnUtils.SprCnvCodes
        PrmRangeItems = 'Article.CodSalesUnit'
        IdtLabel = 'CodSalesUnit'
        DataFieldName = 'Article.CodSalesUnit'
        Title = 'CodSalesUnit'
        ReportWidth = 10
      end
      item
        Name = 'QtyIndivCons'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '2147483647'
        RangeLength = 10
        RangePicture = '9999999999'
        IdtLabel = 'QtyIndivCons'
        DataFieldName = 'Article.QtyIndivCons'
        Title = 'QtyIndivCons'
        Alignment = taRightJustify
        ReportWidth = 10
      end
      item
        Name = 'QtyIndivPurch'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '2147483647'
        RangeLength = 10
        RangePicture = '9999999999'
        IdtLabel = 'QtyIndivPurch'
        DataFieldName = 'Article.QtyIndivPurch'
        Title = 'QtyIndivPurch'
        Alignment = taRightJustify
        ReportWidth = 10
      end
      item
        Name = 'CodContents'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '99999'
        RangeLength = 5
        RangePicture = '99999'
        RangeOptions = [rioRangeList]
        SprRangeItems = DmdFpnUtils.SprCnvCodes
        PrmRangeItems = 'Article.CodContents'
        IdtLabel = 'CodContents'
        DataFieldName = 'Article.CodContents'
        Title = 'CodContents'
        ReportWidth = 10
      end
      item
        Name = 'QtyContents'
        DataType = pftLongInt
        RangeLength = 11
        RangePicture = 'iiiiiiiiiii'
        IdtLabel = 'QtyContents'
        DataFieldName = 'Article.QtyContents'
        Title = 'QtyContents'
        Alignment = taRightJustify
        ReportWidth = 13
      end
      item
        Name = 'FlgFood'
        DataType = pftBoolean
        AllowSubString = False
        RangeLength = 5
        RangePicture = '9'
        IdtLabel = 'FlgFood'
        DataFieldName = 'Article.FlgFood'
        Title = 'FlgFood'
        ReportWidth = 5
      end
      item
        Name = 'FlgActive'
        DataType = pftBoolean
        AllowSubString = False
        RangeLength = 5
        RangePicture = '9'
        IdtLabel = 'FlgActive'
        DataFieldName = 'Article.FlgActive'
        Title = 'FlgActive'
        ReportWidth = 5
      end
      item
        Name = 'FlgLabel'
        DataType = pftBoolean
        AllowSubString = False
        RangeLength = 5
        RangePicture = '9'
        IdtLabel = 'FlgLabel'
        DataFieldName = 'Article.FlgLabel'
        Title = 'FlgLabel'
        ReportWidth = 5
      end
      item
        Name = 'FlgAd'
        DataType = pftBoolean
        AllowSubString = False
        RangeLength = 5
        RangePicture = '9'
        IdtLabel = 'FlgAd'
        DataFieldName = 'Article.FlgAd'
        Title = 'FlgAd'
        ReportWidth = 5
      end
      item
        Name = 'PctVAT'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '100'
        RangeLength = 3
        RangePicture = '999'
        IdtLabel = 'PctVAT'
        DataFieldName = 'VATCode.PctVAT'
        Title = 'PctVAT'
        Alignment = taRightJustify
        ReportWidth = 6
      end
      item
        Name = 'IdtVATCode'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '999999999'
        RangeLength = 9
        RangePicture = '999999999'
        IdtLabel = 'LnkVATCode'
        DataFieldName = 'ArtAssort.IdtVATCode'
        Title = 'LnkVATCode'
        Alignment = taRightJustify
        ReportWidth = 10
      end
      item
        Name = 'IdtSupplier'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '999999999'
        RangeLength = 9
        RangePicture = '999999999'
        IdtLabel = 'LnkSupplier'
        DataFieldName = 'ArtSupplier.IdtSupplier'
        Title = 'LnkSupplier'
        Alignment = taRightJustify
        ReportWidth = 10
      end
      item
        Name = 'SupplierTxtPublName'
        DataType = pftString
        RangeLength = 30
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'Supplier.TxtSrcPubl'
        IdtLabel = 'TxtPublNameSupplier'
        DataFieldName = 'Supplier.TxtPublName'
        Title = 'TxtPublNameSupplier'
        ReportWidth = 30
      end
      item
        Name = 'DatCreate'
        DataType = pftDate
        RangeLo = '01.01.1800'
        RangeHi = '31.12.3999'
        AllowSubString = False
        RangeLength = 10
        IdtLabel = 'DatCreate'
        DataFieldName = 'Article.DatCreate'
        Title = 'DatCreate'
        Alignment = taRightJustify
        ReportWidth = 12
      end
      item
        Name = 'DatModify'
        DataType = pftDate
        RangeLo = '01.01.1800'
        RangeHi = '31.12.3999'
        AllowSubString = False
        RangeLength = 10
        IdtLabel = 'DatModify'
        DataFieldName = 'Article.DatModify'
        Title = 'DatModify'
        Alignment = taRightJustify
        ReportWidth = 12
      end
      item
        Name = 'IdtSupplierDep'
        DataType = pftString
        AllowEdit = False
        RangeLength = 0
        IdtLabel = 'IdtSupplierDep'
        DataFieldName = 'IdtSupplierDep'
        ReportWidth = 0
      end
      item
        Name = 'SupplierTxtSupplArtRef'
        DataType = pftString
        RangeLength = 20
        IdtLabel = 'TxtSupplArtRef'
        DataFieldName = 'ArtSupplier.TxtSupplArtRef'
        Title = 'TxtSupplArtRef'
        ReportWidth = 20
      end
      item
        Name = 'SupplierQtyOrdUnit'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '999999999'
        RangeLength = 9
        RangePicture = '999999999'
        DataFieldName = 'ArtSupplier.QtyOrdUnit'
        Title = 'Supplier Order Unit'
        Alignment = taRightJustify
        ReportWidth = 9
      end
      item
        Name = 'SupplierQtyOrdMin'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '999999999'
        RangeLength = 9
        RangePicture = '999999999'
        DataFieldName = 'ArtSupplier.QtyOrdUnit'
        Title = 'Supplier Minimum quantity to order'
        PrintTitle = 'Supplier Min.qty. order'
        Alignment = taRightJustify
        ReportWidth = 9
      end
      item
        Name = 'SupplierQtyIndivPurch'
        DataType = pftLongInt
        RangeLo = '9'
        RangeHi = '999999999'
        RangeLength = 9
        RangePicture = '999999999'
        DataFieldName = 'ArtSupplier.QtyIndivPurch'
        Title = 'Supplier Purchase packing'
        Alignment = taRightJustify
        ReportWidth = 9
      end
      item
        Name = 'IdtDepositArt'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'DepositAssort.IdtContribution'
        IdtLabel = 'LnkDepositArt'
        DataFieldName = 'IdtDepositArt=DepositAssort.IdtContribution'
        Title = 'LnkDepositArt'
        ReportWidth = 14
      end
      item
        Name = 'DepositArtTxtPublDescr'
        DataType = pftString
        RangeLength = 40
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'DepositArt.TxtSrcPubl'
        DataFieldName = 'DepositArtTxtPublDescr=DepositArt.TxtPublDescr'
        Title = 'Description Deposit article'
        ReportWidth = 40
      end
      item
        Name = 'IdtRecycle'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'RecycleAssort.IdtContribution'
        IdtLabel = 'LnkRecycle'
        DataFieldName = 'IdtRecycle=RecycleAssort.IdtContribution'
        Title = 'LnkRecycle'
        ReportWidth = 14
      end
      item
        Name = 'RecycleTxtPublDescr'
        DataType = pftString
        RangeLength = 40
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'Recycle.TxtSrcPubl'
        DataFieldName = 'RecycleTxtPublDescr=Recycle.TxtPublDescr'
        Title = 'Description recycle contribution'
        ReportWidth = 40
      end
      item
        Name = 'RecycleIdtClassification'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'RecycleAssort.IdtClassification'
        DataFieldName = 'RecycleAssortIdtClassification=RecycleAssort.IdtClassification'
        Title = 'Classification recycle'
        ReportWidth = 14
      end
      item
        Name = 'RecycleClassTxtPublDescr'
        DataType = pftString
        RangeLength = 30
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'RecycleClass.TxtSrcDescr'
        DataFieldName = 'RecycleClassTxtPublDescr=RecycleClass.TxtPublDescr'
        Title = 'Description classification recycle'
        ReportWidth = 30
      end>
    ExportFiles = <
      item
        Name = 'TRptExportFiles_0'
        FileDescription = 'CSV (Semicolon delimited)'
        FileMask = '*.cvs'
        DefaultExtension = 'cvs'
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
        FileMask = '*.cvs'
        DefaultExtension = 'cvs'
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
