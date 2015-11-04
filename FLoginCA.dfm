inherited FrmLoginFpnCA: TFrmLoginFpnCA
  Left = 373
  Top = 285
  ClientHeight = 152
  PixelsPerInch = 96
  TextHeight = 13
  inherited ImgBackGround: TImage
    Height = 152
  end
  inherited LblLogin: TLabel
    Width = 217
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
  end
  object LblSecretCode: TLabel [2]
    Left = 8
    Top = 65
    Width = 217
    Height = 13
    AutoSize = False
    Caption = 'Enter Secret Code:'
    Transparent = True
  end
  inherited EdtLogin: TEdit
    OnKeyPress = EdtKeyPress
  end
  inherited BtnCancel: TBitBtn
    Top = 120
    TabOrder = 3
  end
  inherited BtnOK: TBitBtn
    Top = 120
    Default = False
    Kind = bkCustom
  end
  object EdtSecretCode: TEdit
    Left = 8
    Top = 83
    Width = 217
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    MaxLength = 30
    PasswordChar = '*'
    TabOrder = 1
    OnKeyPress = EdtKeyPress
  end
end
