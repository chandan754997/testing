inherited FrmDetOperatorCA: TFrmDetOperatorCA
  Left = 340
  Top = 131
  ActiveControl = SvcDBMETxtName
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    inherited SvcDBLblIdtOperator: TSvcDBLabelLoaded
      IdtLabel = 'IdtOperator2'
    end
    inherited SvcDBMEIdtOperator: TSvcDBMaskEdit
      TabStop = False
      TabOrder = 1
    end
    inherited SvcDBMETxtName: TSvcDBMaskEdit
      Properties.MaxLength = 30
      TabOrder = 0
    end
  end
  inherited PnlBottom: TPanel
    inherited PnlBottomRight: TPanel
      TabOrder = 2
      inherited BtnCancel: TBitBtn
        OnClick = BtnCancelClick
      end
    end
    inherited BtnApply: TBitBtn
      TabOrder = 3
    end
    inherited PnlBtnAdd: TPanel
      TabOrder = 1
    end
    inherited BtnAddOn: TBitBtn
      TabOrder = 4
    end
    object btnFichaOperator: TBitBtn
      Left = 208
      Top = 4
      Width = 121
      Height = 25
      Caption = 'Ficha Operator'
      TabOrder = 0
      Visible = False
      OnClick = BtnFichaOperatorClick
      Glyph.Data = {
        66030000424D6603000000000000360000002800000010000000110000000100
        1800000000003003000000000000000000000000000000000000CAFFFECAFFFE
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000FFFFFFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000FFFFFF000000000000
        000000000000000000000000000000808080C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
        0000000000C0C0C0808080C0C0C0C0C0C0C0C0C0000000FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF000000808080808080C0C0
        C0C0C0C0000000FFFFFFFFFFFFFFFFFFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
        0000FFFFFFFFFFFF000000C0C0C0C0C0C0C0C0C0000000FFFFFFFFFFFFFFFFFF
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000000000000000000000000000C0C0
        C0C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0C0C0C0000000FFFFFFFFFFFFFFFFFF
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FFFFFFC0C0
        C0C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0C0C0C0000000FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0
        C0C0C0C0000000FFFFFFFFFFFFFFFFFFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0FFFFFFC0C0C0C0C0C0000000FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0
        C0C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0C0C0C0000000FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0
        C0C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0CAFFFECAFFFEFFFFFF000000000000
        000000000000000000000000000000000000000000000000000000000000CAFF
        FECAFFFECAFFFEFFFFFF}
      Margin = 7
      Spacing = 2
    end
  end
  inherited PgeCtlDetail: TPageControl
    TabStop = False
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        inherited GbxDates: TGroupBox
          inherited SvcDBLFDatCreate: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFDatModify: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
        end
        inherited GbxCommon: TGroupBox
          inherited SvcDBLblCodSecurity: TSvcDBLabelLoaded
            IdtLabel = 'CodProtection'
          end
        end
        inherited GbxPassword: TGroupBox
          inherited LblConfirmPassword: TLabel
            Visible = False
          end
          inherited SvcDBLblTxtPassword: TSvcDBLabelLoaded
            Width = 72
            Caption = 'Badge number:'
            IdtLabel = 'IdtBadge'
          end
          inherited SvcMEConfirmPassword: TSvcMaskEdit
            Visible = False
          end
          object BtnInitSecretCode: TBitBtn
            Left = 504
            Top = 11
            Width = 114
            Height = 49
            Caption = 'Init Secret Code'
            TabOrder = 2
            OnClick = BtnInitSecretCodeClick
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
          end
        end
        inherited GbxTxtWinUserName: TGroupBox
          Visible = False
        end
        inherited GbxIdtPos: TGroupBox
          Visible = False
          inherited SvcDBLFIdtPOS: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E7030000000000000000}
            RangeLow = {00000000000000000000}
          end
        end
      end
    end
    object TabShtPosFunc: TTabSheet
      Caption = 'Pos functions'
      ImageIndex = 1
      TabVisible = False
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 624
        Height = 292
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 0
        object GroupBox1: TGroupBox
          Left = 0
          Top = 0
          Width = 624
          Height = 65
          Align = alTop
          TabOrder = 0
          object ChxBlockSale: TCheckBox
            Left = 16
            Top = 16
            Width = 97
            Height = 17
            Caption = 'Block sale'
            TabOrder = 0
            OnExit = ChxBlockExit
          end
          object ChxBlockReturn: TCheckBox
            Left = 16
            Top = 40
            Width = 97
            Height = 17
            Caption = 'Block return'
            TabOrder = 1
            OnExit = ChxBlockExit
          end
        end
      end
    end
  end
  inherited OvcCtlDetail: TOvcController
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
  inherited DscOperator: TDataSource
    OnDataChange = DscOperatorDataChange
  end
end
