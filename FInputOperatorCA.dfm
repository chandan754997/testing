inherited FrmInputOperatorCA: TFrmInputOperatorCA
  Left = 411
  Top = 388
  BorderStyle = bsDialog
  Caption = 'Information'
  ClientHeight = 90
  ClientWidth = 277
  PixelsPerInch = 96
  TextHeight = 13
  object LblOperatorNumber: TLabel
    Left = 12
    Top = 8
    Width = 154
    Height = 13
    Caption = 'Please enter an operator number'
  end
  object SvcLFOperatorNumber: TSvcLocalField
    Left = 10
    Top = 24
    Width = 255
    Height = 21
    Cursor = crIBeam
    DataType = pftString
    CaretOvr.Shape = csBlock
    Controller = OvcController1
    ControlCharColor = clRed
    DecimalPlaces = 0
    EFColors.Disabled.BackColor = clWindow
    EFColors.Disabled.TextColor = clGrayText
    EFColors.Error.BackColor = clRed
    EFColors.Error.TextColor = clBlack
    EFColors.Highlight.BackColor = clHighlight
    EFColors.Highlight.TextColor = clHighlightText
    Epoch = 0
    InitDateTime = False
    MaxLength = 13
    PictureMask = '9999999999999'
    TabOrder = 0
    LocalOptions = []
    Local = False
  end
  object BtnOK: TBitBtn
    Left = 10
    Top = 56
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = BtnOKClick
    Kind = bkOK
  end
  object BtnCancel: TBitBtn
    Left = 186
    Top = 56
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object OvcController1: TOvcController
    EntryCommands.TableList = (
      'Default'
      True
      ()
      'WordStar'
      False
      ()
      'Grid'
      False
      ())
    EntryOptions = [efoAutoSelect, efoBeepOnError]
    Epoch = 1980
    Left = 332
    Top = 12
  end
end
