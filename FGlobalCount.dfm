inherited FrmGlobalCount: TFrmGlobalCount
  Left = 284
  Top = 216
  Width = 344
  Height = 307
  Caption = 'Rapport for Global Count'
  PixelsPerInch = 96
  TextHeight = 13
  object SvcDBLblExecutionDate: TSvcDBLabelLoaded [0]
    Left = 8
    Top = 64
    Width = 74
    Height = 13
    Caption = 'Execution date:'
    IdtLabel = 'DatExecution'
  end
  object SvcDBLblCountReport: TSvcDBLabelLoaded [1]
    Left = 8
    Top = 88
    Width = 66
    Height = 13
    Caption = 'Count reports:'
    IdtLabel = 'SvcDBLblExecutionDate'
  end
  inherited StsBarExec: TStatusBar
    Top = 261
    Width = 336
    Panels = <
      item
        Text = 'Ready'
        Width = 180
      end
      item
        Text = 'Executed: '
        Width = 150
      end
      item
        Text = 'Exec time: 00:00:00'
        Width = 130
      end>
  end
  inherited PgsBarExec: TProgressBar
    Top = 245
    Width = 336
  end
  inherited PnlBtnsTop: TPanel
    Width = 336
    inherited BtnExit: TSpeedButton
      Left = 270
    end
  end
  inherited GbxLogging: TGroupBox
    Left = 48
    Top = 19
  end
  object DtmPckExecution: TDateTimePicker [6]
    Left = 104
    Top = 56
    Width = 185
    Height = 21
    Date = 37467.688006620360000000
    Time = 37467.688006620360000000
    TabOrder = 4
  end
  object CbxCountReports: TComboBox [7]
    Left = 104
    Top = 84
    Width = 225
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 5
  end
end
