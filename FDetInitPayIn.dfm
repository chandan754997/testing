inherited FrmDetInitPayIn: TFrmDetInitPayIn
  Left = 302
  Top = 162
  Height = 458
  Caption = 'Insert'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    Height = 33
    object LblTraitementDate: TLabel
      Left = 8
      Top = 10
      Width = 92
      Height = 13
      Caption = 'Traitement Date'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DTPckTransAction: TDateTimePicker
      Left = 152
      Top = 5
      Width = 113
      Height = 21
      Date = 37516.000000000000000000
      Time = 37516.000000000000000000
      TabOrder = 0
      OnCloseUp = DTPckTransActionCloseUp
      OnKeyDown = DTPckTransActionKeyDown
      OnKeyUp = DTPckTransActionKeyUp
      OnUserInput = DTPckTransActionUserInput
    end
    object BtnSelectAll: TButton
      Left = 408
      Top = 5
      Width = 105
      Height = 21
      Caption = 'Select All'
      TabOrder = 1
      OnClick = BtnSelectAllClick
    end
    object BtnDeselectAll: TButton
      Left = 520
      Top = 5
      Width = 107
      Height = 21
      Caption = 'Deselect all'
      TabOrder = 2
      OnClick = BtnDeselectAllClick
    end
  end
  inherited PnlBottom: TPanel
    Top = 373
    inherited PnlBottomRight: TPanel
      inherited BtnOK: TBitBtn
        Caption = '&Accept'
        Default = False
        OnClick = BtnOKClick
      end
      inherited BtnCancel: TBitBtn
        OnClick = BtnCancelClick
      end
    end
  end
  inherited PgeCtlDetail: TPageControl
    Top = 33
    Height = 340
    ActivePage = TbShtInitPayIn
    object TbShtInitPayIn: TTabSheet
      Caption = 'Initial Pay In'
      object SbxOperator: TScrollBox
        Left = 0
        Top = 25
        Width = 624
        Height = 287
        Align = alClient
        AutoSize = True
        BorderStyle = bsNone
        TabOrder = 0
      end
      object PnlTop: TPanel
        Left = 0
        Top = 0
        Width = 624
        Height = 25
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object LblNumOperator: TLabel
          Left = 8
          Top = 6
          Width = 81
          Height = 13
          AutoSize = False
          Caption = 'N'#176' Operator'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LblNameOperator: TLabel
          Left = 88
          Top = 6
          Width = 169
          Height = 13
          AutoSize = False
          Caption = 'Name Operator'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LblAmount: TLabel
          Left = 288
          Top = 6
          Width = 65
          Height = 13
          AutoSize = False
          Caption = 'Amount'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LblSelect: TLabel
          Left = 424
          Top = 6
          Width = 49
          Height = 13
          AutoSize = False
          Caption = 'Select'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object LblAcpAmount: TLabel
          Left = 512
          Top = 6
          Width = 113
          Height = 13
          AutoSize = False
          Caption = 'Accepted amount'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
    end
  end
  inherited StsBarInfo: TStatusBar
    Top = 405
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
  end
end
