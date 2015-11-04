inherited FrmCustOrdOfflineCA: TFrmCustOrdOfflineCA
  Left = 10
  Top = 148
  BorderStyle = bsSingle
  Caption = 'Offline creation customer order'
  ClientHeight = 523
  ClientWidth = 635
  KeyPreview = True
  PixelsPerInch = 96
  TextHeight = 13
  object StsBarInfo: TStatusBar
    Left = 0
    Top = 504
    Width = 635
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
  object ScrlbxGrid: TScrollBox
    Left = 0
    Top = 289
    Width = 635
    Height = 134
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 2
  end
  object PnlTitle: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 289
    Align = alTop
    BevelInner = bvRaised
    TabOrder = 0
    Visible = False
    object Label13: TLabel
      Left = 15
      Top = 258
      Width = 29
      Height = 13
      Caption = 'Article'
    end
    object Label14: TLabel
      Left = 79
      Top = 258
      Width = 53
      Height = 13
      Caption = 'Description'
    end
    object Label15: TLabel
      Left = 199
      Top = 258
      Width = 19
      Height = 13
      Caption = 'Unit'
    end
    object Label16: TLabel
      Left = 247
      Top = 258
      Width = 16
      Height = 13
      Caption = 'Qty'
    end
    object Label17: TLabel
      Left = 295
      Top = 258
      Width = 54
      Height = 13
      Caption = 'Price / Unit'
    end
    object Label18: TLabel
      Left = 375
      Top = 258
      Width = 24
      Height = 13
      Caption = 'Total'
    end
    object Label19: TLabel
      Left = 447
      Top = 256
      Width = 48
      Height = 26
      Alignment = taCenter
      Caption = 'Total after disc.'
      WordWrap = True
    end
    object GrbCustInfo: TGroupBox
      Left = 16
      Top = 8
      Width = 297
      Height = 153
      Caption = 'Customer Information'
      TabOrder = 0
      object Label2: TLabel
        Left = 8
        Top = 47
        Width = 63
        Height = 13
        Caption = 'Card number:'
      end
      object Label1: TLabel
        Left = 8
        Top = 73
        Width = 31
        Height = 13
        Caption = 'Name:'
      end
      object Label3: TLabel
        Left = 8
        Top = 97
        Width = 42
        Height = 13
        Caption = 'Channel:'
      end
      object Label4: TLabel
        Left = 8
        Top = 121
        Width = 94
        Height = 13
        Caption = 'Telephone Number:'
      end
      object LblCustNum: TLabel
        Left = 8
        Top = 24
        Width = 85
        Height = 13
        Caption = 'Customer number:'
      end
      object SvcCardNumber: TSvcMaskEdit
        Left = 128
        Top = 47
        Properties.EditMask = '000000000000'
        Properties.MaxLength = 0
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 1
        Text = '            '
        Width = 161
      end
      object SvcName: TSvcMaskEdit
        Left = 128
        Top = 73
        Properties.MaxLength = 30
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 2
        Width = 161
      end
      object SvcTelephone: TSvcMaskEdit
        Left = 128
        Top = 121
        Properties.MaxLength = 40
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 4
        Width = 161
      end
      object SvcChannel: TComboBox
        Left = 128
        Top = 97
        Width = 161
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        Items.Strings = (
          '1: Retail'
          '2: DC'
          '3: Trade'
          '4: DS')
      end
      object SvcMskEdtCustNum: TSvcMaskEdit
        Left = 128
        Top = 23
        Properties.EditMask = '##########'
        Properties.MaxLength = 0
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 0
        Text = '          '
        Width = 161
      end
    end
    object GrbDeliverInfo: TGroupBox
      Left = 320
      Top = 8
      Width = 297
      Height = 233
      Caption = 'Delivery information'
      TabOrder = 1
      object Label7: TLabel
        Left = 8
        Top = 18
        Width = 66
        Height = 13
        Caption = 'Delivery Area:'
      end
      object Label8: TLabel
        Left = 8
        Top = 44
        Width = 82
        Height = 13
        Caption = 'Delivery Address:'
      end
      object Label9: TLabel
        Left = 8
        Top = 68
        Width = 42
        Height = 13
        Caption = 'Category'
      end
      object Label10: TLabel
        Left = 8
        Top = 92
        Width = 64
        Height = 13
        Caption = 'Delivery Date'
      end
      object Label11: TLabel
        Left = 8
        Top = 117
        Width = 65
        Height = 13
        Caption = 'Delivery Type'
      end
      object SvcDeliveryArea: TSvcMaskEdit
        Left = 128
        Top = 15
        Properties.MaxLength = 40
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 0
        Width = 161
      end
      object SvcDeliveryAddress: TSvcMaskEdit
        Left = 128
        Top = 41
        Properties.MaxLength = 100
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 1
        Width = 161
      end
      object SvcCategory: TComboBox
        Left = 128
        Top = 65
        Width = 161
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        Items.Strings = (
          'ZAB: Vendor stock'
          'TAN: B&Q Stock')
      end
      object SvcTypeDelivery: TComboBox
        Left = 128
        Top = 111
        Width = 161
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 4
        Items.Strings = (
          '01: Customer pick-up store'
          '02: BnQ Delivery'
          '03: Vendor delivery'
          '04: DC Delivery (HK)'
          '05: Customer pick-up DC')
      end
      object SvcDatDelivery: TDateTimePicker
        Left = 128
        Top = 89
        Width = 89
        Height = 21
        Date = 39263.441035509260000000
        Time = 39263.441035509260000000
        TabOrder = 3
      end
    end
    object GrbAddInfo: TGroupBox
      Left = 16
      Top = 163
      Width = 297
      Height = 78
      Caption = 'Additional information'
      TabOrder = 2
      object Label5: TLabel
        Left = 8
        Top = 25
        Width = 98
        Height = 13
        Caption = 'Customer discount %'
      end
      object Label6: TLabel
        Left = 8
        Top = 49
        Width = 31
        Height = 13
        Caption = 'Notes:'
      end
      object SvcDiscount: TSvcLocalField
        Left = 127
        Top = 20
        Width = 58
        Height = 21
        Cursor = crIBeam
        DataType = pftReal
        CaretOvr.Shape = csBlock
        ControlCharColor = clRed
        DecimalPlaces = 2
        EFColors.Disabled.BackColor = clWindow
        EFColors.Disabled.TextColor = clGrayText
        EFColors.Error.BackColor = clRed
        EFColors.Error.TextColor = clBlack
        EFColors.Highlight.BackColor = clHighlight
        EFColors.Highlight.TextColor = clHighlightText
        Epoch = 0
        InitDateTime = False
        MaxLength = 4
        Options = [efoCaretToEnd]
        PictureMask = '####'
        TabOrder = 0
        OnChange = SvcDiscountChange
        LocalOptions = []
        Local = False
        RangeHigh = {00000000000059400000}
        RangeLow = {00000000000000000000}
      end
      object SvcMskEdtNotes: TSvcMaskEdit
        Left = 48
        Top = 44
        Properties.MaxLength = 40
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 1
        Width = 241
      end
    end
  end
  object PnlBottom: TPanel
    Left = 0
    Top = 423
    Width = 635
    Height = 81
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    object PnlBottomRight: TPanel
      Left = 371
      Top = 9
      Width = 263
      Height = 71
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BtnCancel: TBitBtn
        Left = 170
        Top = 11
        Width = 90
        Height = 25
        Hint = 'Cancel changes and close'
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 5
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = BtnCancelClick
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
      object BtnValidate: TBitBtn
        Left = 77
        Top = 11
        Width = 90
        Height = 25
        Hint = 'Validate and close'
        Caption = 'Validate'
        Default = True
        ModalResult = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = BtnValidateClick
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
    object PnlBottomLeft: TPanel
      Left = 1
      Top = 9
      Width = 370
      Height = 71
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object GroupBox1: TGroupBox
        Left = 9
        Top = 0
        Width = 291
        Height = 68
        TabOrder = 0
        object Label12: TLabel
          Left = 8
          Top = 42
          Width = 78
          Height = 13
          Caption = 'Deposit Amount:'
        end
        object Label20: TLabel
          Left = 8
          Top = 18
          Width = 88
          Height = 13
          Caption = 'Total C/O amount:'
        end
        object SvcDeposit: TSvcLocalField
          Left = 120
          Top = 40
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftDouble
          CaretOvr.Shape = csBlock
          ControlCharColor = clRed
          DecimalPlaces = 2
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
          PictureMask = '##########'
          TabOrder = 0
          LocalOptions = []
          Local = False
          RangeHigh = {73B2DBB9838916F2FE43}
          RangeLow = {73B2DBB9838916F2FEC3}
        end
        object SvcValTotal: TSvcLocalField
          Left = 120
          Top = 16
          Width = 130
          Height = 21
          Cursor = crIBeam
          DataType = pftDouble
          CaretOvr.Shape = csBlock
          ControlCharColor = clRed
          DecimalPlaces = 2
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Enabled = False
          Epoch = 0
          InitDateTime = False
          MaxLength = 10
          Options = [efoCaretToEnd]
          PictureMask = '##########'
          TabOrder = 1
          LocalOptions = []
          Local = False
          RangeHigh = {73B2DBB9838916F2FE43}
          RangeLow = {73B2DBB9838916F2FEC3}
        end
      end
    end
    object PnlBottomTop: TPanel
      Left = 1
      Top = 1
      Width = 633
      Height = 8
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
    end
  end
end
