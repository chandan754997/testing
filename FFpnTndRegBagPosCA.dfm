inherited FrmTndRegBagCA: TFrmTndRegBagCA
  Left = 187
  Top = 183
  Width = 446
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'Sealbags'
  KeyPreview = True
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PnlTop: TPanel
    Left = 0
    Top = 0
    Width = 430
    Height = 41
    Align = alTop
    TabOrder = 0
    DesignSize = (
      430
      41)
    object LblFunc: TLabel
      Left = 8
      Top = 16
      Width = 417
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Tender sealbags'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object PnlBottom: TPanel
    Left = 0
    Top = 252
    Width = 430
    Height = 37
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      430
      37)
    object BtnOk: TBitBtn
      Left = 342
      Top = 8
      Width = 90
      Height = 25
      Hint = 'Accept registration'
      Anchors = [akRight, akBottom]
      Caption = 'Ok'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = BtnOkClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      Margin = 2
      NumGlyphs = 2
      Spacing = 2
    end
  end
  object SbxBagHdr: TScrollBox
    Left = 0
    Top = 41
    Width = 430
    Height = 211
    HorzScrollBar.Range = 360
    VertScrollBar.Range = 33
    VertScrollBar.Visible = False
    Align = alClient
    AutoScroll = False
    TabOrder = 2
    object PnlBagHdr: TPanel
      Left = 0
      Top = 0
      Width = 434
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object LblHdrDescr: TLabel
        Left = 8
        Top = 8
        Width = 65
        Height = 13
        AutoSize = False
        Caption = 'Description'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblHdrAmount: TLabel
        Left = 176
        Top = 8
        Width = 43
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Amount'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblHdrBag: TLabel
        Left = 304
        Top = 8
        Width = 113
        Height = 13
        AutoSize = False
        Caption = 'Sealbag'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblHdrQtyUnit: TLabel
        Left = 104
        Top = 8
        Width = 44
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Number'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object SbxBagDetail: TScrollBox
      Left = 0
      Top = 33
      Width = 434
      Height = 185
      HorzScrollBar.Visible = False
      VertScrollBar.Range = 164
      Align = alClient
      AutoScroll = False
      BorderStyle = bsNone
      TabOrder = 1
      object LblNoBags: TLabel
        Left = 15
        Top = 8
        Width = 318
        Height = 32
        Caption = 
          'No sealbags: the current registration includes no amounts which ' +
          'requires a sealbag'
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
  end
  object OvcCtlBag: TOvcController
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
    EntryOptions = [efoAutoSelect, efoBeepOnError]
    Epoch = 2000
    Left = 160
    Top = 8
  end
end
