inherited FrmMntOperatorCA: TFrmMntOperatorCA
  Left = 458
  Top = 118
  Height = 226
  Caption = 'FrmMntOperatorCA'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcTskLstOperator: TSvcListTask
    Sequences = <
      item
        Name = 'IdtOperator'
        DataType = pftString
        RangeLength = 10
        Title = 'Operator identification'
        Caption = 'Identification'
        DataSet = DmdFpnOperatorCA.SprLstOperator
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtOperator')
        ParamValueSequence = 'IdtOperator'
      end
      item
        Name = 'TxtName'
        DataType = pftString
        RangeLength = 20
        Title = 'Name'
        DataSet = DmdFpnOperatorCA.SprLstOperator
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtName')
        ParamValueSequence = 'TxtSrcName'
        BehaveAsSprLst = False
      end>
    HiddenFields.Strings = (
      'FlgModify')
  end
  inherited SvcTskDetOperator: TSvcFormTask
    LaunchTasks = <
      item
        TaskName = 'FichaOperatorReport'
        PropertiesPassed.Strings = (
          'OperatorNumber'
          'Name'
          'OperatorFunction'
          'IsAdmin'
          'Language'
          'IdentificationNumber'
          'DateCreate'
          'DateModify')
      end>
  end
  object SvcFrmFichaOperatorReport: TSvcFormTask
    TaskName = 'FichaOperatorReport'
    LaunchTasks = <
      item
        TaskName = 'detailoperator'
        PropertiesPassed.Strings = (
          'name')
      end>
    Enabled = True
    OnCreateExecutor = SvcFrmFichaOperatorReportCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 72
    Top = 120
  end
end
