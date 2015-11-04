inherited FrmChkQueue: TFrmChkQueue
  Left = 428
  Top = 205
  Caption = 'Check Run Closure'
  PixelsPerInch = 96
  TextHeight = 13
  inherited StsBarExec: TStatusBar
    Top = 318
  end
  inherited PgsBarExec: TProgressBar
    Top = 302
  end
  inherited GbxLogging: TGroupBox
    Top = -158
    inherited LblCntError: TLabel
      Top = 64
    end
  end
  inherited TmrExec: TTimer
    Interval = 0
  end
  object QryResult: TQuery
    DatabaseName = 'DBFlexPoint'
    SQL.Strings = (
      'SELECT IdtWorkStat FROM WORKSTAT (NOLOCK)'
      'WHERE CodType BETWEEN  20 AND 30 ')
    Left = 280
    Top = 80
  end
  object SprCheck: TStoredProc
    DatabaseName = 'DBFlexPoint'
    StoredProcName = 'SprChkQueue;1'
    Left = 208
    Top = 216
    ParamData = <
      item
        DataType = ftInteger
        Name = '@RETURN_VALUE'
        ParamType = ptResult
      end>
  end
  object QryText: TQuery
    DatabaseName = 'DBFlexPoint'
    SQL.Strings = (
      'SELECT IdtWorkStat FROM WORKSTAT (NOLOCK)'
      'WHERE CodType BETWEEN  10 and 20')
    Left = 192
    Top = 96
  end
  object ADOQryText: TADOQuery
    Connection = DmdFpnADOCA.ADOConFlexpoint
    Parameters = <>
    SQL.Strings = (
      'SELECT IdtWorkStat FROM WORKSTAT (NOLOCK)'
      'WHERE CodType BETWEEN  10 and 20')
    Left = 96
    Top = 96
  end
  object ADOSPrCheck: TADOStoredProc
    Connection = DmdFpnADOCA.ADOConFlexpoint
    ProcedureName = 'SprChkQueue;1'
    Parameters = <
      item
        Name = '@Return_Value'
        DataType = ftInteger
        Direction = pdReturnValue
        Value = Null
      end
      item
        Name = '@FlgBDFR'
        DataType = ftString
        Value = Null
      end>
    Left = 96
    Top = 152
  end
end
