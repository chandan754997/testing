inherited FrmDetEtatCaution: TFrmDetEtatCaution
  Height = 427
  Caption = 'Rapport Etat des cautions du jour'
  PixelsPerInch = 96
  TextHeight = 13
  inherited StsBarExec: TStatusBar
    Top = 362
  end
  inherited PgsBarExec: TProgressBar
    Top = 346
  end
  inherited GbxLogging: TGroupBox
    Top = 190
    TabOrder = 5
  end
  inherited Panel1: TPanel
    Height = 250
    TabOrder = 3
    inherited ChkLbxOperator: TCheckListBox
      Height = 170
    end
    inherited BtnSelectAll: TBitBtn
      Top = 186
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 218
    end
  end
  object RbtGlobalRapport: TRadioButton [13]
    Left = 248
    Top = 200
    Width = 113
    Height = 17
    Caption = 'Global rapport'
    TabOrder = 9
    OnClick = RbtDateDayClick
  end
  inherited DtmPckDayTo: TDateTimePicker
    TabOrder = 10
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    TabOrder = 11
  end
end
