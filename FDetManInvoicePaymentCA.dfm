inherited FrmDetManInvoicePaymentCA: TFrmDetManInvoicePaymentCA
  Left = 213
  Top = 157
  Width = 319
  Height = 392
  Caption = 'Invoice Payment'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    Width = 311
    Height = 9
  end
  inherited PnlBottom: TPanel
    Top = 307
    Width = 311
    inherited PnlBottomRight: TPanel
      Left = 123
      inherited BtnOK: TBitBtn
        Default = False
        OnClick = BtnOKClick
      end
      inherited BtnCancel: TBitBtn
        OnClick = BtnCancelClick
      end
    end
    inherited PnlBtnAdd: TPanel
      Left = 27
    end
  end
  inherited PgeCtlDetail: TPageControl
    Top = 9
    Width = 311
    Height = 298
    ActivePage = TabShtPayments
    object TabShtPayments: TTabSheet
      Caption = 'Payment'
      object SbxPayments: TScrollBox
        Left = 0
        Top = 0
        Width = 303
        Height = 209
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 0
        object LblNoPayments: TLabel
          Left = 9
          Top = 8
          Width = 229
          Height = 16
          Caption = 'No payment methodes available.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
          WordWrap = True
        end
      end
      object PnlTotalPayed: TPanel
        Left = 0
        Top = 209
        Width = 303
        Height = 61
        Align = alBottom
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 1
        object SvcDBLblTotalPayed: TSvcDBLabelLoaded
          Left = 8
          Top = 24
          Width = 57
          Height = 13
          Caption = 'Total Payed'
          IdtLabel = 'ValTotalPaid'
        end
        object LblTotalPayed: TLabel
          Left = 160
          Top = 24
          Width = 68
          Height = 13
          Alignment = taRightJustify
          Caption = 'LblTotalPayed'
        end
        object LblCurrTotalPayed: TLabel
          Left = 232
          Top = 24
          Width = 87
          Height = 13
          Caption = 'LblCurrTotalPayed'
        end
        object SvcDBLblTotalToPay: TSvcDBLabelLoaded
          Left = 8
          Top = 8
          Width = 61
          Height = 13
          Caption = 'Total To Pay'
          IdtLabel = 'ValTotalPaid'
        end
        object LblTotalToPay: TLabel
          Left = 159
          Top = 8
          Width = 69
          Height = 13
          Alignment = taRightJustify
          Caption = 'LblTotalToPay'
        end
        object LblCurrTotalToPay: TLabel
          Left = 232
          Top = 8
          Width = 88
          Height = 13
          Caption = 'LblCurrTotalToPay'
        end
        object SvcDBLblRemainingToPay: TSvcDBLabelLoaded
          Left = 8
          Top = 40
          Width = 82
          Height = 13
          Caption = 'Remaining to pay'
          IdtLabel = 'ValTotalPaid'
        end
        object LblRemainingToPay: TLabel
          Left = 133
          Top = 40
          Width = 95
          Height = 13
          Alignment = taRightJustify
          Caption = 'LblRemainingToPay'
        end
        object LblCurrRemainingToPay: TLabel
          Left = 232
          Top = 40
          Width = 87
          Height = 13
          Caption = 'LblCurrTotalPayed'
        end
      end
    end
  end
  inherited StsBarInfo: TStatusBar
    Top = 339
    Width = 311
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
    Left = 264
    Top = 0
  end
end
