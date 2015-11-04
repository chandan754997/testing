inherited FrmLstOperatorCA: TFrmLstOperatorCA
  Left = 291
  Width = 675
  Caption = 'FrmLstOperatorCA'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlList: TPanel
    Width = 667
    Height = 240
    inherited DBGrdList: TDBGrid
      Width = 665
      Height = 257
    end
  end
  inherited PnlButtons: TPanel
    Width = 667
    inherited PnlBtnsFunctions: TPanel
      Width = 545
      object BtnInitSecretCode: TSpeedButton
        Left = 460
        Top = 2
        Width = 61
        Height = 36
        Hint = 'Refresh list'
        AllowAllUp = True
        Caption = 'Secret code'
        Enabled = False
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000003
          333333333F777773FF333333008888800333333377333F3773F3333077870787
          7033333733337F33373F3308888707888803337F33337F33337F330777880887
          7703337F33337FF3337F3308888000888803337F333777F3337F330777700077
          7703337F33377733337FB3088888888888033373FFFFFFFFFF733B3000000000
          0033333777777777773333BBBB3333080333333333F3337F7F33BBBB707BB308
          03333333373F337F7F3333BB08033308033333337F7F337F7F333B3B08033308
          033333337F73FF737F33B33B778000877333333373F777337333333B30888880
          33333333373FFFF73333333B3300000333333333337777733333}
        Layout = blGlyphTop
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        Spacing = 2
        Visible = False
        OnClick = MniInitSecretCodeClick
      end
      object Button1: TButton
        Left = 437
        Top = 2
        Width = 140
        Height = 36
        Caption = 'Activer Comptes Supports'
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        Visible = False
        WordWrap = True
        OnClick = Button1Click
      end
    end
    inherited PnlBtnExit: TPanel
      Left = 606
    end
    inherited PnlBtnClose: TPanel
      Left = 546
    end
  end
  inherited PnlMRU: TPanel
    Width = 667
    inherited CbxMRU: TComboBox
      Width = 516
    end
  end
  inherited PnlSeqLimRefresh: TPanel
    Width = 667
    inherited PnlRefresh: TPanel
      Left = 579
    end
    inherited PnlSeqAndLim: TPanel
      Width = 571
      inherited PnlSequences: TPanel
        Width = 571
        inherited CbxSequences: TComboBox
          Width = 420
        end
      end
      inherited PnlLimits: TPanel
        Width = 571
        inherited SvcLFLimitFrom: TSvcLocalField
          Width = 420
          Epoch = 0
        end
        inherited CbxLimitTo: TComboBox
          Width = 420
        end
        inherited SvcLFLimitTo: TSvcLocalField
          Width = 420
          Epoch = 0
        end
      end
    end
  end
  inherited StsBarList: TStatusBar
    Top = 395
    Width = 667
  end
  inherited OvcCtlList: TOvcController
    EntryCommands.TableList = (
      'Default'
      True
      ()
      'WordStar'
      False
      ()
      'Grid'
      False
      ())
  end
  inherited MmuList: TMainMenu
    inherited MniRecAction: TMenuItem
      object MniSep4: TMenuItem
        Caption = '-'
      end
      object MniInitSecretCode: TMenuItem
        Caption = 'Init Secret Code'
        Enabled = False
        OnClick = MniInitSecretCodeClick
      end
    end
  end
end
