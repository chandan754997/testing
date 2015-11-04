inherited FrmDetErrorModoDePago: TFrmDetErrorModoDePago
  Left = 298
  Top = 211
  Caption = 'Rapport Error Modo De Pago'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Visible = False
  end
  inherited StsBarExec: TStatusBar
    Top = 366
  end
  inherited PgsBarExec: TProgressBar
    Top = 385
  end
  inherited GbxLogging: TGroupBox
    Top = -141
  end
  inherited Panel1: TPanel
    Height = 148
    inherited ChkLbxOperator: TCheckListBox
      Height = 83
    end
    inherited BtnSelectAll: TBitBtn
      Top = 84
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 116
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
  object CAErrorModoDePago: TStoredProc
    DatabaseName = 'DBFlexPoint'
    StoredProcName = 'SprErrorModoDePago;1'
    Left = 304
    Top = 304
    ParamData = <
      item
        DataType = ftInteger
        Name = '@RETURN_VALUE'
        ParamType = ptResult
        Value = 0
      end
      item
        DataType = ftString
        Name = '@DateFrom'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@DateTo'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@OperatorSequence'
        ParamType = ptInput
      end>
  end
end
