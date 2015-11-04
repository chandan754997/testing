inherited FrmLabelerCA: TFrmLabelerCA
  Height = 231
  PixelsPerInch = 96
  TextHeight = 13
  inherited BtnCustFree: TBitBtn
    Enabled = False
    Visible = False
  end
  inherited SvcTmgLabeler: TSvcTaskManager
    Left = 24
    Top = 16
  end
  inherited SvcTskArtNew: TSvcListTask
    StoredProcApplicText = DmdFpnUtilsCA.SprCnvApplicText
    Sequences = <
      item
        Name = 'DatBeginArtPrice'
        DataType = pftDate
        AllowSubString = False
        RangeLength = 0
        DataFieldRange = 'ArtPrice.DatBegin'
        Title = 'Date new price'
        DataSet = DmdFpnLabeler.SprLstLabArt
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'DatBegin')
        ParamValueSequence = 'DatBegin'
      end
      item
        Name = 'IdtArticle'
        DataType = pftString
        RangeLength = 14
        Title = 'Article number'
        DataSet = DmdFpnLabeler.SprLstLabArt
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtArticle')
        ParamValueSequence = 'IdtArticle'
      end
      item
        Name = 'IdtArtMain'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'Article.IdtArtMain'
        Title = 'Main article number'
        Caption = 'Article number'
        DataSet = DmdFpnLabeler.SprLstLabArt
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtArtMain')
        ParamValueSequence = 'IdtArtMain'
      end
      item
        Name = 'NumPLU'
        DataType = pftString
        RangeLength = 21
        RangeOptions = [rioLeftPaddedZero]
        Title = 'PLU-number'
        DataSet = DmdFpnLabeler.SprLstLabArt
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
        DataFieldRange = 'ArtAssort.IdtClassification'
        Title = 'Classification'
        DataSet = DmdFpnLabeler.SprLstLabArt
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtClassification')
        ParamValueSequence = 'IdtClassification'
      end
      item
        Name = 'TxtPublDescr'
        DataType = pftString
        RangeLength = 40
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'Article.TxtSrcPubl'
        Title = 'Description'
        DataSet = DmdFpnLabeler.SprLstLabArt
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'ArticleTxtPublDescr')
        ParamValueSequence = 'TxtSrcPubl'
      end
      item
        Name = 'IdtShelf'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'ArtShelf.IdtShelf'
        Title = 'Rayon'
        DataSet = DmdFpnLabeler.SprLstLabArt
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ParamValueSequence = 'IdtShelf'
      end>
    IdtFields.Strings = (
      'IdtArtPrice'
      'IdtArticle'
      'IdtLabelerLayout')
    HiddenFields.Strings = (
      'IdtArtPrice'
      'IdtCurrency'
      'CodTaskTarget'
      'CodFlgSend'
      'IdtShelf'
      'IdtLabelerLayout')
    Left = 248
    Top = 16
  end
  inherited SvcTskArtPrc: TSvcListTask
    StoredProcApplicText = DmdFpnUtilsCA.SprCnvApplicText
    Sequences = <
      item
        Name = 'DatBeginArtPrice'
        DataType = pftDate
        AllowSubString = False
        RangeLength = 0
        DataFieldRange = 'ArtPrice.DatBegin'
        Title = 'Date new price'
        DataSet = DmdFpnLabeler.SprLstLabArtPrice
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'DatBegin')
        ParamValueSequence = 'DatBegin'
      end
      item
        Name = 'IdtArticle'
        DataType = pftString
        RangeLength = 14
        Title = 'Article number'
        DataSet = DmdFpnLabeler.SprLstLabArtPrice
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtArticle')
        ParamValueSequence = 'IdtArticle'
      end
      item
        Name = 'IdtArtMain'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'Article.IdtArtMain'
        Title = 'Main article number'
        Caption = 'Article number'
        DataSet = DmdFpnLabeler.SprLstLabArtPrice
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtArtMain')
        ParamValueSequence = 'IdtArtMain'
      end
      item
        Name = 'NumPLU'
        DataType = pftString
        RangeLength = 21
        RangeOptions = [rioLeftPaddedZero]
        Title = 'PLU-number'
        DataSet = DmdFpnLabeler.SprLstLabArtPrice
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
        DataFieldRange = 'ArtAssort.IdtClassification'
        Title = 'Classification'
        DataSet = DmdFpnLabeler.SprLstLabArtPrice
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtClassification')
        ParamValueSequence = 'IdtClassification'
      end
      item
        Name = 'TxtPublDescr'
        DataType = pftString
        RangeLength = 40
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'Article.TxtSrcPubl'
        Title = 'Description'
        DataSet = DmdFpnLabeler.SprLstLabArtPrice
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'ArticleTxtPublDescr')
        ParamValueSequence = 'TxtSrcPubl'
      end
      item
        Name = 'IdtShelf'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'ArtShelf.IdtShelf'
        Title = 'Rayon'
        DataSet = DmdFpnLabeler.SprLstLabArtPrice
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ParamValueSequence = 'IdtShelf'
      end>
    IdtFields.Strings = (
      'IdtArtPrice'
      'IdtArticle'
      'IdtLabelerLayout')
    HiddenFields.Strings = (
      'IdtArtPrice'
      'IdtCurrency'
      'CodTaskTarget'
      'CodFlgSend'
      'IdtShelf'
      'IdtLabelerLayout')
    Left = 248
    Top = 64
  end
  inherited SvcTskCampaign: TSvcListTask
    StoredProcApplicText = DmdFpnUtilsCA.SprCnvApplicText
    Sequences = <
      item
        Name = 'DatBeginArtPrice'
        DataType = pftDate
        AllowSubString = False
        RangeLength = 0
        DataFieldRange = 'ArtPrice.DatBegin'
        Title = 'Date new price'
        DataSet = DmdFpnLabeler.SprLstLabArtPrcCamp
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'DatBegin')
        ParamValueSequence = 'DatBegin'
      end
      item
        Name = 'IdtArticle'
        DataType = pftString
        RangeLength = 14
        Title = 'Article number'
        DataSet = DmdFpnLabeler.SprLstLabArtPrcCamp
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtArticle')
        ParamValueSequence = 'IdtArticle'
      end
      item
        Name = 'IdtArtMain'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'Article.IdtArtMain'
        Title = 'Main article number'
        Caption = 'Article number'
        DataSet = DmdFpnLabeler.SprLstLabArtPrcCamp
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtArtMain')
        ParamValueSequence = 'IdtArtMain'
      end
      item
        Name = 'NumPLU'
        DataType = pftString
        RangeLength = 21
        RangeOptions = [rioLeftPaddedZero]
        Title = 'PLU-number'
        DataSet = DmdFpnLabeler.SprLstLabArtPrcCamp
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
        DataFieldRange = 'ArtAssort.IdtClassification'
        Title = 'Classification'
        DataSet = DmdFpnLabeler.SprLstLabArtPrcCamp
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtClassification')
        ParamValueSequence = 'IdtClassification'
      end
      item
        Name = 'TxtPublDescr'
        DataType = pftString
        RangeLength = 40
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'Article.TxtSrcPubl'
        Title = 'Description'
        DataSet = DmdFpnLabeler.SprLstLabArtPrcCamp
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'ArticleTxtPublDescr')
        ParamValueSequence = 'TxtSrcPubl'
      end
      item
        Name = 'IdtCampaign'
        DataType = pftString
        RangeLength = 10
        DataFieldRange = 'ArtPrice.IdtCampaign'
        Title = 'Campaign identification'
        Caption = 'Campaign '
        DataSet = DmdFpnLabeler.SprLstLabArtPrcCamp
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtCampaign')
        ParamValueSequence = 'IdtCampaign'
      end
      item
        Name = 'IdtShelf'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'ArtShelf.IdtShelf'
        Title = 'Rayon'
        DataSet = DmdFpnLabeler.SprLstLabArtPrcCamp
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ParamValueSequence = 'IdtShelf'
      end>
    IdtFields.Strings = (
      'IdtArtPrice'
      'IdtArticle'
      'IdtLabelerLayout')
    HiddenFields.Strings = (
      'IdtArtPrice'
      'IdtCurrency'
      'CodTaskTarget'
      'CodFlgSend'
      'IdtShelf'
      'IdtLabelerLayout')
    Left = 248
    Top = 112
  end
  inherited SvcTskArtFree: TSvcListTask
    StoredProcApplicText = DmdFpnUtilsCA.SprCnvApplicText
    Sequences = <
      item
        Name = 'DatBeginArtPrice'
        DataType = pftDate
        AllowSubString = False
        RangeLength = 0
        DataFieldRange = 'ArtPrice.DatBegin'
        Title = 'Date new price'
        DataSet = DmdFpnLabeler.SprLstLabArtFree
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'DatBegin')
        ParamValueSequence = 'DatBegin'
      end
      item
        Name = 'IdtArticle'
        DataType = pftString
        RangeLength = 14
        Title = 'Article number'
        DataSet = DmdFpnLabeler.SprLstLabArtFree
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtArticle')
        ParamValueSequence = 'IdtArticle'
      end
      item
        Name = 'IdtArtmain'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'Article.IdtArtMain'
        Title = 'Main article number'
        Caption = 'Article number'
        DataSet = DmdFpnLabeler.SprLstLabArtFree
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtArtMain')
        ParamValueSequence = 'IdtArtMain'
      end
      item
        Name = 'NumPLU'
        DataType = pftString
        RangeLength = 21
        RangeOptions = [rioLeftPaddedZero]
        Title = 'PLU-number'
        DataSet = DmdFpnLabeler.SprLstLabArtFree
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
        DataFieldRange = 'ArtAssort.IdtClassification'
        Title = 'Classification'
        DataSet = DmdFpnLabeler.SprLstLabArtFree
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtClassification')
        ParamValueSequence = 'IdtClassification'
      end
      item
        Name = 'TxtPublDescr'
        DataType = pftString
        RangeLength = 40
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'Article.TxtSrcPubl'
        Title = 'Description'
        DataSet = DmdFpnLabeler.SprLstLabArtFree
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'ArticleTxtPublDescr')
        ParamValueSequence = 'TxtSrcPubl'
      end
      item
        Name = 'IdtShelf'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'ArtShelf.IdtShelf'
        Title = 'Rayon'
        DataSet = DmdFpnLabeler.SprLstLabArtFree
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ParamValueSequence = 'IdtShelf'
      end>
    IdtFields.Strings = (
      'IdtArtPrice'
      'IdtArticle'
      'IdtLabelerLayout')
    HiddenFields.Strings = (
      'IdtArtPrice'
      'IdtCurrency'
      'IdtShelf'
      'IdtLabelerLayout')
    Left = 248
    Top = 160
  end
  inherited SvcTskCustFree: TSvcListTask
    Left = 248
    Top = 208
  end
end
