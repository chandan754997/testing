inherited FrmPrmOrderChangeMoneyCA: TFrmPrmOrderChangeMoneyCA
  Left = 0
  Top = 0
  Width = 542
  Height = 569
  Caption = 'Parameters Order change money'
  Position = poDesigned
  OnClick = BtnOKClick
  PixelsPerInch = 96
  TextHeight = 13
  inherited StsBarExec: TStatusBar
    Top = 490
    Width = 534
    Height = 17
    Enabled = False
    Visible = False
  end
  inherited PgsBarExec: TProgressBar
    Top = 507
    Width = 534
    Enabled = False
  end
  inherited PnlBtnsTop: TPanel
    Width = 534
    Visible = False
    inherited BtnStart: TSpeedButton
      Left = 200
      Visible = False
    end
    inherited BtnExit: TSpeedButton
      Left = 468
    end
    inherited BtnStop: TSpeedButton
      Left = 104
    end
    object BtnActivate: TSpeedButton
      Left = 0
      Top = 2
      Width = 60
      Height = 36
      Action = ActSave
      AllowAllUp = True
      Flat = True
      Glyph.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        0800000000000001000000000000000000000001000000010000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A600F0FBFF00A4A0A000808080000000FF0000FF000000FFFF00FF000000FF00
        FF00FFFF0000FFFFFF0000000000000080000080000000808000800000008000
        800080800000C0C0C000C0DCC000F0CAA600F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A600F0FBFF00A4A0A000808080000000FF0000FF000000FFFF00FF000000FF00
        FF00FFFF0000FFFFFF0000000000000080000080000000808000800000008000
        800080800000C0C0C000C0DCC000F0CAA600F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A600F0FBFF00A4A0A000808080000000FF0000FF000000FFFF00FF000000FF00
        FF00FFFF0000FFFFFF0000000000000080000080000000808000800000008000
        800080800000C0C0C000C0DCC000F0CAA600F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A600F0FBFF00A4A0A000808080000000FF0000FF000000FFFF00FF000000FF00
        FF00FFFF0000FFFFFF0000000000000080000080000000808000800000008000
        800080800000C0C0C000C0DCC000F0CAA600F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A600F0FBFF00A4A0A000808080000000FF0000FF000000FFFF00FF000000FF00
        FF00FFFF0000FFFFFF0000000000000080000080000000808000800000008000
        800080800000C0C0C000C0DCC000F0CAA600F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A600F0FBFF00A4A0A000808080000000FF0000FF000000FFFF00FF000000FF00
        FF00FFFF0000FFFFFF0000000000000080000080000000808000800000008000
        800080800000C0C0C000C0DCC000F0CAA600F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
        800000800000008080008000000080008000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00111111111111
        1111111111111111111111111111111111111111111111111111111111111111
        111111111111111111111111110D0D0D0D0D0D0D0D01111111111111110D0D0D
        0D0D0D0D0D0D111111111111110D0D0D0D0D0D0D0D0D111111111111110D0D0D
        0D0D0D0D0D0D111111111111110D0D0D0D0D0D0D0D0D111111111111110D0D0D
        0D0D0D0D0D0D111111111111110D0D0D0D0D0D0D0D0D111111111111110D0D0D
        0D0D0D0D0D0D111111111111110D0D0D0D0D0D0D0D0D11111111111111111111
        1111111111111111111111111111111111111111111111111111111111111111
        1111111111111111111111111111111111111111111111111111}
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = False
      Spacing = 2
      Visible = False
    end
  end
  inherited GbxLogging: TGroupBox
    Left = 264
    Top = -169
  end
  object PgeCtlPrmOrderChangeMoney: TPageControl [4]
    Left = 0
    Top = 41
    Width = 534
    Height = 417
    ActivePage = TabShtPrmOrderChangeMoney
    Align = alClient
    HotTrack = True
    TabOrder = 4
    object TabShtPrmOrderChangeMoney: TTabSheet
      Caption = 'Parameters Order change money'
      ImageIndex = 2
      object SbxPrmOrderChangeMoney: TScrollBox
        Left = 0
        Top = 0
        Width = 526
        Height = 389
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 0
        object GbxPrmBankData: TGroupBox
          Left = 0
          Top = 0
          Width = 521
          Height = 153
          Caption = 'Bank Data'
          TabOrder = 0
          object LblNameBank: TLabel
            Left = 8
            Top = 24
            Width = 31
            Height = 13
            Caption = 'Name:'
          end
          object LblAddress: TLabel
            Left = 8
            Top = 56
            Width = 41
            Height = 13
            Caption = 'Address:'
          end
          object LblCity: TLabel
            Left = 8
            Top = 88
            Width = 20
            Height = 13
            Caption = 'City:'
          end
          object LblBankAccount: TLabel
            Left = 8
            Top = 120
            Width = 70
            Height = 13
            Caption = 'Bank account:'
          end
          object SvcMENameBank: TSvcMaskEdit
            Left = 152
            Top = 24
            Properties.MaxLength = 0
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 0
            Width = 361
          end
          object SvcMEAddress: TSvcMaskEdit
            Left = 152
            Top = 56
            Properties.MaxLength = 0
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 1
            Width = 361
          end
          object SvcMECity: TSvcMaskEdit
            Left = 152
            Top = 88
            Properties.MaxLength = 0
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 2
            Width = 361
          end
          object SvcMEBankAccount: TSvcMaskEdit
            Left = 152
            Top = 120
            Properties.MaxLength = 0
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 3
            Width = 361
          end
        end
        object GbxSecurity: TGroupBox
          Left = 0
          Top = 160
          Width = 521
          Height = 57
          Caption = 'Security company'
          TabOrder = 1
          object LblSecurity: TLabel
            Left = 8
            Top = 24
            Width = 31
            Height = 13
            Caption = 'Name:'
          end
          object SvcMESecurity: TSvcMaskEdit
            Left = 152
            Top = 24
            Properties.MaxLength = 0
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 0
            Width = 361
          end
        end
        object GbxResponsible: TGroupBox
          Left = 0
          Top = 226
          Width = 521
          Height = 151
          Caption = 'Responsible persons'
          TabOrder = 2
          object LblNameRespPerson1: TLabel
            Left = 8
            Top = 24
            Width = 75
            Height = 13
            Caption = 'Name person 1:'
          end
          object LblNameRespPerson2: TLabel
            Left = 8
            Top = 88
            Width = 75
            Height = 13
            Caption = 'Name person 2:'
          end
          object LblDNIRespPerson1: TLabel
            Left = 8
            Top = 56
            Width = 104
            Height = 13
            Caption = 'DNI number person 1:'
          end
          object LblDNIRespPerson2: TLabel
            Left = 8
            Top = 120
            Width = 104
            Height = 13
            Caption = 'DNI number person 2:'
          end
          object SvcLFDNIRespPerson1: TSvcLocalField
            Left = 152
            Top = 56
            Width = 69
            Height = 21
            Cursor = crIBeam
            DataType = pftString
            AutoSize = False
            CaretOvr.Shape = csBlock
            Controller = OvcCtlPrm
            ControlCharColor = clRed
            DecimalPlaces = 0
            EFColors.Disabled.BackColor = clWindow
            EFColors.Disabled.TextColor = clGrayText
            EFColors.Error.BackColor = clRed
            EFColors.Error.TextColor = clBlack
            EFColors.Highlight.BackColor = clHighlight
            EFColors.Highlight.TextColor = clHighlightText
            Epoch = 0
            InitDateTime = False
            MaxLength = 10
            Options = [efoCaretToEnd]
            PictureMask = '!!!!!!!!!!'
            TabOrder = 1
            OnUserValidation = SvcLFDNIRespPersonUserValidation
            LocalOptions = []
            Local = False
          end
          object SvcLFDNIRespPerson2: TSvcLocalField
            Left = 152
            Top = 120
            Width = 69
            Height = 21
            Cursor = crIBeam
            DataType = pftString
            AutoSize = False
            CaretOvr.Shape = csBlock
            Controller = OvcCtlPrm
            ControlCharColor = clRed
            DecimalPlaces = 0
            EFColors.Disabled.BackColor = clWindow
            EFColors.Disabled.TextColor = clGrayText
            EFColors.Error.BackColor = clRed
            EFColors.Error.TextColor = clBlack
            EFColors.Highlight.BackColor = clHighlight
            EFColors.Highlight.TextColor = clHighlightText
            Epoch = 0
            InitDateTime = False
            MaxLength = 10
            Options = [efoCaretToEnd]
            PictureMask = '!!!!!!!!!!'
            TabOrder = 3
            OnUserValidation = SvcLFDNIRespPersonUserValidation
            LocalOptions = []
            Local = False
          end
          object SvcMENameRespPerson1: TSvcMaskEdit
            Left = 152
            Top = 24
            Properties.MaxLength = 0
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 0
            Width = 361
          end
          object SvcMENameRespPerson2: TSvcMaskEdit
            Left = 152
            Top = 88
            Properties.MaxLength = 0
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 2
            Width = 361
          end
        end
      end
    end
  end
  object PnlBottom: TPanel [5]
    Left = 0
    Top = 458
    Width = 534
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 5
    object PnlBottomRight: TPanel
      Left = 346
      Top = 0
      Width = 188
      Height = 32
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
    end
    object BtnCancel: TBitBtn
      Left = 440
      Top = 4
      Width = 90
      Height = 25
      Hint = 'Cancel changes and close'
      Action = ActExit
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 5
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033338833333333333333333F333333333333
        0000333911833333983333333388F333333F3333000033391118333911833333
        38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
        911118111118333338F3338F833338F3000033333911111111833333338F3338
        3333F8330000333333911111183333333338F333333F83330000333333311111
        8333333333338F3333383333000033333339111183333333333338F333833333
        00003333339111118333333333333833338F3333000033333911181118333333
        33338333338F333300003333911183911183333333383338F338F33300003333
        9118333911183333338F33838F338F33000033333913333391113333338FF833
        38F338F300003333333333333919333333388333338FFF830000333333333333
        3333333333333333333888330000333333333333333333333333333333333333
        0000}
      Margin = 2
      NumGlyphs = 2
      Spacing = 2
    end
    object BtnOK: TBitBtn
      Left = 344
      Top = 4
      Width = 90
      Height = 25
      Hint = 'Save and close'
      Caption = 'OK'
      Default = True
      ModalResult = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = BtnOKClick
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
  inherited SvcExHApp: TSvcExceptHandler
    Left = 168
  end
  inherited SvcAppInstCheck: TSvcAppInstance
    Left = 72
    Top = 0
  end
  inherited TmrExec: TTimer
    Left = 264
    Top = 8
  end
  inherited ActLstApp: TActionList
    Left = 304
    Top = 8
    inherited ActStartExec: TAction
      Caption = '&Save'
    end
    object ActSave: TAction
      Category = 'Execute'
      Caption = '&Save'
    end
  end
  inherited ImgLstApp: TImageList
    Left = 336
    Top = 8
  end
  inherited MnuApp: TMainMenu
    Top = 16
    inherited MniFile: TMenuItem
      inherited MniStart: TMenuItem
        Visible = False
      end
    end
    inherited MniHelp: TMenuItem
      inherited MniLogfile: TMenuItem
        Visible = False
      end
    end
  end
  object OvcCtlPrm: TOvcController
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
    Epoch = 2000
    OnIsSpecialControl = OvcCtlPrmIsSpecialControl
    Left = 240
    Top = 32
  end
end
