inherited FrmMntEmployee: TFrmMntEmployee
  Left = 430
  Top = 231
  Caption = 'FrmMntEmployee'
  PixelsPerInch = 96
  TextHeight = 13
  object SvcTskMgrEmployee: TSvcTaskManager
    MainTask = SvcTskLstEmployee
    Left = 49
    Top = 16
  end
  object SvcTskLstEmployee: TSvcListTask
    TaskName = 'ListEmployee'
    LaunchTasks = <
      item
        TaskName = 'DetailEmployee'
        PropertiesPassed.Strings = (
          'SelectedJob=CodJob'
          'StrLstIdtValues'
          'StrLstFieldValues=StrLstRelatedInfo'
          'TxtTaskName=TxtTaskNameMRU')
        PropertiesReturned.Strings = (
          'StrLstIdtValues'
          'FlgRowModified=FlgDBApplied')
      end
      item
        TaskName = 'PrintCards'
        PropertiesPassed.Strings = (
          'StrLstSelIdt')
      end>
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
    Enabled = True
    OnCreate = SvcTskLstCreate
    OnCreateExecutor = SvcTskLstEmployeeCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Sequences = <
      item
        Name = 'IdtEmployee'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '999999999'
        RangeLength = 9
        RangePicture = '999999999'
        DataFieldRange = 'IdtEmployee'
        Title = 'Employee number'
        DataSet = DmdFpnEmployee.SprLstEmployee
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubString'
        ColorFields.Strings = (
          'IdtEmployee')
        ParamValueSequence = 'IdtEmployee'
      end
      item
        Name = 'TxtLastName'
        DataType = pftString
        RangeLength = 20
        DataFieldRange = 'TxtLastName'
        Title = 'Name'
        DataSet = DmdFpnEmployee.SprLstEmployee
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubString'
        ColorFields.Strings = (
          'TxtLastName')
        ParamValueSequence = 'TxtLastName'
      end>
    ListName = 'Employee'
    IdtFields.Strings = (
      'IdtEmployee')
    MRUFields.Strings = (
      'IdtEmployee'
      'TxtLastName')
    DetailTask = 'DetailEmployee'
    ShowRecordCount = False
    Left = 48
    Top = 81
  end
  object SvcTskDetEmployee: TSvcFormTask
    TaskName = 'DetailEmployee'
    Enabled = True
    OnCreateExecutor = SvcTskDetEmployeeCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 168
    Top = 80
  end
  object SvcTskPrintCards: TSvcFormTask
    TaskName = 'PrintCards'
    Enabled = True
    OnCreateExecutor = SvcTskPrintCardsCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 48
    Top = 136
  end
end
