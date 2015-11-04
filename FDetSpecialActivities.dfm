inherited FrmDetSpecialActivities: TFrmDetSpecialActivities
  Height = 395
  Caption = 'Special activities report'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Left = 112
    Top = 96
    Visible = False
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Left = 80
    Top = 128
    Visible = False
  end
  object LblDate: TLabel [4]
    Left = 256
    Top = 56
    Width = 26
    Height = 13
    Caption = 'Date:'
  end
  inherited StsBarExec: TStatusBar
    Top = 342
  end
  inherited PgsBarExec: TProgressBar
    Top = 326
  end
  inherited GbxLogging: TGroupBox
    Left = -8
    Top = -48
  end
  inherited DtmPckDayFrom: TDateTimePicker
    TabOrder = 6
  end
  inherited Panel1: TPanel
    Height = 237
    Caption = ''
    TabOrder = 4
    DesignSize = (
      225
      237)
    inherited ChkLbxOperator: TCheckListBox
      Height = 157
    end
    inherited BtnSelectAll: TBitBtn
      Top = 173
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 205
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Left = 128
    Top = 96
    TabOrder = 5
    Visible = False
  end
  inherited RbtDateDay: TRadioButton
    Left = 56
    Top = 120
    TabOrder = 9
    Visible = False
  end
  inherited RbtDateLoaded: TRadioButton
    Left = 32
    Top = 120
    TabOrder = 10
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker
    TabOrder = 7
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Left = 80
    Top = 112
    TabOrder = 11
    Visible = False
  end
  object Panel2: TPanel [16]
    Left = 256
    Top = 128
    Width = 225
    Height = 158
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 8
    DesignSize = (
      225
      158)
    object ChkLbxCheckout: TCheckListBox
      Left = 1
      Top = 1
      Width = 223
      Height = 85
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 0
    end
    object BtnSelectAllCheckout: TBitBtn
      Left = 8
      Top = 94
      Width = 209
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Select All'
      TabOrder = 1
      OnClick = BtnSelectAllClickCheckout
    end
    object BtnDESelectAllCheckout: TBitBtn
      Left = 8
      Top = 126
      Width = 209
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Deselect All'
      TabOrder = 2
      OnClick = BtnDeSelectAllClickCheckout
    end
  end
  inherited TmrExec: TTimer
    Left = 144
    Top = 88
  end
  inherited ActLstApp: TActionList
    Left = 64
    Top = 104
  end
  inherited ImgLstApp: TImageList
    Left = 64
    Top = 104
  end
  inherited MnuApp: TMainMenu
    Left = 128
    Top = 56
  end
end
