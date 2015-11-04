inherited FrmTndRegCountSafeCA: TFrmTndRegCountSafeCA
  Left = 323
  Top = 156
  Width = 717
  Height = 543
  ActiveControl = SvcLFValMoneyPresInvent
  Caption = 'Count of the safe'
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object TLabel
    Left = 16
    Top = 16
    Width = 122
    Height = 13
    Caption = 'Money present in the safe'
  end
  object StsBarInfo: TStatusBar
    Left = 0
    Top = 497
    Width = 709
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 150
      end
      item
        Width = 50
      end>
  end
  object PnlBottom: TPanel
    Left = 0
    Top = 460
    Width = 709
    Height = 37
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      709
      37)
    object LblOperatorInfo: TLabel
      Left = 12
      Top = 8
      Width = 57
      Height = 13
      Caption = 'Checks By: '
    end
    object BtnAccept: TBitBtn
      Left = 517
      Top = 8
      Width = 90
      Height = 25
      Hint = 'Accept registration'
      Anchors = [akRight, akBottom]
      Caption = 'Accept'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = BtnAcceptClick
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
    object BtnCancel: TBitBtn
      Left = 613
      Top = 8
      Width = 90
      Height = 25
      Hint = 'Cancel changes and close'
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
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
    object BtnPrint: TBitBtn
      Left = 420
      Top = 8
      Width = 90
      Height = 25
      Caption = 'Print'
      TabOrder = 2
      OnClick = BtnPrintClick
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
      NumGlyphs = 2
    end
  end
  object PnlRegCount: TPanel
    Left = 0
    Top = 0
    Width = 709
    Height = 460
    Align = alClient
    TabOrder = 2
    object PnlHeader: TPanel
      Left = 1
      Top = 1
      Width = 707
      Height = 41
      Align = alTop
      TabOrder = 1
      object LblInventVal: TLabel
        Left = 552
        Top = 16
        Width = 129
        Height = 13
        AutoSize = False
        Caption = 'Inventory Values'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
      end
      object LblTheorVal: TLabel
        Left = 400
        Top = 16
        Width = 129
        Height = 13
        AutoSize = False
        Caption = 'Theoretical Values'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
      end
    end
    object SbxCntSafe: TScrollBox
      Left = 1
      Top = 42
      Width = 707
      Height = 417
      Align = alClient
      BorderStyle = bsNone
      TabOrder = 0
      object PnlRegCountMoney: TPanel
        Left = 0
        Top = 0
        Width = 707
        Height = 122
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object LblMoneyPresent: TLabel
          Left = 12
          Top = 12
          Width = 122
          Height = 13
          Caption = 'Money present in the safe'
        end
        object LblInitPayin: TLabel
          Left = 12
          Top = 36
          Width = 159
          Height = 13
          Caption = 'Cash advance present in the safe'
        end
        object LblCentralSafe: TLabel
          Left = 12
          Top = 60
          Width = 157
          Height = 13
          Caption = 'Money present in the central safe'
        end
        object LblTotalMoneySafe: TLabel
          Left = 12
          Top = 92
          Width = 193
          Height = 13
          AutoSize = False
          Caption = 'TOTAL MONEY SAFE :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold, fsUnderline]
          ParentFont = False
        end
        object SvcLFValMoneyPresTheor: TSvcLocalField
          Left = 400
          Top = 12
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftDouble
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
          ControlCharColor = clRed
          DecimalPlaces = 0
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Enabled = False
          Epoch = 0
          InitDateTime = False
          MaxLength = 16
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = 'iiiiiiiiiiiii.ii'
          TabOrder = 0
          OnChange = SvcLFValMoneyPresTheorChange
          LocalOptions = [lfoLimitValue]
          Local = True
          RangeHigh = {73B2DBB9838916F2FE43}
          RangeLow = {73B2DBB9838916F2FEC3}
        end
        object SvcLFValMoneyPresInvent: TSvcLocalField
          Left = 552
          Top = 12
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftDouble
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
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
          MaxLength = 16
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = 'iiiiiiiiiiiii.ii'
          TabOrder = 1
          OnChange = SvcLFMoneySafeChange
          OnExit = SvcLFValMoneyPresInventExit
          OnKeyDown = SvcLFKeyDown
          LocalOptions = [lfoLimitValue]
          Local = True
          RangeHigh = {73B2DBB9838916F2FE43}
          RangeLow = {73B2DBB9838916F2FEC3}
        end
        object SvcLFInitPayinTheor: TSvcLocalField
          Left = 400
          Top = 36
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftDouble
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
          ControlCharColor = clRed
          DecimalPlaces = 0
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Enabled = False
          Epoch = 0
          InitDateTime = False
          MaxLength = 16
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = 'iiiiiiiiiiiii.ii'
          TabOrder = 2
          OnChange = SvcLFValMoneyPresTheorChange
          LocalOptions = [lfoLimitValue]
          Local = True
          RangeHigh = {73B2DBB9838916F2FE43}
          RangeLow = {73B2DBB9838916F2FEC3}
        end
        object SvcLFInitPayinInvent: TSvcLocalField
          Left = 552
          Top = 36
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftDouble
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
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
          MaxLength = 16
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = 'iiiiiiiiiiiii.ii'
          TabOrder = 3
          OnChange = SvcLFMoneySafeChange
          OnExit = SvcLFInitPayinInventExit
          OnKeyDown = SvcLFKeyDown
          LocalOptions = [lfoLimitValue]
          Local = True
          RangeHigh = {73B2DBB9838916F2FE43}
          RangeLow = {73B2DBB9838916F2FEC3}
        end
        object SvcLFMoneySafeTheor: TSvcLocalField
          Left = 400
          Top = 60
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftDouble
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
          ControlCharColor = clRed
          DecimalPlaces = 0
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Enabled = False
          Epoch = 0
          InitDateTime = False
          MaxLength = 16
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = 'iiiiiiiiiiiii.ii'
          TabOrder = 4
          OnChange = SvcLFValMoneyPresTheorChange
          LocalOptions = [lfoLimitValue]
          Local = True
          RangeHigh = {73B2DBB9838916F2FE43}
          RangeLow = {73B2DBB9838916F2FEC3}
        end
        object SvcLFMoneySafeInvent: TSvcLocalField
          Left = 552
          Top = 60
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftDouble
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
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
          MaxLength = 16
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = 'iiiiiiiiiiiii.ii'
          TabOrder = 5
          OnChange = SvcLFMoneySafeChange
          OnExit = SvcLFMoneySafeInventExit
          OnKeyDown = SvcLFKeyDown
          LocalOptions = [lfoLimitValue]
          Local = True
          RangeHigh = {73B2DBB9838916F2FE43}
          RangeLow = {73B2DBB9838916F2FEC3}
        end
        object SvcLFTotMoneySafeTheor: TSvcLocalField
          Left = 400
          Top = 92
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftDouble
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
          ControlCharColor = clRed
          DecimalPlaces = 0
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Enabled = False
          Epoch = 0
          InitDateTime = False
          MaxLength = 16
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = 'iiiiiiiiiiiii.ii'
          TabOrder = 6
          LocalOptions = [lfoLimitValue]
          Local = True
          RangeHigh = {73B2DBB9838916F2FE43}
          RangeLow = {73B2DBB9838916F2FEC3}
        end
        object SvcLFTotMoneySafeInvent: TSvcLocalField
          Left = 552
          Top = 92
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftDouble
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
          ControlCharColor = clRed
          DecimalPlaces = 0
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Enabled = False
          Epoch = 0
          InitDateTime = False
          MaxLength = 16
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = 'iiiiiiiiiiiii.ii'
          TabOrder = 7
          OnExit = SvcLFTotMoneySafeInventExit
          OnKeyDown = SvcLFKeyDown
          LocalOptions = [lfoLimitValue]
          Local = True
          RangeHigh = {73B2DBB9838916F2FE43}
          RangeLow = {73B2DBB9838916F2FEC3}
        end
      end
      object PnlRegCountBags: TPanel
        Left = 0
        Top = 122
        Width = 707
        Height = 64
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        object LblCntBagsMoney: TLabel
          Left = 12
          Top = 12
          Width = 133
          Height = 13
          Caption = 'Quantity sealed bags money'
        end
        object LblCntBagsCheque: TLabel
          Left = 12
          Top = 36
          Width = 138
          Height = 13
          Caption = 'Quantity sealed bags cheque'
        end
        object SvcLFQtySldBagsMoneyInvent: TSvcLocalField
          Left = 552
          Top = 12
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftInteger
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
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
          MaxLength = 6
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = 'iiiiii'
          TabOrder = 0
          OnKeyDown = SvcLFKeyDown
          LocalOptions = [lfoLimitValue]
          Local = True
          RangeHigh = {FF7F0000000000000000}
          RangeLow = {00000000000000000000}
        end
        object SvcLFQtySldBagsChequeInvent: TSvcLocalField
          Left = 552
          Top = 36
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftInteger
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
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
          MaxLength = 6
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = 'iiiiii'
          TabOrder = 1
          OnKeyDown = SvcLFKeyDown
          LocalOptions = [lfoLimitValue]
          Local = True
          RangeHigh = {FF7F0000000000000000}
          RangeLow = {00000000000000000000}
        end
        object SvcLFQtySldBagsMoneyTheor: TSvcLocalField
          Left = 400
          Top = 12
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftInteger
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
          ControlCharColor = clRed
          DecimalPlaces = 0
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Enabled = False
          Epoch = 0
          InitDateTime = False
          MaxLength = 6
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = 'iiiiii'
          TabOrder = 2
          LocalOptions = [lfoLimitValue]
          Local = True
          RangeHigh = {FF7F0000000000000000}
          RangeLow = {0080FFFF000000000000}
        end
        object SvcLFQtySldBagsChequeTheor: TSvcLocalField
          Left = 400
          Top = 36
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftInteger
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
          ControlCharColor = clRed
          DecimalPlaces = 0
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Enabled = False
          Epoch = 0
          InitDateTime = False
          MaxLength = 6
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = 'iiiiii'
          TabOrder = 3
          LocalOptions = [lfoLimitValue]
          Local = True
          RangeHigh = {FF7F0000000000000000}
          RangeLow = {0080FFFF000000000000}
        end
      end
      object PnlRegCollBagsMoney1: TPanel
        Left = 0
        Top = 186
        Width = 707
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
        object LblCollBagsMoney1: TLabel
          Left = 12
          Top = 12
          Width = 212
          Height = 13
          Caption = 'Sealed money collection bags : collection J-1'
        end
        object ChkbxMoneyInvent1: TCheckBox
          Left = 552
          Top = 12
          Width = 97
          Height = 17
          TabOrder = 0
        end
        object SvcLFCollBagsMoneyTheor1: TSvcLocalField
          Left = 400
          Top = 12
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftString
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
          ControlCharColor = clRed
          DecimalPlaces = 0
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Enabled = False
          Epoch = 0
          InitDateTime = False
          MaxLength = 13
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = 'XXXXXXXXXXXXX'
          TabOrder = 1
          LocalOptions = [lfoLimitValue]
          Local = True
        end
      end
      object PnlRegCollBagsCheques1: TPanel
        Left = 0
        Top = 222
        Width = 707
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 3
        object LblCollBagsCheques1: TLabel
          Left = 12
          Top = 12
          Width = 222
          Height = 13
          Caption = 'Sealed cheques collection bags : collection J-1'
        end
        object ChkbxChequesInvent1: TCheckBox
          Left = 552
          Top = 12
          Width = 97
          Height = 17
          TabOrder = 0
        end
        object SvcLFCollBagsChequesTheor1: TSvcLocalField
          Left = 400
          Top = 12
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftString
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
          ControlCharColor = clRed
          DecimalPlaces = 0
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Enabled = False
          Epoch = 0
          InitDateTime = False
          MaxLength = 13
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = 'XXXXXXXXXXXXX'
          TabOrder = 1
          LocalOptions = [lfoLimitValue]
          Local = True
        end
      end
      object PnlRegNumBagKeys: TPanel
        Left = 0
        Top = 298
        Width = 707
        Height = 64
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 5
        object LblKeySupervisor: TLabel
          Left = 12
          Top = 12
          Width = 129
          Height = 13
          Caption = 'Number bag supervisor key'
        end
        object LblKeyDoubleDrawer: TLabel
          Left = 12
          Top = 36
          Width = 148
          Height = 13
          Caption = 'Number bag key double drawer'
        end
        object SvcLFKeySupervisorTheor: TSvcLocalField
          Left = 400
          Top = 12
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftString
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
          ControlCharColor = clRed
          DecimalPlaces = 0
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Enabled = False
          Epoch = 0
          InitDateTime = False
          MaxLength = 13
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = '9999999999999'
          TabOrder = 0
          LocalOptions = [lfoLimitValue]
          Local = True
        end
        object SvcLFKeySupervisorInvent: TSvcLocalField
          Left = 552
          Top = 12
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftString
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
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
          MaxLength = 13
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = '9999999999999'
          TabOrder = 1
          OnExit = SvcLFKeySupervisorInventExit
          OnKeyDown = SvcLFKeyDown
          LocalOptions = [lfoLimitValue]
          Local = True
        end
        object SvcLFKeyDoubleDrawerInvent: TSvcLocalField
          Left = 552
          Top = 36
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftString
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
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
          MaxLength = 13
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = '9999999999999'
          TabOrder = 2
          OnExit = SvcLFKeyDoubleDrawerInventExit
          OnKeyDown = SvcLFKeyDown
          LocalOptions = [lfoLimitValue]
          Local = True
        end
        object SvcLFKeyDoubleDrawerTheor: TSvcLocalField
          Left = 400
          Top = 36
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftString
          CaretOvr.Shape = csBlock
          Controller = OvcCtrlDetail
          ControlCharColor = clRed
          DecimalPlaces = 0
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Enabled = False
          Epoch = 0
          InitDateTime = False
          MaxLength = 13
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = '9999999999999'
          TabOrder = 3
          LocalOptions = [lfoLimitValue]
          Local = True
        end
      end
      object PnlGiftCoupNotStarted: TPanel
        Left = 0
        Top = 258
        Width = 707
        Height = 40
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 4
        object LblGCBooksNotStarted: TLabel
          Left = 12
          Top = 12
          Width = 177
          Height = 13
          Caption = 'Pocketbooks gift coupons not started'
        end
        object SvcMEGCBooksNotStartedTheor: TSvcMaskEdit
          Left = 400
          Top = 12
          TabStop = False
          Enabled = False
          Properties.Alignment.Horz = taRightJustify
          Properties.MaxLength = 0
          Properties.UseLeftAlignmentOnEditing = False
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 1
          Width = 130
        end
        object SvcMEGCBooksNotStartedInvent: TSvcMaskEdit
          Left = 552
          Top = 12
          Properties.Alignment.Horz = taRightJustify
          Properties.MaxLength = 0
          Properties.UseLeftAlignmentOnEditing = False
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 0
          OnKeyDown = SvcMEKeyDown
          Width = 130
        end
      end
      object PnlTransKeys: TPanel
        Left = 0
        Top = 362
        Width = 707
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 6
        object LblTransKeys: TLabel
          Left = 12
          Top = 12
          Width = 61
          Height = 13
          Caption = 'Keys transfer'
        end
        object CbxKeysTransfered: TCheckBox
          Left = 552
          Top = 12
          Width = 97
          Height = 17
          TabOrder = 0
        end
      end
    end
  end
  object OvcCtrlDetail: TOvcController
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
    Left = 72
    Top = 8
  end
end
