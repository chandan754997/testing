inherited FrmSelDateTime: TFrmSelDateTime
  Left = 464
  Top = 277
  Width = 246
  Height = 150
  Caption = 'Select date time for report'
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object LblDateFrom: TLabel
    Left = 32
    Top = 20
    Width = 52
    Height = 13
    Caption = 'From Date:'
  end
  object LblDateTo: TLabel
    Left = 32
    Top = 48
    Width = 42
    Height = 13
    Caption = 'To Date:'
  end
  object BtnOk: TBitBtn
    Left = 28
    Top = 84
    Width = 75
    Height = 25
    TabOrder = 0
    OnClick = BtnOkClick
    Kind = bkOK
  end
  object BtnCancel: TBitBtn
    Left = 128
    Top = 84
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object DtmPckFrom: TDateTimePicker
    Left = 120
    Top = 16
    Width = 97
    Height = 21
    Date = 37600.446230254630000000
    Time = 37600.446230254630000000
    TabOrder = 2
    OnExit = DtmPckFromExit
  end
  object DtmPckTo: TDateTimePicker
    Left = 120
    Top = 44
    Width = 97
    Height = 21
    Date = 37600.446297013890000000
    Time = 37600.446297013890000000
    TabOrder = 3
  end
end
