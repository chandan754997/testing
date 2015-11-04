inherited FrmInputInvOrigCA: TFrmInputInvOrigCA
  Left = 483
  Top = 307
  BorderStyle = bsDialog
  Caption = 'Information'
  ClientHeight = 90
  ClientWidth = 209
  PixelsPerInch = 96
  TextHeight = 13
  object LblInvoiceNumber: TLabel
    Left = 16
    Top = 8
    Width = 187
    Height = 13
    Caption = 'Please input the original invoice number'
  end
  object BtnOK: TBitBtn
    Left = 10
    Top = 56
    Width = 87
    Height = 25
    TabOrder = 1
    OnClick = BtnOKClick
    Kind = bkOK
  end
  object BtnCancel: TBitBtn
    Left = 112
    Top = 56
    Width = 87
    Height = 25
    TabOrder = 2
    OnClick = BtnCancelClick
    Kind = bkCancel
  end
  object SvcMEInvoiceNumber: TSvcMaskEdit
    Left = 16
    Top = 24
    Properties.MaskKind = emkRegExpr
    Properties.EditMask = '[0-9]+'
    Properties.MaxLength = 0
    Style.BorderStyle = ebs3D
    Style.HotTrack = False
    StyleDisabled.Color = clWindow
    TabOrder = 0
    Width = 130
  end
end
