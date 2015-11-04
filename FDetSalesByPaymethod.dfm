inherited FrmDetSalesByPayMethod: TFrmDetSalesByPayMethod
  Caption = 'Sales report by payment method'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Left = 72
    Top = 144
    Visible = False
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Left = 24
    Top = 360
    Visible = False
  end
  object LblTransDate: TLabel [4]
    Left = 248
    Top = 56
    Width = 83
    Height = 13
    Caption = 'Transaction date:'
  end
  object LblTransNumber: TLabel [5]
    Left = 248
    Top = 128
    Width = 97
    Height = 13
    Caption = 'Transaction number:'
  end
  object LblPayType: TLabel [6]
    Left = 248
    Top = 148
    Width = 64
    Height = 13
    Caption = 'Paymenttype:'
  end
  inherited PgsBarExec: TProgressBar
    TabOrder = 2
  end
  inherited PnlBtnsTop: TPanel
    TabOrder = 3
  end
  inherited GbxLogging: TGroupBox
    Left = -8
    Top = -282
    TabOrder = 4
    inherited LblDescrInfo: TLabel
      Left = 24
      Top = 48
    end
    inherited LblCntWarning: TLabel
      Left = 32
      Top = 24
    end
  end
  inherited DtmPckDayFrom: TDateTimePicker
    TabOrder = 5
  end
  inherited Panel1: TPanel
    Height = 288
    Caption = ''
    TabOrder = 0
    inherited ChkLbxOperator: TCheckListBox
      Height = 219
    end
    inherited BtnSelectAll: TBitBtn
      Top = 224
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 256
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Left = 96
    Top = 32
    TabOrder = 13
    Visible = False
  end
  inherited RbtDateDay: TRadioButton
    Left = 56
    Top = 152
    TabOrder = 15
    Visible = False
  end
  inherited RbtDateLoaded: TRadioButton
    Left = 48
    Top = 72
    TabOrder = 16
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker
    TabOrder = 6
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Left = 64
    Top = 144
    TabOrder = 17
    Visible = False
  end
  object Panel2: TPanel [18]
    Left = 256
    Top = 216
    Width = 225
    Height = 121
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 14
    DesignSize = (
      225
      121)
    object ChkLbxCheckout: TCheckListBox
      Left = 1
      Top = 1
      Width = 223
      Height = 49
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 0
    end
    object BtnSelectAllCheckout: TBitBtn
      Left = 8
      Top = 57
      Width = 209
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Select All'
      TabOrder = 1
      OnClick = BtnSelectAllClickCheckout
    end
    object BtnDESelectAllCheckout: TBitBtn
      Left = 8
      Top = 89
      Width = 209
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Deselect All'
      TabOrder = 2
      OnClick = BtnDESelectAllCheckoutClick
    end
  end
  object EdtCreditCard: TEdit [19]
    Left = 360
    Top = 166
    Width = 121
    Height = 21
    TabOrder = 10
  end
  object EdtTransNumber: TEdit [20]
    Left = 360
    Top = 120
    Width = 121
    Height = 21
    TabOrder = 7
  end
  object EdtCoupon: TEdit [21]
    Left = 360
    Top = 190
    Width = 121
    Height = 21
    TabOrder = 12
  end
  object CmbBxPayType: TComboBox [22]
    Left = 360
    Top = 144
    Width = 122
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 8
    OnKeyDown = CmbBxPayTypeKeyDown
  end
  object ChkBxCreditCard: TCheckBox [23]
    Left = 256
    Top = 168
    Width = 97
    Height = 17
    Caption = 'Credit card n'#176
    TabOrder = 9
    OnClick = ChkBxCreditCardClick
  end
  object ChkBxCoupon: TCheckBox [24]
    Left = 256
    Top = 192
    Width = 97
    Height = 17
    Caption = 'Coupon n'#176
    TabOrder = 11
    OnClick = ChkBxCouponClick
  end
  inherited TmrExec: TTimer
    Left = 128
    Top = 136
  end
  inherited ActLstApp: TActionList
    Left = 128
    Top = 104
  end
  inherited ImgLstApp: TImageList
    Left = 56
    Top = 104
  end
  inherited MnuApp: TMainMenu
    Left = 96
    Top = 152
  end
end
