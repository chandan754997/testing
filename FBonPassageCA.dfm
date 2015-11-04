object FrmBonPassageCA: TFrmBonPassageCA
  Left = 318
  Top = 345
  Width = 343
  Height = 224
  Caption = 'Create Order passing on cash register'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblMarchandise: TLabel
    Left = 16
    Top = 74
    Width = 71
    Height = 13
    Caption = 'lblMarchandise'
  end
  object lblCommande: TLabel
    Left = 16
    Top = 106
    Width = 63
    Height = 13
    Caption = 'lblCommande'
  end
  object StBrCdBonPassage: TStBarCode
    Left = 40
    Top = 56
    Width = 200
    Height = 75
    Color = clWhite
    ParentColor = False
    Visible = False
    AddCheckChar = True
    BarCodeType = bcEAN_13
    BarColor = clBlack
    BarToSpaceRatio = 1.000000000000000000
    BarWidth = 12.000000000000000000
    BearerBars = False
    Code = '123456789012'
    Code128Subset = csCodeA
    ShowCode = True
    ShowGuardChars = False
    TallGuardBars = False
  end
  object edtMarchandise: TEdit
    Left = 144
    Top = 72
    Width = 177
    Height = 21
    MaxLength = 40
    TabOrder = 0
    OnKeyPress = edtMarchandiseKeyPress
  end
  object edtCommande: TEdit
    Left = 144
    Top = 104
    Width = 177
    Height = 21
    MaxLength = 20
    TabOrder = 1
    OnKeyPress = edtCommandeKeyPress
  end
  object BtnCancel: TBitBtn
    Left = 176
    Top = 140
    Width = 146
    Height = 25
    Hint = 'Cancel changes and close'
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
    Left = 16
    Top = 140
    Width = 145
    Height = 25
    Hint = 'Save and close'
    Caption = 'OK'
    ModalResult = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
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
  object stsbrStatus: TStatusBar
    Left = 0
    Top = 178
    Width = 335
    Height = 19
    Panels = <>
  end
  object RGClientType: TRadioGroup
    Left = 16
    Top = 0
    Width = 305
    Height = 41
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Client en compte'
      'Bank Transfer')
    TabOrder = 5
  end
  object DscBonPassage: TDataSource
    DataSet = DmdFpnBonPassage.QryDetBonPassage
    Left = 24
    Top = 64
  end
end