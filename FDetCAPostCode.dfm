inherited FrmDetCAPostCode: TFrmDetCAPostCode
  Left = 298
  Top = 211
  Caption = 'Rapport CA PostCode'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Visible = False
  end
  inherited StsBarExec: TStatusBar
    Top = 377
  end
  inherited PgsBarExec: TProgressBar
    Top = 396
  end
  inherited GbxLogging: TGroupBox
    Top = -65
  end
  inherited Panel1: TPanel
    Height = 277
    inherited ChkLbxOperator: TCheckListBox
      Height = 197
    end
    inherited BtnSelectAll: TBitBtn
      Top = 213
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 245
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Visible = False
  end
  inherited RbtDateDay: TRadioButton
    Top = 58
  end
  inherited RbtDateLoaded: TRadioButton
    Visible = False
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Visible = False
  end
  inherited SvcExHApp: TSvcExceptHandler
    Left = 368
  end
  object CAPostCodeSpr: TStoredProc
    DatabaseName = 'DBFlexPoint'
    StoredProcName = 'SprPostCodeReport'
    Left = 304
    Top = 304
    ParamData = <
      item
        DataType = ftInteger
        Name = '@RETURN_VALUE'
        ParamType = ptResult
        Value = 1111770880
      end
      item
        DataType = ftString
        Name = '@OperatorNumber'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@DatFrm'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@DatTo'
        ParamType = ptInput
      end>
  end
end
