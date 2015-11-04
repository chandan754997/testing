inherited FrmMntCodPos: TFrmMntCodPos
  Left = 496
  Top = 269
  Width = 301
  Caption = 'Maintenance Checkout type'
  OnActivate = nil
  PixelsPerInch = 96
  TextHeight = 13
  object SvcTmgMaintenance: TSvcTaskManager
    MainTask = SvcTskLstCodPos
    Left = 72
    Top = 8
  end
  object SvcTskLstCodPos: TSvcListTask
    TaskName = 'ListPOS'
    LaunchTasks = <
      item
        TaskName = 'DetailPOS'
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
    OnCreateExecutor = SvcTskLstCodPosCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Sequences = <
      item
        Name = 'IdtCheckout'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '999999999'
        RangeLength = 0
        DataFieldRange = 'IdtCheckout'
        Title = 'Checkout'
        DataSet = DmdFpnCodPos.SprLstCodPos
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtCheckout')
        ParamValueSequence = 'IdtCheckout'
      end
      item
        Name = 'CodPos'
        DataType = pftString
        RangeLo = '1'
        RangeHi = '5'
        RangeLength = 0
        RangeOptions = [rioRangeList]
        SprRangeItems = DmdFpnUtils.SprCnvCodes
        PrmRangeItems = 'Workstat.CodPos'
        DataFieldRange = 'CodPos'
        Title = 'Type'
        DataSet = DmdFpnCodPos.SprLstCodPos
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'CodPos')
        ParamValueSequence = 'CodPos'
      end>
    ListName = 'Checkout type'
    IdtFields.Strings = (
      'IdtCheckout')
    MRUMax = 10
    MRUFields.Strings = (
      'IdtCheckout')
    LookupSequence = 0
    DetailTask = 'DetailPOS'
    ShowRecordCount = False
    Left = 72
    Top = 56
  end
  object SvcTskDetCodPos: TSvcFormTask
    TaskName = 'DetailPOS'
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
    Enabled = True
    OnCreateExecutor = SvcTskDetCodPosCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 184
    Top = 56
  end
end
