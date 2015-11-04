inherited FrmMntArticleCA: TFrmMntArticleCA
  Left = 211
  Top = 116
  Caption = 'Maintenance Article'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcTskLstArticle: TSvcListTask
    Sequences = <
      item
        Name = 'IdtArticle'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'IdtArticle'
        Title = 'Article number'
        DataSet = DmdFpnArticleCA.SprLstArticlePLU
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtArticle')
        ParamValueSequence = 'IdtArticle'
      end
      item
        Name = 'TxtPublDescr'
        DataType = pftString
        RangeLength = 40
        BehaveAsSprLst = False
        Title = 'Description'
        DataSet = DmdFpnArticleCA.SprLstArticlePLU
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'TxtPublDescr')
        ParamValueSequence = 'TxtSrcPubl'
      end
      item
        Name = 'NumPLU'
        DataType = pftString
        RangeLength = 21
        RangeOptions = [rioLeftPaddedZero]
        DataFieldRange = 'NumPLU'
        Title = 'PLU-number'
        DataSet = DmdFpnArticleCA.SprLstArticlePLU
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'NumPLU')
        ParamValueSequence = 'NumPLU'
      end
      item
        Name = 'IdtClassification'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'IdtClassification'
        Title = 'Classification'
        DataSet = DmdFpnArticleCA.SprLstArticlePLU
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtClassification')
        ParamValueSequence = 'IdtClassification'
      end
      item
        Name = 'IdtSupplierDep'
        DataType = pftString
        AllowSubString = False
        RangeLength = 0
        DataFieldRange = 'IdtSupplierDep'
        Title = 'Supplier department'
        Caption = 'Suppl. department'
        DataSet = DmdFpnArticleCA.SprLstArticle
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtSupplierDep')
        ParamValueSequence = 'IdtSupplierDep'
      end
      item
        Name = 'IdtOrderBook'
        DataType = pftString
        RangeLength = 4
        DataFieldRange = 'IdtOrderBook'
        Title = 'Order book'
        DataSet = DmdFpnArticleCA.SprLstArticlePLU
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtOrderbook'
          'TxtOrderBookLine')
        ParamValueSequence = 'IdtOrderBook'
      end>
    HiddenFields.Strings = (
      'CodBlocked')
  end
  inherited SvcTskLstArtMainForArticle: TSvcListTask
    Sequences = <
      item
        Name = 'IdtArticle'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'IdtArticle'
        Title = 'Article number'
        DataSet = DmdFpnArticleCA.SprLstArticlePLU
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubString'
        ColorFields.Strings = (
          'IdtArticle')
        ParamValueSequence = 'IdtArticle'
      end
      item
        Name = 'TxtPublDescr'
        DataType = pftString
        RangeLength = 40
        BehaveAsSprLst = False
        Title = 'Description'
        DataSet = DmdFpnArticleCA.SprLstArticlePLU
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubString'
        ColorFields.Strings = (
          'TxtPublDescr')
        ParamValueSequence = 'TxtSrcPubl'
      end
      item
        Name = 'NumPLU'
        DataType = pftString
        RangeLength = 21
        RangeOptions = [rioLeftPaddedZero]
        DataFieldRange = 'NumPLU'
        Title = 'PLU-number'
        DataSet = DmdFpnArticleCA.SprLstArticlePLU
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubString'
        ColorFields.Strings = (
          'NumPLU'
          '')
        ParamValueSequence = 'NumPLU'
      end
      item
        Name = 'IdtClassification'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'IdtClassification'
        Title = 'Classification'
        DataSet = DmdFpnArticleCA.SprLstArticlePLU
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubString'
        ColorFields.Strings = (
          'IdtClassification')
        ParamValueSequence = 'IdtClassification'
      end
      item
        Name = 'IdtOrderBook'
        DataType = pftString
        RangeLength = 4
        DataFieldRange = 'IdtOrderBook'
        Title = 'Order book'
        DataSet = DmdFpnArticleCA.SprLstArticlePLU
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubString'
        ColorFields.Strings = (
          'IdtOrderBook')
        ParamValueSequence = 'IdtOrderBook'
      end>
  end
  inherited SvcTskLstCustomerForArtPrice: TSvcListTask
    Sequences = <
      item
        Name = 'IdtCustomer'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '999999999'
        RangeLength = 9
        RangePicture = '999999999'
        DataFieldRange = 'Customer.IdtCustomer'
        Title = 'Customer'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtCustomer')
        ParamValueSequence = 'Customer.IdtCustomer'
      end
      item
        Name = 'TxtPublName'
        DataType = pftString
        RangeLength = 30
        BehaveAsSprLst = False
        DataFieldRange = 'Address.TxtName'
        Title = 'Name'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtName')
        ParamValueSequence = 'Address.TxtName'
      end
      item
        Name = 'TxtFirstName'
        DataType = pftString
        RangeLength = 30
        Title = 'FirstName'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtFirstName')
        ParamValueSequence = 'Address.TxtFirstName'
      end
      item
        Name = 'TxtStreet'
        DataType = pftString
        RangeLength = 50
        DataFieldRange = 'Address.TxtStreet'
        Title = 'Address'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'Address')
        ParamValueSequence = 'address.TxtStreet'
      end
      item
        Name = 'TxtCommunity'
        DataType = pftString
        RangeLength = 30
        Title = 'Community'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'Community')
        ParamValueSequence = 'Municipality.TxtName'
      end
      item
        Name = 'TxtNumVat'
        DataType = pftString
        RangeLength = 16
        DataFieldRange = 'Customer.TxtNumVat'
        Title = 'VAT number'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtNumVat')
        ParamValueSequence = 'Customer.TxtNumVat'
      end>
    HiddenFields.Strings = (
      'CodCreator'
      'TxtPublName')
  end
  inherited SvcTskLstOrderBookForArticle: TSvcListTask
    Sequences = <
      item
        Name = 'IdtOrderBook'
        DataType = pftString
        RangeLength = 0
        DataFieldRange = 'IdtOrderBook'
        Title = 'Order book'
        DataSet = DmdFpnArticleCA.SprLstOrderBook
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtOrderBook')
        ParamValueSequence = 'IdtOrderBook'
      end
      item
        Name = 'TxtPublDescr'
        DataType = pftString
        RangeLength = 30
        BehaveAsSprLst = False
        Title = 'Description'
        DataSet = DmdFpnArticleCA.SprLstOrderBook
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtPublDescr')
        ParamValueSequence = 'TxtSrcPubl'
      end>
  end
  inherited SvcTskLstArtCollArticleForArticle: TSvcListTask
    Sequences = <
      item
        Name = 'IdtArticle'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'Article.IdtArticle'
        Title = 'Article number'
        DataSet = DmdFpnArticleCA.SprLstArticlePLU
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtArticle')
        ParamValueSequence = 'Article.IdtArticle'
      end
      item
        Name = 'TxtPublDescr'
        DataType = pftString
        RangeLength = 40
        BehaveAsSprLst = False
        Title = 'Description'
        DataSet = DmdFpnArticleCA.SprLstArticlePLU
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtPublDescr')
        ParamValueSequence = 'TxtSrcPubl'
      end
      item
        Name = 'NumPLU'
        DataType = pftString
        RangeLength = 21
        RangeOptions = [rioLeftPaddedZero]
        Title = 'PLU-number'
        DataSet = DmdFpnArticleCA.SprLstArticlePLU
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'ArtPLU.NumPLU')
        ParamValueSequence = 'ArtPLU.TxtSrcNumPLU'
      end
      item
        Name = 'IdtClassification'
        DataType = pftString
        RangeLength = 14
        Title = 'Classification'
        DataSet = DmdFpnArticleCA.SprLstArticlePLU
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'ArtAssort.IdtClassification')
        ParamValueSequence = 'ArtAssort.IdtClassification'
      end
      item
        Name = 'IdtOrderBook'
        DataType = pftString
        RangeLength = 4
        DataFieldRange = 'IdtOrderBook'
        Title = 'Order book'
        DataSet = DmdFpnArticleCA.SprLstArticle
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtOrderBook'
          'TxtOrderBookLine')
        ParamValueSequence = 
          'OrderBookLine.IdtOrderBook; OrderBookLine.TxtOrderBookLine; Orde' +
          'rBookLine.IdtArticle'
      end>
  end
  inherited SvcTskLstArtCollForArticle: TSvcListTask
    Sequences = <
      item
        Name = 'IdtArtColl'
        DataType = pftString
        RangeLength = 20
        Title = 'Collection leader'
        DataSet = DmdFpnArticleCA.SprLstArtColl
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtArtColl')
        ParamValueSequence = 'IdtArtColl'
      end
      item
        Name = 'IdtArticle'
        DataType = pftString
        RangeLength = 14
        Title = 'Article number'
        DataSet = DmdFpnArticleCA.SprLstArtColl
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtArticle')
        ParamValueSequence = 'IdtArticle'
      end
      item
        Name = 'ArticleTxtPublDescr'
        DataType = pftString
        RangeLength = 40
        BehaveAsSprLst = False
        Title = 'Description'
        DataSet = DmdFpnArticleCA.SprLstArtColl
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'TxtPublDescrArticle')
        ParamValueSequence = 'TxtPublDescr'
      end
      item
        Name = 'CodType'
        DataType = pftLongInt
        RangeLength = 0
        RangeOptions = [rioRangeList]
        DataFieldRange = 'TYPE'
        Title = 'Type collection'
        DataSet = DmdFpnArticleCA.SprLstArtColl
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'CodTypeAsTxtShort')
        ParamValueSequence = 'CodType'
      end>
  end
end
