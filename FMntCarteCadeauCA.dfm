inherited FrmMntCarteCadeauCA: TFrmMntCarteCadeauCA
  Width = 339
  Height = 197
  Caption = 'Carte Cadeau'
  PixelsPerInch = 96
  TextHeight = 13
  object SvcTmgMaintenance: TSvcTaskManager
    MainTask = SvcTskLstCarteCadeau
    Left = 56
    Top = 8
  end
  object SvcTskLstCarteCadeau: TSvcListTask
    TaskName = 'ListCarteCadeau'
    LaunchTasks = <
      item
        TaskName = 'DetailCarteCadeau'
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
    OnCreateExecutor = SvcTskLstCarteCadeauCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Sequences = <
      item
        Name = 'IdtArtCode'
        DataType = pftString
        RangeLength = 0
        DataFieldRange = 'IdtArtCode'
        Title = 'CardNumber'
        DataSet = DmdFpnCarteCadeau.SprLstCarteCadeau
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtArtCode')
        ParamValueSequence = 'IdtArtCode'
      end>
    ListName = 'Carte Cadeau'
    IdtFields.Strings = (
      'IdtArtCode')
    MRUMax = 10
    MRUFields.Strings = (
      'IdtArtCode')
    LookupSequence = 0
    DetailTask = 'DetailCarteCadeau'
    ShowRecordCount = False
    Left = 56
    Top = 56
  end
  object SvcTskDetCarteCadeau: TSvcFormTask
    TaskName = 'DetailCarteCadeau'
    StoredProcApplicText = DmdFpnCarteCadeau.SprLstCarteCadeau
    Enabled = True
    OnCreateExecutor = SvcTskDetCarteCadeauCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 184
    Top = 56
  end
end
