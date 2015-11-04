inherited FrmModeMonetique: TFrmModeMonetique
  Left = 304
  Top = 251
  Width = 477
  Height = 387
  Caption = 'EFT online/offline'
  PixelsPerInch = 96
  TextHeight = 13
  object LblSelectCashDesk: TLabel [0]
    Left = 0
    Top = 49
    Width = 209
    Height = 13
    Caption = 'Set cashdesks on-/offline (checked=offline):'
  end
  inherited StsBarExec: TStatusBar
    Top = 341
    Width = 469
  end
  inherited PgsBarExec: TProgressBar
    Top = 306
    Align = alNone
  end
  inherited PnlBtnsTop: TPanel
    Width = 469
    inherited BtnExit: TSpeedButton
      Left = 403
    end
  end
  inherited GbxLogging: TGroupBox
    Top = 174
  end
  object ChkLstModeMonetique: TCheckListBox [5]
    Left = 0
    Top = 64
    Width = 353
    Height = 258
    ItemHeight = 13
    TabOrder = 4
  end
  object BtnSelect: TButton [6]
    Left = 360
    Top = 64
    Width = 105
    Height = 25
    Caption = 'Select All'
    TabOrder = 5
    OnClick = BtnSelectClick
  end
  object BtnDeselect: TButton [7]
    Left = 360
    Top = 96
    Width = 105
    Height = 25
    Caption = 'Deselect All'
    TabOrder = 6
    OnClick = BtnDeselectClick
  end
end
