inherited FrmDetCAActiviteHoraire: TFrmDetCAActiviteHoraire
  Left = 344
  Top = 358
  Width = 489
  Height = 190
  Caption = 'Activity timetable'
  Visible = True
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded
    Left = 16
    Top = 72
    IdtLabel = 'IdtDateFrom'
  end
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Left = 280
    Top = 72
    IdtLabel = 'IdtDateTo'
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Visible = False
  end
  object SvcDBLblTimeSlice: TSvcDBLabelLoaded [4]
    Left = 16
    Top = 102
    Width = 49
    Height = 13
    Caption = 'Time Slice'
    StoredProc = DmdFpnUtils.SprCnvApplicText
    IdtLabel = 'TxtTimeSlice'
  end
  inherited StsBarExec: TStatusBar
    Top = 113
    Width = 473
    Panels = <
      item
        Text = 'Ready'
        Width = 200
      end
      item
        Text = 'Executed: '
        Width = 150
      end
      item
        Text = 'Exec time: 00:00:00'
        Width = 134
      end>
    Visible = False
  end
  inherited PgsBarExec: TProgressBar
    Top = 97
    Width = 473
  end
  inherited PnlBtnsTop: TPanel
    Width = 473
    inherited BtnStart: TSpeedButton
      Left = 296
      Top = -6
    end
    inherited BtnExit: TSpeedButton
      Left = 415
    end
    inherited BtnStop: TSpeedButton
      Left = 464
      Top = 10
    end
    object BtnExport: TSpeedButton
      Left = 201
      Top = 2
      Width = 60
      Height = 36
      AllowAllUp = True
      Caption = 'E&xport'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        555555FFFFFFFFFF55555000000000055555577777777775FFFF00B8B8B8B8B0
        0000775F5555555777770B0B8B8B8B8B0FF07F75F555555575F70FB0B8B8B8B8
        B0F07F575FFFFFFFF7F70BFB0000000000F07F557777777777570FBFBF0FFFFF
        FFF07F55557F5FFFFFF70BFBFB0F000000F07F55557F777777570FBFBF0FFFFF
        FFF075F5557F5FFFFFF750FBFB0F000000F0575FFF7F777777575700000FFFFF
        FFF05577777F5FF55FF75555550F00FF00005555557F775577775555550FFFFF
        0F055555557F55557F755555550FFFFF00555555557FFFFF7755555555000000
        0555555555777777755555555555555555555555555555555555}
      Layout = blGlyphTop
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = False
      Spacing = 2
      OnClick = BtnExportClick
    end
  end
  inherited GbxLogging: TGroupBox
    Top = -567
  end
  inherited DtmPckDayFrom: TDateTimePicker
    Left = 120
    Top = 64
    TabOrder = 5
  end
  inherited Panel1: TPanel
    Left = 16
    Top = -279
    Height = 0
    TabOrder = 4
    Visible = False
    inherited ChkLbxOperator: TCheckListBox
      Height = 0
      Enabled = False
      Font.Color = clGrayText
      ParentFont = False
    end
    inherited BtnSelectAll: TBitBtn
      Top = -339
      Enabled = False
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = -307
      Enabled = False
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    TabOrder = 7
    Visible = False
  end
  inherited RbtDateDay: TRadioButton
    Left = 8
    Top = 48
    TabOrder = 8
  end
  inherited RbtDateLoaded: TRadioButton
    Enabled = False
    TabOrder = 9
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker
    Left = 320
    Top = 64
    TabOrder = 6
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Visible = False
  end
  object CbxTimeSlice: TComboBox [16]
    Left = 120
    Top = 96
    Width = 121
    Height = 21
    ItemHeight = 13
    TabOrder = 11
    Text = 'CbxTimeSlice'
  end
  object ChxClassification: TCheckBox [17]
    Left = 280
    Top = 96
    Width = 161
    Height = 17
    Caption = 'Sales per classification'
    TabOrder = 12
  end
  inherited SvcExHApp: TSvcExceptHandler
    Left = 552
    Top = 56
  end
  inherited SvcAppInstCheck: TSvcAppInstance
    Left = 440
    Top = 88
  end
  object SprCAActiviteHoraire: TStoredProc
    DatabaseName = 'DBFlexPoint'
    StoredProcName = 'SprLstActHoraire;1'
    Left = 304
    Top = 184
    ParamData = <
      item
        DataType = ftInteger
        Name = 'RETURN_VALUE'
        ParamType = ptResult
      end
      item
        DataType = ftDateTime
        Name = '@PrmDatFrom'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = '@PrmDatTo'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@PrmClassFrom'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@PrmClassTo'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = '@PrmTimPart'
        ParamType = ptInput
      end
      item
        DataType = ftBoolean
        Name = '@PrmFlgShowClass'
        ParamType = ptInput
      end>
  end
  object SprCAHoraire: TStoredProc
    DatabaseName = 'DBFlexPoint'
    StoredProcName = 'SprLstCAHoraire;1'
    Left = 280
    Top = 44
    ParamData = <
      item
        DataType = ftInteger
        Name = '@RETURN_VALUE'
        ParamType = ptResult
      end
      item
        DataType = ftDateTime
        Name = '@PrmDatFrom'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = '@PrmDatTo'
        ParamType = ptInput
      end>
  end
  object SavDlgExport: TSaveTextFileDialog
    DefaultExt = 'csv'
    Filter = 'Excel files|*.csv'
    Left = 136
    Top = 232
  end
end
