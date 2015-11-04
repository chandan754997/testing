inherited FrmArchiveDB: TFrmArchiveDB
  Caption = 'Archive Electronic Journal'
  PixelsPerInch = 96
  TextHeight = 13
  object LblArchiveDate: TLabel [0]
    Left = 40
    Top = 81
    Width = 60
    Height = 13
    Caption = 'Archive date'
  end
  inherited StsBarExec: TStatusBar
    Top = 310
  end
  inherited PgsBarExec: TProgressBar
    Top = 294
  end
  inherited PnlBtnsTop: TPanel
    inherited BtnStart: TSpeedButton
      Caption = '&Export'
    end
  end
  inherited GbxLogging: TGroupBox
    Top = 128
  end
  object DTPickerArchiveDate: TDateTimePicker [5]
    Left = 160
    Top = 80
    Width = 186
    Height = 21
    Date = 0.401062268516398000
    Time = 0.401062268516398000
    TabOrder = 4
  end
  object qryJobStatus: TQuery
    DatabaseName = 'DBFlexPoint'
    SQL.Strings = (
      'SELECT CONVERT(VARCHAR(1000),job_id) as JobID FROM msdb..sysjobs'
      '  WHERE name = '#39'Manual back-up electronic journal'#39
      '')
    Left = 384
    Top = 48
  end
  object SprJobStatus: TStoredProc
    DatabaseName = 'DBFlexPoint'
    StoredProcName = 'msdb..sp_get_composite_job_info'
    Left = 280
    Top = 120
    ParamData = <
      item
        DataType = ftString
        Name = '@Job_ID'
        ParamType = ptInput
      end>
  end
  object SprManArchive: TStoredProc
    DatabaseName = 'DBFlexPoint'
    StoredProcName = 'msdb..sp_start_job'
    Left = 288
    Top = 176
    ParamData = <
      item
        DataType = ftString
        Name = '@Job_Name'
        ParamType = ptInput
      end>
  end
end
