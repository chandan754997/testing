inherited FrmRptSalesBulletin: TFrmRptSalesBulletin
  Width = 477
  Height = 321
  Caption = 'List of Point of Sale Newsletter'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Visible = False
  end
  inherited StsBarExec: TStatusBar
    Top = 243
    Width = 481
  end
  inherited PgsBarExec: TProgressBar
    Top = 262
    Width = 481
  end
  inherited PnlBtnsTop: TPanel
    Width = 481
    inherited BtnExit: TSpeedButton
      Left = 399
    end
  end
  inherited DtmPckDayFrom: TDateTimePicker [7]
  end
  inherited Panel1: TPanel [8]
    Height = 0
    Visible = False
    inherited ChkLbxOperator: TCheckListBox
      Height = 0
    end
    inherited BtnSelectAll: TBitBtn
      Top = -121
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = -89
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker [9]
    Visible = False
  end
  inherited RbtDateDay: TRadioButton [10]
  end
  inherited RbtDateLoaded: TRadioButton [11]
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker [12]
  end
  inherited DtmPckLoadedTo: TDateTimePicker [13]
    Visible = False
  end
  inherited GbxLogging: TGroupBox [14]
    Left = 248
    Top = -511
  end
  object Gbx: TGroupBox [15]
    Left = 8
    Top = 56
    Width = 449
    Height = 121
    TabOrder = 11
    object RbtNotClosed: TRadioButton
      Left = 11
      Top = 32
      Width = 113
      Height = 17
      Caption = 'Not Closed'
      TabOrder = 0
      OnClick = RbtReportTypeClick
    end
    object RbtClientIdentifier: TRadioButton
      Left = 11
      Top = 56
      Width = 175
      Height = 17
      Caption = 'Cleint'#39's Identifier'
      TabOrder = 1
      OnClick = RbtReportTypeClick
    end
    object SvcMEClientIDNr: TSvcMaskEdit
      Left = 168
      Top = 57
      Properties.MaskKind = emkRegExpr
      Properties.EditMask = '\d+'
      Properties.MaxLength = 0
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 2
      Width = 121
    end
  end
end
