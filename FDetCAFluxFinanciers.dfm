inherited FrmDetCAFluxFinanciers: TFrmDetCAFluxFinanciers
  Left = 353
  Top = 169
  Caption = 'List with the financial flow of the day'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Visible = False
  end
  inherited GbxLogging: TGroupBox
    Top = 183
  end
  inherited Panel1: TPanel
    Height = 304
    inherited ChkLbxOperator: TCheckListBox
      Height = 232
    end
    inherited BtnSelectAll: TBitBtn
      Top = 240
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 272
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Visible = False
  end
  inherited RbtDateLoaded: TRadioButton
    Enabled = False
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker
    Visible = False
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Visible = False
  end
  object Panel3: TPanel [15]
    Left = 256
    Top = 104
    Width = 225
    Height = 249
    Anchors = [akLeft, akTop, akBottom]
    Caption = 'Panel1'
    TabOrder = 11
    DesignSize = (
      225
      249)
    object ChkLbxSafes: TCheckListBox
      Left = 1
      Top = 1
      Width = 223
      Height = 176
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 0
    end
    object BtnSelectAllSafes: TBitBtn
      Left = 8
      Top = 185
      Width = 209
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Select All'
      TabOrder = 1
      OnClick = BtnSelectAllSafesClick
    end
    object BtnDeselectAllSafes: TBitBtn
      Left = 8
      Top = 217
      Width = 209
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Deselect All'
      TabOrder = 2
      OnClick = BtnDeselectAllSafesClick
    end
  end
end
