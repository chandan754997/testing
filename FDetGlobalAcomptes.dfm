inherited FrmDetGlobalAcomptes: TFrmDetGlobalAcomptes
  Width = 260
  Height = 404
  Caption = 'Report global down payments'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded
    Left = 40
    Top = 96
  end
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Left = 40
    Top = 168
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Left = 40
    Top = 120
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Left = 40
    Top = 192
  end
  inherited StsBarExec: TStatusBar
    Top = 358
    Width = 252
    Visible = False
  end
  inherited PgsBarExec: TProgressBar
    Top = 342
    Width = 252
  end
  inherited PnlBtnsTop: TPanel
    Width = 252
    inherited BtnExit: TSpeedButton
      Left = 186
    end
  end
  inherited GbxLogging: TGroupBox
    Left = 440
    Top = 316
    Width = 241
    Height = 96
  end
  inherited DtmPckDayFrom: TDateTimePicker
    Left = 120
    Top = 88
  end
  inherited Panel1: TPanel
    Left = 352
    Top = 408
    Height = 0
    Visible = False
    inherited ChkLbxOperator: TCheckListBox
      Height = 0
      ParentFont = False
    end
    inherited BtnSelectAll: TBitBtn
      Top = -64
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = -32
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Left = 120
    Top = 160
  end
  inherited RbtDateDay: TRadioButton
    Left = 16
    Top = 72
  end
  inherited RbtDateLoaded: TRadioButton
    Left = 16
    Top = 144
  end
  inherited DtmPckDayTo: TDateTimePicker
    Left = 120
    Top = 112
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Left = 120
    Top = 184
  end
  object GbxDownPayments: TGroupBox [15]
    Left = 0
    Top = 216
    Width = 249
    Height = 137
    TabOrder = 11
    object RdbtnNotPayed: TRadioButton
      Left = 16
      Top = 16
      Width = 113
      Height = 17
      Caption = 'Not payed'
      TabOrder = 0
      OnClick = ChangeStatusDownPaymentNr
    end
    object RdbtnAll: TRadioButton
      Left = 16
      Top = 48
      Width = 113
      Height = 17
      Caption = 'All'
      TabOrder = 1
      OnClick = ChangeStatusDownPaymentNr
    end
    object RdbtnDownPaymentNr: TRadioButton
      Left = 16
      Top = 80
      Width = 113
      Height = 17
      Caption = 'Nr down payment:'
      TabOrder = 2
      OnClick = ChangeStatusDownPaymentNr
    end
    object TxtDownPayment: TEdit
      Left = 128
      Top = 76
      Width = 113
      Height = 21
      Enabled = False
      TabOrder = 3
      OnKeyPress = TxtDownPaymentKeyPress
    end
    object ChkbxDetail: TCheckBox
      Left = 128
      Top = 104
      Width = 97
      Height = 17
      Caption = 'Detail'
      Enabled = False
      TabOrder = 4
    end
  end
  inherited SvcExHApp: TSvcExceptHandler
    Left = 296
    Top = 0
  end
  inherited SvcAppInstCheck: TSvcAppInstance
    Top = 0
  end
  inherited TmrExec: TTimer
    Left = 168
    Top = 0
  end
  inherited ActLstApp: TActionList
    Left = 392
    Top = 0
  end
  inherited ImgLstApp: TImageList
    Left = 344
    Top = 0
  end
  inherited MnuApp: TMainMenu
    Left = 120
    Top = 0
  end
end
