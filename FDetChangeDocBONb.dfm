inherited FrmDetChangeDocBONb: TFrmDetChangeDocBONb
  Left = 530
  Top = 245
  VertScrollBar.Range = 0
  BorderStyle = bsDialog
  Caption = 'Change Document Number'
  ClientHeight = 138
  ClientWidth = 341
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    Width = 341
    object LblNewVenteId: TLabel
      Left = 8
      Top = 12
      Width = 68
      Height = 13
      Caption = 'New Vente Id:'
    end
    object LblNewTypeVente: TLabel
      Left = 8
      Top = 40
      Width = 83
      Height = 13
      Caption = 'New Type Vente:'
    end
    object CbxTypeVente: TComboBox
      Left = 212
      Top = 36
      Width = 93
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 0
    end
  end
  inherited PnlBottom: TPanel
    Top = 87
    Width = 341
    TabOrder = 3
    inherited PnlBottomRight: TPanel
      Left = 153
    end
    inherited BtnApply: TBitBtn
      Left = -52
      Visible = False
    end
    inherited PnlBtnAdd: TPanel
      Left = 57
      inherited BtnAdd: TBitBtn
        Left = -80
        Visible = False
      end
    end
    inherited BtnAddOn: TBitBtn
      Left = -52
    end
  end
  inherited PgeCtlDetail: TPageControl
    Width = 341
    Height = 25
    Visible = False
  end
  inherited StsBarInfo: TStatusBar
    Top = 119
    Width = 341
    Visible = False
  end
  object SvcLFIdtCVente: TSvcLocalField [4]
    Left = 212
    Top = 8
    Width = 93
    Height = 21
    Cursor = crIBeam
    DataType = pftDouble
    CaretOvr.Shape = csBlock
    Controller = OvcCtlDetail
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
    MaxLength = 10
    Options = [efoCaretToEnd]
    PictureMask = '##########'
    TabOrder = 2
    LocalOptions = []
    Local = False
    RangeHigh = {73B2DBB9838916F2FE43}
    RangeLow = {73B2DBB9838916F2FEC3}
  end
  inherited OvcCtlDetail: TOvcController
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
    Left = 8
  end
end
