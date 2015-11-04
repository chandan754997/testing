inherited FrmInputBagCA: TFrmInputBagCA
  Left = 411
  Top = 388
  BorderStyle = bsDialog
  Caption = 'Information'
  ClientHeight = 90
  ClientWidth = 182
  PixelsPerInch = 96
  TextHeight = 13
  object LblBagNumber: TLabel
    Left = 12
    Top = 8
    Width = 126
    Height = 13
    Caption = 'Please input a bag number'
  end
  object SvcLFBagNumber: TSvcLocalField
    Left = 10
    Top = 24
    Width = 154
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
    Left = 90
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
    Left = 284
    Top = 4
  end
end
