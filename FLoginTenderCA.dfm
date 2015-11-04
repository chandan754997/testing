inherited FrmLoginTenderCA: TFrmLoginTenderCA
  Left = 384
  Top = 231
  Caption = 'Registrating operator Tender'
  OnActivate = FormActivate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited LblLogin: TLabel
    Anchors = [akLeft, akRight, akBottom]
  end
  inherited LblSecretCode: TLabel
    Anchors = [akLeft, akRight, akBottom]
  end
  object LblMessage: TLabel [3]
    Left = 8
    Top = 12
    Width = 5
    Height = 13
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
    WordWrap = True
  end
  inherited EdtLogin: TEdit
    Anchors = [akLeft, akBottom]
  end
  inherited BtnCancel: TBitBtn
    Anchors = [akLeft, akBottom]
  end
  inherited BtnOK: TBitBtn
    Anchors = [akLeft, akBottom]
  end
  inherited EdtSecretCode: TEdit
    Anchors = [akLeft, akBottom]
  end
end
