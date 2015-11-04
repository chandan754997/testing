inherited FrmTndSelGroup: TFrmTndSelGroup
  Left = 463
  Top = 209
  BorderIcons = [biHelp]
  BorderStyle = bsDialog
  Caption = 'Select Tendergroup'
  ClientHeight = 172
  ClientWidth = 279
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object LblTenderGroup: TLabel
    Left = 12
    Top = 20
    Width = 66
    Height = 13
    Caption = 'TenderGroup:'
  end
  object BtnOK: TBitBtn
    Left = 76
    Top = 136
    Width = 90
    Height = 25
    TabOrder = 0
    OnClick = BtnOKClick
    Kind = bkOK
    Margin = 2
  end
  object BtnCancel: TBitBtn
    Left = 172
    Top = 136
    Width = 90
    Height = 25
    Caption = 'Canc.'
    TabOrder = 1
    Kind = bkCancel
    Margin = 2
  end
  object LbxTenderGroup: TListBox
    Left = 96
    Top = 16
    Width = 121
    Height = 97
    ItemHeight = 13
    TabOrder = 2
    OnDblClick = LbxTenderGroupDblClick
  end
end
