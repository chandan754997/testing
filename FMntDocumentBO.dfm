inherited FrmMntDocumentBO: TFrmMntDocumentBO
  Left = 158
  Top = 237
  Width = 366
  Height = 281
  Caption = 'Maintenance Document BO'
  PixelsPerInch = 96
  TextHeight = 13
  object SvcTmgMaintenance: TSvcTaskManager
    MainTask = SvcTskLstDocumentBO
    Left = 44
    Top = 24
  end
  object SvcTskLstDocumentBO: TSvcListTask
    TaskName = 'LstDocumentBO'
    LaunchTasks = <
      item
        TaskName = 'DetDocumentBO'
        PropertiesPassed.Strings = (
          'SelectedJob=CodJob'
          'StrLstIdtValues'
          'StrLstFieldValues=StrLstRelatedInfo'
          'TxtTaskName=TxtTaskNameMRU')
      end
      item
        TaskName = 'RptDocumentBO'
      end
      item
        TaskName = 'AutoRunDocBO'
      end>
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
    Enabled = True
    OnCreate = SvcTskLstCreate
    OnExecute = SvcTskLstDocumentBOExecute
    OnCreateExecutor = SvcTskLstDocumentBOCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Sequences = <
      item
        Name = 'IdtCVente'
        DataType = pftComp
        RangeLo = '0'
        RangeHi = '9999999999'
        RangeLength = 10
        RangePicture = '9999999999'
        DataFieldRange = 'IdtCVente'
        Title = 'Identification document BO'
        Caption = 'Id document BO'
        DataSet = DmdFpnBODocument.SprLstDocumentBO
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubString'
        ColorFields.Strings = (
          'IdtCVente')
        ParamValueSequence = 'IdtCVente'
        BehaveAsSprLst = False
      end
      item
        Name = 'DatTransBegin'
        DataType = pftDate
        AllowSubString = False
        RangeLength = 0
        DataFieldRange = 'DatTransBegin'
        Title = 'Date ticket'
        Caption = 'Date Ticket'
        DataSet = DmdFpnBODocument.SprLstDocumentBO
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubString'
        ColorFields.Strings = (
          'DatTransBegin')
        ParamValueSequence = 'DatTransBegin'
      end
      item
        Name = 'IdtPosTransaction'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '2147483647'
        RangeLength = 0
        DataFieldRange = 'IdtPosTransaction'
        Title = 'Ticket Number'
        DataSet = DmdFpnBODocument.SprLstDocumentBO
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubString'
        ColorFields.Strings = (
          'IdtPosTransaction')
        ParamValueSequence = 'IdtPosTransaction'
      end
      item
        Name = 'CodTypeVente'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '2147483647'
        RangeLength = 0
        DataFieldRange = 'CodTypeVente'
        Title = 'Type BO Document '
        DataSet = DmdFpnBODocument.SprLstDocumentBO
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubString'
        ColorFields.Strings = (
          'CodTypeVente')
        ParamValueSequence = 'CodTypeVente'
      end>
    ListName = 'Document BO'
    IdtFields.Strings = (
      'IdtPosTransaction'
      'IdtCheckout'
      'CodTrans'
      'DatTransBegin'
      'IdtCVente'
      'CodTypeVente')
    MRUMax = 10
    MRUFields.Strings = (
      'IdtCVente')
    LookupSequence = 0
    RefreshOptions = [rloAfterChange, rloAfterExecTask, rloMsgAfterChange, rloMsgYes, rloMsgNo, rloMsgCancel, rloMsgIgnore]
    DetailTask = 'DetDocumentBO'
    ShowRecordCount = False
    Left = 48
    Top = 88
  end
  object SvcTskDetDocumentBO: TSvcFormTask
    TaskName = 'DetDocumentBO'
    LaunchTasks = <
      item
        TaskName = 'ChangeDocBONb'
        PropertiesPassed.Strings = (
          'StrLstIdtValues')
        PropertiesReturned.Strings = (
          'StrLstIdtValues')
      end>
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
    Enabled = True
    OnCreateExecutor = SvcTskDetDocumentBOCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 168
    Top = 88
  end
  object SvcTskRptDocBoGlobal: TSvcFormTask
    TaskName = 'RptDocumentBOGlobal'
    LaunchTasks = <
      item
        TaskName = 'SelectDate'
        PropertiesReturned.Strings = (
          'DatBeginSel'
          'DatEndSel')
      end>
    Enabled = True
    OnExecute = SvcTskRptDocBoGlobalExecute
    OnCreateExecutor = SvcTskRptDocBoGlobalCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 48
    Top = 144
  end
  object SvcTskChangeDocBONb: TSvcFormTask
    TaskName = 'ChangeDocBONb'
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
    Enabled = True
    OnCreateExecutor = SvcTskChangeDocBONbCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 172
    Top = 140
  end
  object SvcTskRptDocBODetail: TSvcFormTask
    TaskName = 'RptDocumentBODetail'
    LaunchTasks = <
      item
        TaskName = 'SelectDate'
        PropertiesReturned.Strings = (
          'DatBeginSel'
          'DatEndSel')
      end>
    Enabled = True
    OnExecute = SvcTskRptDocBODetailExecute
    OnCreateExecutor = SvcTskRptDocBODetailCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 48
    Top = 196
  end
  object SvcSelectdate: TSvcFormTask
    TaskName = 'SelectDate'
    Enabled = True
    OnCreateExecutor = SvcSelectdateCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Left = 168
    Top = 196
  end
  object SvcTskAutoRunDocBO: TSvcFormTask
    TaskName = 'AutoRunDocBO'
    LaunchTasks = <
      item
        TaskName = 'SvcTskPrintRep1'
      end>
    Enabled = True
    OnCreateExecutor = SvcTskAutoRunDocBOCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 280
    Top = 88
  end
  object SvcTskPrintRep1: TSvcFormTask
    TaskName = 'PrintRep1'
    Enabled = True
    OnExecute = SvcTskPrintRep1Execute
    OnCreateExecutor = SvcTskPrintRep1CreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 280
    Top = 144
  end
end
