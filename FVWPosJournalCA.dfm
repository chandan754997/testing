inherited FrmVWPosJournalCA: TFrmVWPosJournalCA
  Height = 520
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlBtnsTop: TPanel
    inherited LblTicketNumber: TLabel
      Alignment = taRightJustify
      Font.Charset = DEFAULT_CHARSET
    end
  end
  inherited SbxElecJournal: TScrollBox
    Height = 430
    object StBrCdTcktInfo: TStBarCode [0]
      Left = 160
      Top = 272
      Width = 350
      Height = 75
      Color = clWhite
      ParentColor = False
      Visible = False
      AddCheckChar = True
      BarCodeType = bcCode128
      BarColor = clBlack
      BarToSpaceRatio = 1.000000000000000000
      BarWidth = 12.000000000000000000
      BearerBars = False
      Code = '920220608000100100000187'
      Code128Subset = csCodeC
      ShowCode = True
      ShowGuardChars = False
      TallGuardBars = False
    end
  end
  inherited SbrJournal: TScrollBar
    Height = 430
  end
  inherited StsBarDetail: TStatusBar
    Top = 474
  end
  inherited MnuDetPosJournal: TMainMenu
    inherited MniFile: TMenuItem
      object MniInvoices: TMenuItem [2]
        Caption = 'Invoices'
        object CreateInvoice1: TMenuItem
          Action = ActInvCreate
        end
        object Createmanualinvoice1: TMenuItem
          Action = ActInvCreateManual
        end
        object ReprintInvoice1: TMenuItem
          Action = ActInvReprint
        end
        object Addtoticketlist1: TMenuItem
          Action = ActInvAddToList
        end
        object Viewticketlist1: TMenuItem
          Action = ActInvViewList
        end
        object Createinvoicefromticketlist1: TMenuItem
          Action = ActInvCreateMulti
          Enabled = False
        end
      end
    end
  end
  inherited ActLstReport: TActionList
    object ActInvReprint: TAction
      Category = 'File'
      Caption = 'Reprint Invoice'
      Enabled = False
      OnExecute = ActInvExecute
    end
    object ActInvCreate: TAction
      Category = 'File'
      Caption = 'Create Invoice'
      Enabled = False
      OnExecute = ActInvExecute
    end
    object ActInvCreateManual: TAction
      Category = 'File'
      Caption = 'Create manual invoice'
      Enabled = False
      OnExecute = ActInvCreateManualExecute
    end
    object ActInvCreateMulti: TAction
      Category = 'File'
      Caption = 'Create invoice from ticket list'
      OnExecute = ActInvCreateMultiExecute
    end
    object ActInvAddToList: TAction
      Category = 'File'
      Caption = 'Add to ticket list'
      Enabled = False
      OnExecute = ActInvAddToListExecute
    end
    object ActInvViewList: TAction
      Category = 'File'
      Caption = 'View ticket list'
      Enabled = False
      OnExecute = ActInvViewListExecute
    end
  end
  object SvcTskLstCustomer: TSvcListTask
    TaskName = 'ListCustomer'
    LaunchTasks = <
      item
        TaskName = 'DetailCustomer'
        PropertiesPassed.Strings = (
          'SelectedJob=CodJob'
          'StrLstIdtValues'
          'StrLstFieldValues=StrLstRelatedInfo'
          'TxtTaskName=TxtTaskNameMRU')
        PropertiesReturned.Strings = (
          'StrLstIdtValues'
          'FlgRowModified=FlgDBApplied')
      end>
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
    Enabled = True
    AfterExecute = SvcTskLstCustomerAfterExecute
    OnCreateExecutor = SvcTskLstCustomerCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Sequences = <
      item
        Name = 'IdtCustomer'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '2147483647'
        RangeLength = 10
        RangePicture = '9999999999'
        DataFieldRange = 'Customer.IdtCustomer'
        Title = 'Customer number'
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
        RangeOptions = [rioConvertToKeyStr]
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
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'Address.TxtFirstName'
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
        Title = 'Address'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'Address')
        ParamValueSequence = 'Address.TxtStreet'
      end
      item
        Name = 'TxtCommunity'
        DataType = pftString
        RangeLength = 30
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'Municipality.TxtName'
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
        Name = 'TxtNumVAT'
        DataType = pftString
        RangeLength = 16
        RangeOptions = [rioConvertToKeyStr]
        DataFieldRange = 'Customer.TxtNumVAT'
        Title = 'VAT number'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtNumVAT')
        ParamValueSequence = 'Customer.TxtNumVat'
      end>
    ListName = 'Customer'
    IdtFields.Strings = (
      'IdtCustomer'
      'CodCreator')
    HiddenFields.Strings = (
      'CodCreator'
      'TxtPublName')
    MRUMax = 10
    MRUFields.Strings = (
      'IdtCustomer'
      'TxtPublName')
    LookupSequence = 0
    DetailTask = 'DetailCustomer'
    ShowRecordCount = False
    Left = 348
    Top = 136
  end
  object SvcTskDetCustomer: TSvcFormTask
    TaskName = 'DetailCustomer'
    Enabled = True
    OnCreateExecutor = SvcTskDetCustomerCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 346
    Top = 86
  end
  object SvcTskDetDepartment: TSvcFormTask
    TaskName = 'AskDepartment'
    Enabled = True
    AfterExecute = SvcTskDetDepartmentAfterExecute
    OnCreateExecutor = SvcTskDetDepartmentCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 354
    Top = 198
  end
  object SvcTskDetManInvoice: TSvcFormTask
    TaskName = 'DetManInvoice'
    LaunchTasks = <
      item
        TaskName = 'DetManInvoiceArticle'
        PropertiesPassed.Strings = (
          'ObjTransaction'
          'CodJob')
        PropertiesReturned.Strings = (
          'ObjTransaction')
      end
      item
        TaskName = 'DetManInvoiceComment'
        PropertiesPassed.Strings = (
          'ObjTransaction'
          'FlgFiscalInfo')
        PropertiesReturned.Strings = (
          'ObjTransaction'
          'CodJob')
      end
      item
        TaskName = 'DetManInvoicePayment'
        PropertiesPassed.Strings = (
          'LstPaymethodes=LstPaymethodes'
          'LstPrevPaymethodes=LstPrevPaymethodes'
          'NumTotal=NumTotal')
        PropertiesReturned.Strings = (
          'LstPaymethodes=LstPaymethodes')
      end
      item
        TaskName = 'ListArticle'
        PropertiesPassed.Strings = (
          'StrLstIdtValues=StrLstIdtValues')
        PropertiesReturned.Strings = (
          'StrLstIdtValues=StrLstIdtValues')
      end
      item
        TaskName = 'ListCustomer'
        PropertiesPassed.Strings = (
          'StrLstIdtValues=StrLstIdtValues')
        PropertiesReturned.Strings = (
          'StrLstIdtValues=StrLstIdtValues')
      end
      item
        TaskName = 'DetManInvoiceTicketInfo'
      end
      item
        TaskName = 'AskDepartment'
        PropertiesReturned.Strings = (
          'IdtDepartment')
      end>
    Enabled = True
    OnCreateExecutor = SvcTskDetManInvoiceCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 504
    Top = 80
  end
  object SvcTskLstClassification: TSvcListTask
    TaskName = 'ListClassification'
    Enabled = True
    OnCreate = SvcTskLstCreate
    BeforeExecute = SvcTskLstClassificationBeforeExecute
    OnCreateExecutor = SvcTskLstClassificationCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Sequences = <
      item
        Name = 'IdtClassification'
        DataType = pftString
        RangeLength = 14
        Title = 'Classification Identification'
        Caption = 'Identification'
        DataSet = DmdFpnClassification.SprLstClassification
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtClassification')
        ParamValueSequence = 'IdtClassification'
      end
      item
        Name = 'TxtPublDescr'
        DataType = pftString
        RangeLength = 40
        Title = 'Description'
        DataSet = DmdFpnClassification.SprLstClassification
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtPublDescr')
        ParamValueSequence = 'TxtSrcPubl'
      end
      item
        Name = 'CodLevel'
        DataType = pftLongInt
        RangeLength = 0
        RangeOptions = [rioRangeList]
        PrmRangeItems = 'Classification.CodLevel'
        Title = 'Level'
        DataSet = DmdFpnClassification.SprLstClassification
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'CodLevelAsTxtShort')
        ParamValueSequence = 'CodLevel'
      end>
    ListName = 'Classification'
    IdtFields.Strings = (
      'IdtClassification')
    HiddenFields.Strings = (
      'CodType'
      'CodLevel')
    MRUMax = 10
    MRUFields.Strings = (
      'IdtClassification'
      'TxtPublDescr')
    LookupSequence = 0
    RefreshOptions = [rloAfterChange, rloMsgAfterChange, rloMsgYes, rloMsgNo, rloMsgCancel, rloMsgIgnore]
    ShowRecordCount = False
    Left = 504
    Top = 136
  end
  object SvcTskLstArticle: TSvcListTask
    TaskName = 'ListArticle'
    Enabled = True
    OnCreate = SvcTskLstCreate
    OnCreateExecutor = SvcTskLstArticleCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Sequences = <
      item
        Name = 'IdtArticle'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'IdtArticle'
        Title = 'Article number'
        DataSet = DmdFpnArticle.SprLstArticlePLU
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
        RangeOptions = [rioConvertToKeyStr]
        Title = 'Description'
        DataSet = DmdFpnArticle.SprLstArticlePLU
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
        DataSet = DmdFpnArticle.SprLstArticlePLU
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
        DataSet = DmdFpnArticle.SprLstArticlePLU
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'IdtClassification')
        ParamValueSequence = 'IdtClassification'
      end>
    ListName = 'Article'
    IdtFields.Strings = (
      'IdtArticle')
    MRUMax = 10
    MRUFields.Strings = (
      'IdtArticle'
      'TxtPublDescr')
    LookupSequence = 0
    RefreshOptions = [rloAfterChange, rloAfterExecTask, rloMsgAfterChange, rloMsgYes, rloMsgNo, rloMsgCancel, rloMsgIgnore]
    ShowRecordCount = False
    Left = 504
    Top = 192
  end
  object SvcTskDetManInvoiceArticle: TSvcFormTask
    TaskName = 'DetManInvoiceArticle'
    LaunchTasks = <
      item
        TaskName = 'ListClassification'
        PropertiesPassed.Strings = (
          'StrLstIdtValues=StrLstIdtValues')
        PropertiesReturned.Strings = (
          'StrLstIdtValues=StrLstIdtValues')
      end>
    Enabled = True
    OnCreateExecutor = SvcTskDetManInvoiceArticleCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 504
    Top = 248
  end
  object SvcTskDetManInvoiceComment: TSvcFormTask
    TaskName = 'DetManInvoiceComment'
    Enabled = True
    OnCreateExecutor = SvcTskDetManInvoiceCommentCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 504
    Top = 304
  end
  object SvcTskDetManInvoicePayments: TSvcFormTask
    TaskName = 'DetManInvoicePayment'
    Enabled = True
    OnCreateExecutor = SvcTskDetManInvoicePaymentsCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 504
    Top = 360
  end
end
