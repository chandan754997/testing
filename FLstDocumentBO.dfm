inherited FrmLstDocumentBO: TFrmLstDocumentBO
  Left = 62
  Top = 176
  Width = 639
  Caption = 'FrmLstDocumentBO'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlList: TPanel
    Width = 631
    Height = 240
    inherited DBGrdList: TDBGrid
      Width = 629
      Height = 238
      OnDrawColumnCell = DBGrdListDrawColumnCell
    end
  end
  inherited PnlButtons: TPanel
    Width = 631
    inherited PnlBtnsFunctions: TPanel
      Width = 509
      inherited BtnRecNew: TSpeedButton
        Left = 580
        Visible = False
      end
      inherited BtnRecMod: TSpeedButton
        Left = 640
        Visible = False
      end
      inherited BtnRecCopy: TSpeedButton
        Left = 700
      end
      inherited BtnRecCons: TSpeedButton
        Left = 0
      end
      inherited BtnRecSel: TSpeedButton
        Left = 64
      end
      inherited BtnRecDel: TSpeedButton
        Left = 128
      end
      inherited BvlRecSel: TBevel
        Left = 124
      end
      inherited BvlRecDel: TBevel
        Left = 60
        Top = 1
      end
      inherited BvlBtnSeqRefresh: TBevel
        Left = 188
      end
      inherited BtnSeqRefresh: TSpeedButton
        Left = 192
      end
      object BtnReportGlobal: TSpeedButton
        Left = 256
        Top = 2
        Width = 61
        Height = 36
        Hint = 'Show report'
        AllowAllUp = True
        Caption = 'Global'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333330000000
          00003333377777777777333330FFFFFFFFF03FF3F7FFFF33FFF7003000000FF0
          00F077F7777773F77737E00FBFBFB0FFFFF07773333FF7FF33F7E0FBFB00000F
          F0F077F333777773F737E0BFBFBFBFB0FFF077F3333FFFF733F7E0FBFB00000F
          F0F077F333777773F737E0BFBFBFBFB0FFF077F33FFFFFF733F7E0FB0000000F
          F0F077FF777777733737000FB0FFFFFFFFF07773F7F333333337333000FFFFFF
          FFF0333777F3FFF33FF7333330F000FF0000333337F777337777333330FFFFFF
          0FF0333337FFFFFF7F37333330CCCCCC0F033333377777777F73333330FFFFFF
          0033333337FFFFFF773333333000000003333333377777777333}
        Layout = blGlyphTop
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        Spacing = 2
        OnClick = BtnReportGlobalClick
      end
      object BvlBtnReport: TBevel
        Left = 252
        Top = 0
        Width = 4
        Height = 38
      end
      object BtnReportDetail: TSpeedButton
        Left = 317
        Top = 2
        Width = 61
        Height = 36
        Hint = 'Show report'
        AllowAllUp = True
        Caption = 'Detail'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333330000000
          00003333377777777777333330FFFFFFFFF03FF3F7FFFF33FFF7003000000FF0
          00F077F7777773F77737E00FBFBFB0FFFFF07773333FF7FF33F7E0FBFB00000F
          F0F077F333777773F737E0BFBFBFBFB0FFF077F3333FFFF733F7E0FBFB00000F
          F0F077F333777773F737E0BFBFBFBFB0FFF077F33FFFFFF733F7E0FB0000000F
          F0F077FF777777733737000FB0FFFFFFFFF07773F7F333333337333000FFFFFF
          FFF0333777F3FFF33FF7333330F000FF0000333337F777337777333330FFFFFF
          0FF0333337FFFFFF7F37333330CCCCCC0F033333377777777F73333330FFFFFF
          0033333337FFFFFF773333333000000003333333377777777333}
        Layout = blGlyphTop
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        Spacing = 2
        OnClick = BtnReportDetailClick
      end
    end
    inherited PnlBtnExit: TPanel
      Left = 570
    end
    inherited PnlBtnClose: TPanel
      Left = 510
    end
  end
  inherited PnlMRU: TPanel
    Width = 631
    inherited CbxMRU: TComboBox
      Width = 480
    end
  end
  inherited PnlSeqLimRefresh: TPanel
    Width = 631
    inherited PnlRefresh: TPanel
      Left = 543
    end
    inherited PnlSeqAndLim: TPanel
      Width = 535
      inherited PnlSequences: TPanel
        Width = 535
      end
      inherited PnlLimits: TPanel
        Width = 535
        inherited SvcLFLimitFrom: TSvcLocalField
          Epoch = 0
        end
        inherited SvcLFLimitTo: TSvcLocalField
          Epoch = 0
        end
      end
    end
  end
  inherited StsBarList: TStatusBar
    Top = 395
    Width = 631
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
end
