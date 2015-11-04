inherited FrmLstCouponCA: TFrmLstCouponCA
  Left = 557
  Top = 79
  Width = 700
  Height = 520
  Caption = 'FrmLstCouponCA'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlList: TPanel
    Width = 684
    Height = 308
    inherited DBGrdList: TDBGrid
      Width = 682
      Height = 286
    end
  end
  inherited PnlButtons: TPanel
    Width = 684
    inherited PnlBtnsFunctions: TPanel
      Width = 562
      inherited BtnRecCopy: TSpeedButton
        Left = 496
      end
      object BtnExprt: TSpeedButton
        Left = 436
        Top = 2
        Width = 60
        Height = 36
        AllowAllUp = True
        Caption = 'E&xport'
        Enabled = False
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
        OnClick = BtnExprtClick
      end
      object BtnPrint: TSpeedButton
        Left = 120
        Top = 2
        Width = 60
        Height = 36
        Caption = '&Print'
        Enabled = False
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
          00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
          8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
          8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
          8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
          03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
          03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
          33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
          33333337FFFF7733333333300000033333333337777773333333}
        Layout = blGlyphTop
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = False
        Spacing = 2
        OnClick = BtnPrintClick
      end
    end
    inherited PnlBtnExit: TPanel
      Left = 623
    end
    inherited PnlBtnClose: TPanel
      Left = 563
    end
  end
  inherited PnlMRU: TPanel
    Width = 684
    inherited CbxMRU: TComboBox
      Width = 541
    end
  end
  inherited PnlSeqLimRefresh: TPanel
    Width = 684
    inherited PnlRefresh: TPanel
      Left = 596
    end
    inherited PnlSeqAndLim: TPanel
      Width = 596
      inherited PnlSequences: TPanel
        Width = 596
        inherited CbxSequences: TComboBox
          Width = 389
        end
      end
      inherited PnlLimits: TPanel
        Width = 596
        inherited SvcLFLimitFrom: TSvcLocalField
          Width = 389
          Epoch = 0
        end
        inherited CbxLimitFrom: TComboBox
          Width = 389
        end
        inherited CbxLimitTo: TComboBox
          Width = 389
        end
        inherited SvcLFLimitTo: TSvcLocalField
          Width = 389
          Epoch = 0
        end
        inherited SvcMELimitFrom: TSvcMaskEdit
          Width = 389
        end
        inherited SvcMELimitTo: TSvcMaskEdit
          Width = 389
        end
      end
    end
  end
  inherited StsBarList: TStatusBar
    Top = 463
    Width = 684
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
  object SavDlgExport: TSaveTextFileDialog
    DefaultExt = 'csv'
    Filter = 'Excel files|*.csv'
    Left = 232
    Top = 296
  end
end
