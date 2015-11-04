inherited FrmADOCmmOrToFpnCa: TFrmADOCmmOrToFpnCa
  Height = 348
  Caption = 'Communication Oracle To Flexpoint'
  PixelsPerInch = 96
  TextHeight = 13
  inherited StsBarExec: TStatusBar
    Top = 302
  end
  inherited PgsBarExec: TProgressBar
    Top = 286
  end
  inherited GbxLogging: TGroupBox
    Left = 234
    Top = 137
    Width = 230
    Anchors = [akLeft, akRight, akBottom]
    inherited LblCntInfo: TLabel
      Anchors = [akTop]
    end
  end
  object LstBxResult: TListBox [4]
    Left = 234
    Top = 40
    Width = 230
    Height = 96
    Anchors = [akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 4
  end
  object ChkLbxTable: TCheckListBox [5]
    Left = 0
    Top = 41
    Width = 230
    Height = 206
    AllowGrayed = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 5
  end
  object TmrCheck: TTimer
    Enabled = False
    OnTimer = TmrCheckTimer
    Left = 288
    Top = 104
  end
end
