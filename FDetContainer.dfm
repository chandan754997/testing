inherited FrmDetContainer: TFrmDetContainer
  Left = 54
  Top = 156
  Width = 505
  Height = 267
  Caption = 'Report Container bags'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded
    Left = 152
    Top = 232
    Visible = False
  end
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Left = 152
    Top = 304
    Visible = False
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Left = 152
    Top = 256
    Visible = False
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Left = 152
    Top = 328
    Visible = False
  end
  object LblStartDate: TLabel [4]
    Left = 88
    Top = 64
    Width = 54
    Height = 13
    Caption = 'Begin date:'
  end
  object LblEndDate: TLabel [5]
    Left = 88
    Top = 88
    Width = 46
    Height = 13
    Caption = 'End date:'
  end
  object LblContainer: TLabel [6]
    Left = 88
    Top = 117
    Width = 69
    Height = 13
    Caption = 'Container bag:'
  end
  object LblBag: TLabel [7]
    Left = 88
    Top = 144
    Width = 58
    Height = 13
    Caption = 'Sealed Bag:'
  end
  inherited StsBarExec: TStatusBar
    Top = 221
    Width = 497
  end
  inherited PgsBarExec: TProgressBar
    Top = 205
    Width = 497
  end
  inherited PnlBtnsTop: TPanel
    Width = 497
    inherited BtnExit: TSpeedButton
      Left = 431
    end
  end
  inherited GbxLogging: TGroupBox
    Top = -8
  end
  inherited DtmPckDayFrom: TDateTimePicker
    Left = 184
    Top = 63
    Width = 120
    OnEnter = DtmPckDayFromEnter
  end
  inherited Panel1: TPanel
    Left = 56
    Top = 289
    Width = 65
    Height = 0
    Visible = False
    inherited ChkLbxOperator: TCheckListBox
      Width = 63
      Height = 0
    end
    inherited BtnSelectAll: TBitBtn
      Top = -64
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = -32
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Left = 240
    Top = 296
    Visible = False
  end
  inherited RbtDateDay: TRadioButton
    Left = 128
    Top = 208
    Visible = False
  end
  inherited RbtDateLoaded: TRadioButton
    Left = 128
    Top = 280
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker
    Left = 184
    Top = 87
    Width = 120
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Left = 240
    Top = 320
    Visible = False
  end
  object RdbSelectDate: TRadioButton [19]
    Left = 56
    Top = 64
    Width = 17
    Height = 17
    ParentShowHint = False
    ShowHint = False
    TabOrder = 11
  end
  object RdbSelectContainer: TRadioButton [20]
    Left = 56
    Top = 117
    Width = 17
    Height = 17
    Caption = 'RdbSelectContainer'
    TabOrder = 12
  end
  object RdbSelectBag: TRadioButton [21]
    Left = 56
    Top = 144
    Width = 17
    Height = 17
    Caption = 'RdbSelectBag'
    TabOrder = 13
  end
  object SvcLFContainer: TSvcLocalField [22]
    Left = 184
    Top = 115
    Width = 120
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
    PictureMask = '999999999999'
    TabOrder = 14
    OnEnter = SvcLFContainerEnter
    LocalOptions = []
    Local = False
  end
  object SvcLFBag: TSvcLocalField [23]
    Left = 184
    Top = 142
    Width = 120
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
    TabOrder = 15
    OnEnter = SvcLFBagEnter
    LocalOptions = []
    Local = False
  end
  object QryContainer: TQuery
    DatabaseName = 'DBFlexPoint'
    Left = 384
    Top = 56
  end
  object QryBag: TQuery
    DatabaseName = 'DBFlexPoint'
    Left = 384
    Top = 108
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
    Epoch = 2000
    Left = 448
    Top = 112
  end
end
