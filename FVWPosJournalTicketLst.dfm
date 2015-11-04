object frmFVWPosJournalTicket: TfrmFVWPosJournalTicket
  Left = 0
  Top = 0
  Width = 532
  Height = 257
  Caption = 'Ticket list'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PnlBtnsTop: TPanel
    Left = 0
    Top = 0
    Width = 524
    Height = 44
    Align = alTop
    TabOrder = 0
    DesignSize = (
      524
      44)
    object BtnClose: TSpeedButton
      Left = 448
      Top = 3
      Width = 59
      Height = 36
      AllowAllUp = True
      Anchors = [akTop, akRight]
      Caption = '&Close'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
        03333377777777777F333301111111110333337F333333337F33330111111111
        0333337F333333337F333301111111110333337F333333337F33330111111111
        0333337F333333337F333301111111110333337F333333337F33330111111111
        0333337F3333333F7F333301111111B10333337F333333737F33330111111111
        0333337F333333337F333301111111110333337F33FFFFF37F3333011EEEEE11
        0333337F377777F37F3333011EEEEE110333337F37FFF7F37F3333011EEEEE11
        0333337F377777337F333301111111110333337F333333337F33330111111111
        0333337FFFFFFFFF7F3333000000000003333377777777777333}
      Layout = blGlyphTop
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = False
      Spacing = 2
      OnClick = BtnCloseClick
    end
    object LblCurTicketNumber: TLabel
      Left = 286
      Top = 10
      Width = 28
      Height = 24
      Caption = '##'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Comic Sans MS'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
  end
  object PnlTicketList: TPanel
    Left = 0
    Top = 44
    Width = 524
    Height = 186
    Align = alClient
    TabOrder = 1
    object DBGrdTicket: TDBGrid
      Left = 1
      Top = 1
      Width = 408
      Height = 184
      Align = alLeft
      DataSource = DscTicket
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'IdtPOSTransaction'
          Title.Caption = 'Ticket number'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'IdtCheckout'
          Title.Caption = 'Cashdesk number'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CodTrans'
          Title.Caption = 'Transaction'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DatTransBegin'
          Title.Caption = 'Date/Time'
          Visible = True
        end>
    end
    object BtnDelTicket: TBitBtn
      Left = 420
      Top = 7
      Width = 97
      Height = 25
      Hint = 'Remove selected ticket'
      Caption = 'Remove'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
      OnClick = BtnDelTicketClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333FF3333333333333003333333333333377F33333333333307
        733333FFF333337773333C003333307733333777FF333777FFFFC0CC03330770
        000077777FF377777777C033C03077FFFFF077FF77F777FFFFF7CC00000F7777
        777077777777777777773CCCCC00000000003777777777777777333330030FFF
        FFF03333F77F7F3FF3F7333C0C030F00F0F03337777F7F77373733C03C030FFF
        FFF03377F77F7F3F333733C03C030F0FFFF03377F7737F733FF733C000330FFF
        0000337777F37F3F7777333CCC330F0F0FF0333777337F737F37333333330FFF
        0F03333333337FFF7F7333333333000000333333333377777733}
      Margin = 2
      NumGlyphs = 2
      Spacing = 2
    end
    object BtnRemoveAll: TBitBtn
      Left = 420
      Top = 40
      Width = 97
      Height = 25
      Hint = 'Remove selected ticket'
      Caption = 'Remove all'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      OnClick = BtnRemoveAllClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333FF3333333333333003333333333333377F33333333333307
        733333FFF333337773333C003333307733333777FF333777FFFFC0CC03330770
        000077777FF377777777C033C03077FFFFF077FF77F777FFFFF7CC00000F7777
        777077777777777777773CCCCC00000000003777777777777777333330030FFF
        FFF03333F77F7F3FF3F7333C0C030F00F0F03337777F7F77373733C03C030FFF
        FFF03377F77F7F3F333733C03C030F0FFFF03377F7737F733FF733C000330FFF
        0000337777F37F3F7777333CCC330F0F0FF0333777337F737F37333333330FFF
        0F03333333337FFF7F7333333333000000333333333377777733}
      Margin = 2
      NumGlyphs = 2
      Spacing = 2
    end
  end
  object DxMDTicket: TdxMemData
    Indexes = <>
    Persistent.Data = {
      5665728FC2F5285C8FFE3F050000000800000015001200496474504F53547261
      6E73616374696F6E000800000015000C00496474436865636B6F757400020000
      0002000900436F645472616E7300080000000B000E004461745472616E734265
      67696E00020000000200090054636B745479706500}
    SortOptions = []
    Left = 24
    Top = 104
    object NumTicket: TLargeintField
      FieldName = 'IdtPOSTransaction'
    end
    object NumCashD: TLargeintField
      FieldName = 'IdtCheckout'
    end
    object CodTrans: TSmallintField
      FieldName = 'CodTrans'
    end
    object DatTicket: TDateTimeField
      FieldName = 'DatTransBegin'
    end
    object TcktType: TSmallintField
      DisplayWidth = 2
      FieldName = 'TcktType'
    end
  end
  object DscTicket: TDataSource
    DataSet = DxMDTicket
    Left = 88
    Top = 104
  end
end
