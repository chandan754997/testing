inherited FrmInputLabelerCA: TFrmInputLabelerCA
  Width = 352
  Height = 286
  Caption = 'Confirmation'
  Constraints.MinHeight = 286
  Constraints.MinWidth = 352
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object LblTypesOfLabels: TLabel
    Left = 8
    Top = 8
    Width = 228
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    Caption = 'The following type(s) of labels will be generated: '
  end
  object LblDefaultLabel: TLabel
    Left = 8
    Top = 184
    Width = 334
    Height = 13
    Anchors = [akLeft, akRight, akBottom]
    Caption = 
      'Choose the label type to be used for the labels without a specif' +
      'ic layout'
  end
  object BtnOK: TBitBtn
    Left = 183
    Top = 229
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 2
    Kind = bkOK
  end
  object BtnCancel: TBitBtn
    Left = 263
    Top = 229
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    TabOrder = 3
    Kind = bkCancel
  end
  object StrGrdLabelTypes: TStringGrid
    Left = 8
    Top = 26
    Width = 330
    Height = 152
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 1
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object CbxDefaultLabel: TComboBox
    Left = 8
    Top = 201
    Width = 330
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 0
    TabOrder = 1
    OnChange = CbxDefaultLabelChange
  end
end
