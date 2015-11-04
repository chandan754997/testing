inherited FrmDetTndReprintCA: TFrmDetTndReprintCA
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDate: TSvcDBLabelLoaded
    Visible = False
  end
  object SvcDBLblDateStart: TSvcDBLabelLoaded [1]
    Left = 272
    Top = 79
    Width = 43
    Height = 13
    Caption = 'Startdate'
    IdtLabel = 'SvcDBLblDateStart'
  end
  object SvcDBLblDateEnd: TSvcDBLabelLoaded [2]
    Left = 272
    Top = 103
    Width = 40
    Height = 13
    Caption = 'Enddate'
    IdtLabel = 'SvcDBLblDateEnd'
  end
  inherited GbxLogging: TGroupBox
    Top = 14
  end
  inherited Panel1: TPanel
    Height = 164
    inherited ChkLbxOperator: TCheckListBox
      Height = 84
    end
    inherited BtnSelectAll: TBitBtn
      Top = 100
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 132
    end
  end
  inherited DtmPckDay: TDateTimePicker
    Visible = False
  end
  object DtmPckDayStart: TDateTimePicker [9]
    Left = 349
    Top = 71
    Width = 121
    Height = 21
    Date = 37420.429163692130000000
    Time = 37420.429163692130000000
    TabOrder = 6
    OnExit = DtmPckDayExit
  end
  object DtmPckDayEnd: TDateTimePicker [10]
    Left = 349
    Top = 95
    Width = 121
    Height = 21
    Date = 37420.429163692130000000
    Time = 37420.429163692130000000
    TabOrder = 7
    OnExit = DtmPckDayExit
  end
end
