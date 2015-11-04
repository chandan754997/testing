inherited FrmDetCAEtatAnnulation: TFrmDetCAEtatAnnulation
  Left = 298
  Top = 211
  Width = 630
  Height = 549
  Caption = 'Rapport Annulation Ticket '
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded
    Top = 74
  end
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Left = 352
    Top = 384
    Visible = False
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Top = 98
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Left = 448
    Top = 24
    Visible = False
  end
  inherited StsBarExec: TStatusBar
    Top = 468
    Width = 622
  end
  inherited PgsBarExec: TProgressBar
    Top = 487
    Width = 622
  end
  inherited PnlBtnsTop: TPanel
    Width = 622
    inherited BtnExit: TSpeedButton
      Left = 556
    end
    object BtnExport: TSpeedButton
      Left = 202
      Top = 2
      Width = 60
      Height = 36
      AllowAllUp = True
      Caption = '&Export'
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
    Top = -601
  end
  inherited DtmPckDayFrom: TDateTimePicker
    Left = 344
    Top = 66
    Width = 137
    BevelEdges = [beLeft, beTop]
    TabOrder = 5
  end
  inherited Panel1: TPanel
    Top = 56
    Height = 294
    BevelEdges = [beLeft, beTop, beBottom]
    Caption = ''
    TabOrder = 4
    inherited ChkLbxOperator: TCheckListBox
      Height = 215
      Align = alCustom
      Anchors = [akLeft, akTop, akBottom]
      BevelEdges = [beLeft, beTop, beBottom]
    end
    inherited BtnSelectAll: TBitBtn
      Top = 226
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 258
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Left = 320
    Top = 384
    Visible = False
  end
  inherited RbtDateDay: TRadioButton
    Left = 264
    Top = 426
    Checked = False
    TabStop = False
    Visible = False
  end
  inherited RbtDateLoaded: TRadioButton
    Left = 320
    Top = 368
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker
    Left = 344
    Top = 90
    Width = 137
    BevelEdges = [beLeft, beTop]
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Left = 192
    Top = 384
    Visible = False
  end
  object RdBtnGlobal: TRadioButton [15]
    Left = 264
    Top = 136
    Width = 113
    Height = 17
    Caption = 'Global'
    TabOrder = 11
    OnClick = RdBtnGlobalClick
  end
  object RdBtnDetail: TRadioButton [16]
    Left = 376
    Top = 136
    Width = 113
    Height = 17
    Caption = 'Detail'
    Checked = True
    TabOrder = 12
    TabStop = True
    OnClick = RdBtnDetailClick
  end
  object RdBtnMotive: TRadioButton [17]
    Left = 496
    Top = 136
    Width = 113
    Height = 17
    Caption = 'Motive'
    TabOrder = 13
    OnClick = RdBtnMotiveClick
  end
  object CmbAskSelection: TComboBox [18]
    Left = 384
    Top = 383
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 14
    Visible = False
  end
  object ChkLBxReason: TCheckListBox [19]
    Left = 264
    Top = 160
    Width = 241
    Height = 113
    Anchors = [akLeft, akTop, akBottom]
    BevelEdges = [beLeft, beTop, beBottom]
    ItemHeight = 13
    TabOrder = 15
    Visible = False
  end
  inherited SvcExHApp: TSvcExceptHandler
    Left = 400
    Top = 0
  end
  inherited SvcAppInstCheck: TSvcAppInstance
    Left = 448
    Top = 0
  end
  inherited TmrExec: TTimer
    Left = 576
    Top = 176
  end
  inherited ActLstApp: TActionList
    Left = 568
    Top = 56
  end
  inherited ImgLstApp: TImageList
    Left = 568
    Top = 112
  end
  inherited MnuApp: TMainMenu
    Left = 576
    Top = 224
  end
  object CAEtatAnnulation: TStoredProc
    DatabaseName = 'dBFlexPoint'
    StoredProcName = 'SprAnnulationTicket;1'
    Left = 576
    Top = 272
    ParamData = <
      item
        DataType = ftInteger
        Name = '@RETURN_VALUE'
        ParamType = ptResult
      end
      item
        DataType = ftInteger
        Name = '@ReportType'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = '@DatFrom'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = '@DatTo'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@Reasons'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@OperatorSequence'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@OPCOName'
        ParamType = ptInput
      end>
  end
  object SavDlgExport: TSaveTextFileDialog
    DefaultExt = 'csv'
    Filter = 'Excel files|*.csv'
    Left = 576
    Top = 320
  end
end
