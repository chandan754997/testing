inherited FrmMntManInvoiceCA: TFrmMntManInvoiceCA
  Left = 322
  Top = 178
  Width = 281
  Height = 397
  Caption = 'Maintenance for Manuel Invoice CA'
  PixelsPerInch = 96
  TextHeight = 13
  object SvcTmgMaintenance: TSvcTaskManager
    MainTask = SvcTskDetManInvoice
    Left = 56
    Top = 32
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
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
    Enabled = True
    OnCreateExecutor = SvcTskDetManInvoiceCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 56
    Top = 88
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
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
    Enabled = True
    OnCreateExecutor = SvcTskDetManInvoiceArticleCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 184
    Top = 88
  end
  object SvcTskDetManInvoiceComment: TSvcFormTask
    TaskName = 'DetManInvoiceComment'
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
    Enabled = True
    OnCreateExecutor = SvcTskDetManInvoiceCommentCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 184
    Top = 144
  end
  object SvcTskDetManInvoicePayments: TSvcFormTask
    TaskName = 'DetManInvoicePayment'
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
    Enabled = True
    OnCreateExecutor = SvcTskDetManInvoicePaymentsCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 184
    Top = 200
  end
  object SvcTskLstArticle: TSvcListTask
    TaskName = 'ListArticle'
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
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
      end>
    ListName = 'Article'
    IdtFields.Strings = (
      'IdtArticle')
    HiddenFields.Strings = (
      'CodBlocked')
    MRUMax = 10
    MRUFields.Strings = (
      'IdtArticle'
      'TxtPublDescr')
    LookupSequence = 0
    RefreshOptions = [rloAfterChange, rloAfterExecTask, rloMsgAfterChange, rloMsgYes, rloMsgNo, rloMsgCancel, rloMsgIgnore]
    ShowRecordCount = False
    Left = 56
    Top = 200
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
    OnCreate = SvcTskLstCreate
    OnCreateExecutor = SvcTskLstCustomerCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Sequences = <
      item
        Name = 'IdtCustomer'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '999999999'
        RangeLength = 9
        RangePicture = '999999999'
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
        BehaveAsSprLst = False
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
        BehaveAsSprLst = False
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
        BehaveAsSprLst = False
        DataFieldRange = 'Customer.TxtNumVAT'
        Title = 'VAT number'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtNumVAT')
        ParamValueSequence = 'Customer.TxtNumVAT'
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
    Left = 56
    Top = 144
  end
  object SvcTskLstClassification: TSvcListTask
    TaskName = 'ListClassification'
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
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
        SprRangeItems = DmdFpnUtils.SprCnvCodes
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
    Left = 56
    Top = 256
  end
  object SvcTskDetCustomer: TSvcFormTask
    TaskName = 'DetailCustomer'
    Enabled = True
    OnCreateExecutor = SvcTskDetCustomerCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 184
    Top = 256
  end
  object SvcTskDetDepartment: TSvcFormTask
    TaskName = 'AskDepartment'
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
    Enabled = True
    OnCreateExecutor = SvcTskDetDepartmentCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 48
    Top = 312
  end
end
