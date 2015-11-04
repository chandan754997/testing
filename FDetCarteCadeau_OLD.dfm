inherited FrmDetCarteCadeau: TFrmDetCarteCadeau
  Top = 205
  Caption = 'Report Gift card Satisfaction'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Visible = False
  end
  inherited StsBarExec: TStatusBar
    Top = 366
  end
  inherited PgsBarExec: TProgressBar
    Top = 350
  end
  inherited PnlBtnsTop: TPanel
    inherited BtnExit: TSpeedButton
      Left = 439
    end
  end
  inherited GbxLogging: TGroupBox
    Top = 103
    TabOrder = 5
  end
  inherited Panel1: TPanel
    Height = 163
    TabOrder = 3
    inherited ChkLbxOperator: TCheckListBox
      Height = 83
    end
    inherited BtnSelectAll: TBitBtn
      Top = 99
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 131
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Visible = False
  end
  inherited RbtDateLoaded: TRadioButton
    Visible = False
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Visible = False
  end
end
