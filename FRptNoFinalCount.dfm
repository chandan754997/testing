inherited FrmNoFinalCount: TFrmNoFinalCount
  Height = 459
  Caption = 'No final count'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Visible = False
  end
  inherited PnlBtnsTop: TPanel
    inherited BtnStart: TSpeedButton
      Left = 248
    end
    inherited BtnStop: TSpeedButton
      Left = 72
    end
    inherited BtnPrintSetup: TSpeedButton
      Left = 314
      Visible = False
    end
    inherited BtnPrint: TSpeedButton
      Visible = False
    end
  end
  inherited GbxLogging: TGroupBox
    Top = 103
  end
  inherited DtmPckDayFrom: TDateTimePicker
    Visible = False
  end
  inherited Panel1: TPanel
    Height = 163
    Visible = False
    inherited ChkLbxOperator: TCheckListBox
      Height = 83
      Visible = False
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
  inherited RbtDateDay: TRadioButton
    Visible = False
  end
  inherited RbtDateLoaded: TRadioButton
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker
    Visible = False
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Visible = False
  end
end
