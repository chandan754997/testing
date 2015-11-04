inherited FrmRptCash: TFrmRptCash
  Caption = 'FrmRptCash'
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
  inherited StsBarExec: TStatusBar
    Top = 374
  end
  inherited PgsBarExec: TProgressBar
    Top = 358
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
  inherited DtmPckDayFrom: TDateTimePicker
    Visible = False
  end
  inherited Panel1: TPanel
    Visible = False
    inherited ChkLbxOperator: TCheckListBox
      Visible = False
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
