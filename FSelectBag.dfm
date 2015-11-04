object FrmSelectBag: TFrmSelectBag
  Left = 0
  Top = 0
  Width = 327
  Height = 342
  Caption = 'Collector Bag'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PnlTop: TPanel
    Left = 0
    Top = 0
    Width = 311
    Height = 41
    Align = alTop
    TabOrder = 1
    object LblOperator: TLabel
      Left = 24
      Top = 14
      Width = 44
      Height = 13
      Alignment = taCenter
      Caption = 'Operator'
    end
    object SvcLFOperatorName: TSvcLocalField
      Left = 80
      Top = 8
      Width = 209
      Height = 25
      Cursor = crIBeam
      DataType = pftString
      AutoSize = False
      CaretOvr.Shape = csBlock
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
      MaxLength = 52
      Options = []
      PictureMask = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
      TabOrder = 0
      LocalOptions = []
      Local = True
    end
  end
  object PnlBottom: TPanel
    Left = 0
    Top = 272
    Width = 311
    Height = 32
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      311
      32)
    object BtnAccept: TBitBtn
      Left = 117
      Top = 3
      Width = 90
      Height = 25
      Hint = 'Accept registration'
      Anchors = [akRight, akBottom]
      Caption = 'Accept'
      ModalResult = 1
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
      Left = 213
      Top = 3
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
  end
  object RdGrpSealbags: TRadioGroup
    Left = 0
    Top = 41
    Width = 311
    Height = 231
    Caption = 'Collector Bag'
    TabOrder = 0
  end
  object QryBagInfo: TQuery
    DatabaseName = 'DBFlexPointUpdates'
    Left = 16
    Top = 64
  end
end
