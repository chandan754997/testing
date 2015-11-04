inherited FrmDetCAPerformanceCaissiere: TFrmDetCAPerformanceCaissiere
  Left = 467
  Top = 164
  Width = 457
  Height = 421
  Caption = 'Performance operator'
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded
    Left = 32
    Top = 72
  end
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Left = 280
    Top = 72
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Visible = False
  end
  inherited StsBarExec: TStatusBar
    Top = 375
    Width = 449
  end
  inherited PgsBarExec: TProgressBar
    Top = 359
    Width = 449
  end
  inherited PnlBtnsTop: TPanel
    Width = 449
    inherited BtnExit: TSpeedButton
      Left = 383
    end
  end
  inherited GbxLogging: TGroupBox
    Top = 124
  end
  inherited DtmPckDayFrom: TDateTimePicker
    Left = 120
    Top = 64
  end
  inherited Panel1: TPanel
    Top = 97
    Height = 173
    inherited ChkLbxOperator: TCheckListBox
      Height = 101
    end
    inherited BtnSelectAll: TBitBtn
      Top = 109
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 143
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Visible = False
  end
  inherited RbtDateDay: TRadioButton
    Left = 8
    Top = 48
  end
  inherited RbtDateLoaded: TRadioButton
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker
    Left = 320
    Top = 64
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Visible = False
  end
  object SprCAPerformanceCaissiere: TStoredProc
    DatabaseName = 'DBFlexPoint'
    StoredProcName = 'SprLstPerformanceCaissieres;1'
    Left = 296
    Top = 200
    ParamData = <
      item
        DataType = ftInteger
        Name = 'RETURN_VALUE'
        ParamType = ptResult
      end
      item
        DataType = ftString
        Name = '@PrmTxtSequence'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@PrmTxtFrom'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@PrmTxtTo'
        ParamType = ptInput
      end>
  end
end
