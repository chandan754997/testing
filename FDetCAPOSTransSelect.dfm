inherited FrmDetCAPOSTransSelect: TFrmDetCAPOSTransSelect
  Width = 449
  Height = 284
  Caption = 'Select a ticket'
  PixelsPerInch = 96
  TextHeight = 13
  object PnlBottom: TPanel
    Left = 0
    Top = 223
    Width = 441
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object PnlBottomRight: TPanel
      Left = 253
      Top = 0
      Width = 188
      Height = 32
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object BtnOK: TBitBtn
        Left = 0
        Top = 4
        Width = 90
        Height = 25
        Hint = 'Save and close'
        Caption = 'OK'
        Default = True
        ModalResult = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
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
        Left = 96
        Top = 4
        Width = 90
        Height = 25
        Hint = 'Cancel changes and close'
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 5
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
    object PnlBtnAdd: TPanel
      Left = 157
      Top = 0
      Width = 96
      Height = 32
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
    end
  end
  object PnlInfo: TPanel
    Left = 0
    Top = 0
    Width = 441
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
  end
  object PnlBody: TPanel
    Left = 0
    Top = 25
    Width = 441
    Height = 198
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object DBGrdTicket: TDBGrid
      Left = 0
      Top = 0
      Width = 441
      Height = 198
      Align = alClient
      DataSource = DscPOSTrans
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = DBGrdTicketDblClick
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
          FieldName = 'DatTransBegin'
          Title.Caption = 'Date/time'
          Visible = True
        end
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'ValInclVAT'
          Title.Caption = 'Amount'
          Visible = True
        end>
    end
  end
  object DscPOSTrans: TDataSource
    Left = 48
    Top = 16
  end
end
