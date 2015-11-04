inherited FrmDetCACaissiere: TFrmDetCACaissiere
  Left = 298
  Top = 211
  Caption = 'Rapport CA Operator'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Visible = False
  end
  inherited StsBarExec: TStatusBar
    Top = 362
  end
  inherited PgsBarExec: TProgressBar
    Top = 346
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Visible = False
  end
  inherited RbtDateDay: TRadioButton
    Top = 58
  end
  inherited RbtDateLoaded: TRadioButton
    Visible = False
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Visible = False
  end
  inherited TmrExec: TTimer
    Left = 440
    Top = 296
  end
  inherited ActLstApp: TActionList
    Left = 456
    Top = 240
  end
  inherited ImgLstApp: TImageList
    Left = 408
    Top = 224
  end
  inherited MnuApp: TMainMenu
    Top = 296
  end
  object SprCACaissiere: TStoredProc
    DatabaseName = 'DBFlexPoint'
    StoredProcName = 'SprLstCACaissieres;1'
    Left = 362
    Top = 236
    ParamData = <
      item
        DataType = ftInteger
        Name = 'RETURN_VALUE'
        ParamType = ptResult
        Value = 0
      end
      item
        DataType = ftString
        Name = '@PrmTxtSequence'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@PrmTxtFrom'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@PrmTxtTo'
        ParamType = ptInput
      end>
  end
end
