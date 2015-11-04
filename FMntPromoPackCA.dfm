inherited FrmMntPromoPackCA: TFrmMntPromoPackCA
  Width = 492
  Height = 464
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcTskLstPromoPack: TSvcListTask
    Sequences = <
      item
        Name = 'IdtPromoPack'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '999999999'
        RangeLength = 9
        RangePicture = '999999999'
        Title = 'PromoPack number'
        DataSet = DmdFpnPromoPackCA.SprLstPromoPack
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtPromoPack')
        ParamValueSequence = 'IdtPromoPack'
      end
      item
        Name = 'DatBegin'
        DataType = pftDate
        AllowSubString = False
        RangeLo = '01.01.1800'
        RangeHi = '31.12.3999'
        RangeLength = 0
        Title = 'Initial date'
        DataSet = DmdFpnPromoPackCA.SprLstPromoPack
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'DatBeginAsDate')
        ParamValueSequence = 'Datbegin'
      end
      item
        Name = 'TxtPublDescr'
        DataType = pftString
        RangeLength = 40
        Title = 'Description'
        DataSet = DmdFpnPromoPackCA.SprLstPromoPack
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'TxtPublDescr')
        ParamValueSequence = 'TxtSrcPubl'
        BehaveAsSprLst = False
      end>
    HiddenFields.Strings = (
      'IdtClassification'
      'CodTypePeriod'
      'CodStateId')
  end
  inherited SvcTskDetPromoPack: TSvcFormTask
    LaunchTasks = <
      item
        TaskName = 'ListClassificationForPromoPackTO'
        PropertiesPassed.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'TxtIdentForSel=TxtSelectMaster')
        PropertiesReturned.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'StrLstRelatedInfo=StrLstFieldValues')
      end
      item
        TaskName = 'ListClassificationForPromoPackInf'
        PropertiesPassed.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'TxtIdentForSel=TxtSelectMaster')
        PropertiesReturned.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'StrLstRelatedInfo=StrLstFieldValues')
      end
      item
        TaskName = 'ListClassificationForPromoPackTOSub'
        PropertiesPassed.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'TxtIdentForSel=TxtSelectMaster')
        PropertiesReturned.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'StrLstRelatedInfo=StrLstFieldValues')
      end
      item
        TaskName = 'ListClassificationForPromoPackTODep'
        PropertiesPassed.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'TxtIdentForSel=TxtSelectMaster')
        PropertiesReturned.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'StrLstRelatedInfo=StrLstFieldValues')
      end
      item
        TaskName = 'ListCouponForPromoPack'
        PropertiesPassed.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'TxtIdentForSel=TxtSelectMaster')
        PropertiesReturned.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'StrLstRelatedInfo=StrLstFieldValues')
      end
      item
        TaskName = 'ListArticlePromoConnect'
        PropertiesPassed.Strings = (
          'TxtIdentForSel=TxtSelectMaster'
          'IdtPromoConnect'
          'FlgAllowPromoConnect')
      end
      item
        TaskName = 'ListClassificationPromoConnect'
        PropertiesPassed.Strings = (
          'TxtIdentForSel=TxtSelectMaster'
          'IdtPromoConnect'
          'FlgAllowPromoConnect')
      end
      item
        TaskName = 'PrintPromopackReport'
        PropertiesPassed.Strings = (
          'IdtPromoPack'
          'BarcodePromoPack'
          'TxtDescrPromoPack')
      end>
  end
  object SvcFrmPromopackReport: TSvcFormTask
    TaskName = 'PrintPromopackReport'
    Enabled = True
    OnCreateExecutor = SvcFrmPromopackReportCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 280
    Top = 360
  end
end
