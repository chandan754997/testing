inherited FrmDetDocumentBO: TFrmDetDocumentBO
  Left = 133
  Top = 146
  Height = 479
  Caption = 'Detail Backoffice Document'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    Height = 126
    object SvcDBLblIdtPosTransaction: TSvcDBLabelLoaded
      Left = 8
      Top = 12
      Width = 71
      Height = 13
      Caption = 'Ticket number:'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'IdtPosTransaction'
    end
    object SvcDBLblIdtCheckout: TSvcDBLabelLoaded
      Left = 8
      Top = 36
      Width = 87
      Height = 13
      Caption = 'Checkout number:'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'IdtCheckout'
    end
    object SvcDBLblDatTransBegin: TSvcDBLabelLoaded
      Left = 8
      Top = 60
      Width = 59
      Height = 13
      Caption = 'Date Ticket:'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'DatTransBegin'
    end
    object SvcDBLblIdtCVente: TSvcDBLabelLoaded
      Left = 8
      Top = 84
      Width = 90
      Height = 13
      Caption = 'Document number:'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'IdtCVente'
    end
    object SvcDBLblCodTypeVente: TSvcDBLabelLoaded
      Left = 6
      Top = 108
      Width = 79
      Height = 13
      Caption = 'Document Type:'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'CodTypeVente'
    end
    object SvcDBLFIdtPosTransaction: TSvcDBLocalField
      Left = 136
      Top = 8
      Width = 77
      Height = 21
      DataField = 'IdtPosTransaction'
      DataSource = DscDocumentBO
      FieldType = ftInteger
      CaretOvr.Shape = csBlock
      Controller = OvcCtlDetail
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      MaxLength = 10
      Options = [efoRightAlign, efoRightJustify]
      PictureMask = '9999999999'
      TabOrder = 0
      LocalOptions = []
      Local = False
      RangeHigh = {FFFFFF7F000000000000}
      RangeLow = {01000000000000000000}
    end
    object SvcDBLFIdtCheckout: TSvcDBLocalField
      Left = 136
      Top = 32
      Width = 77
      Height = 21
      DataField = 'IdtCheckout'
      DataSource = DscDocumentBO
      FieldType = ftInteger
      CaretOvr.Shape = csBlock
      Controller = OvcCtlDetail
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      MaxLength = 9
      Options = [efoRightAlign, efoRightJustify]
      PictureMask = '999999999'
      TabOrder = 1
      LocalOptions = []
      Local = False
      RangeHigh = {FFFFFF7F000000000000}
      RangeLow = {01000000000000000000}
    end
    object SvcDBLFDatTransBegin: TSvcDBLocalField
      Left = 136
      Top = 56
      Width = 77
      Height = 21
      DataField = 'DatTransBegin'
      DataSource = DscDocumentBO
      FieldType = ftDateTime
      CaretOvr.Shape = csBlock
      Controller = OvcCtlDetail
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      MaxLength = 8
      Options = [efoRightAlign]
      PictureMask = 'dd/mm/yy'
      TabOrder = 2
      LocalOptions = []
      Local = False
      RangeHigh = {25600D00000000000000}
      RangeLow = {00000000000000000000}
    end
    object SvcDBLFIdtCVente: TSvcDBLocalField
      Left = 136
      Top = 80
      Width = 77
      Height = 21
      DataField = 'IdtCVente'
      DataSource = DscDocumentBO
      FieldType = ftBCD
      CaretOvr.Shape = csBlock
      Controller = OvcCtlDetail
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      MaxLength = 10
      Options = [efoCaretToEnd, efoRightAlign, efoRightJustify]
      PictureMask = '##########'
      TabOrder = 3
      LocalOptions = []
      Local = False
      RangeHigh = {E175587FED2AB1ECFE7F}
      RangeLow = {E175587FED2AB1ECFEFF}
    end
    object SvcDBLFCodTypeVente: TSvcDBLocalField
      Left = 136
      Top = 104
      Width = 31
      Height = 21
      DataField = 'CodTypeVente'
      DataSource = DscDocumentBO
      FieldType = ftInteger
      CaretOvr.Shape = csBlock
      Controller = OvcCtlDetail
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      MaxLength = 3
      Options = [efoRightAlign, efoRightJustify]
      PictureMask = '999'
      TabOrder = 4
      OnChange = SvcDBLFCodTypeVenteChange
      LocalOptions = []
      Local = False
      RangeHigh = {FFFFFF7F000000000000}
      RangeLow = {00000080000000000000}
    end
    object SvcDBLFTimTransBegin: TSvcDBLocalField
      Left = 216
      Top = 56
      Width = 77
      Height = 21
      DataField = 'DatTransBegin'
      DataSource = DscDocumentBO
      FieldType = ftDateTime
      DateOrTime = ftUseTime
      AutoSize = False
      CaretOvr.Shape = csBlock
      Controller = OvcCtlDetail
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      MaxLength = 8
      Options = [efoRightAlign]
      PictureMask = 'hh:mm:ss'
      TabOrder = 5
      LocalOptions = []
      Local = False
      RangeHigh = {7F510100000000000000}
      RangeLow = {00000000000000000000}
    end
    object BtnConnect: TBitBtn
      Left = 219
      Top = 8
      Width = 90
      Height = 25
      Hint = 'Connect one supplier '
      Caption = 'Connect'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = BtnConnectClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF003FFFFFFFFFFF
        FFFF33333333333FFFFF3FFFFFFFFF00000F333333333377777F33FFFFFFFF09
        990F33333333337F337F333FFFFFFF09990F33333333337F337F3333FFFFFF09
        990F33333333337FFF7F33333FFFFF00000F3333333333777773333333FFFFFF
        FFFF3333333333333F333333333FFFFF0FFF3333333333337FF333333333FFF0
        00FF33333333333777FF333333333F00000F33FFFFF33777777F300000333000
        0000377777F33777777730EEE033333000FF37F337F3333777F330EEE0333330
        00FF37F337F3333777F330EEE033333000FF37FFF7F333F77733300000333000
        03FF3777773337777333333333333333333F3333333333333333}
      Margin = 2
      NumGlyphs = 2
      Spacing = 2
    end
    object SvcLFTypeText: TSvcLocalField
      Left = 168
      Top = 104
      Width = 45
      Height = 21
      Cursor = crIBeam
      DataType = pftString
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
      PictureMask = 'XXXXXXXXXXXXXXX'
      TabOrder = 7
      LocalOptions = []
      Local = False
    end
  end
  inherited PnlBottom: TPanel
    Top = 401
    inherited PnlBottomRight: TPanel
      inherited BtnOK: TBitBtn
        Visible = False
      end
      inherited BtnCancel: TBitBtn
        Caption = 'Close'
        Kind = bkClose
      end
    end
  end
  inherited PgeCtlDetail: TPageControl
    Top = 126
    Height = 275
    ActivePage = TabShtDocumentBOTrans
    object TabShtDocumentBOTrans: TTabSheet
      Caption = 'Ticket Articles'
      object SbxArticle: TScrollBox
        Left = 0
        Top = 0
        Width = 624
        Height = 247
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 0
        object DBGrid1: TDBGrid
          Left = 0
          Top = 0
          Width = 624
          Height = 247
          Align = alClient
          DataSource = DscDocBOTrans
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'NumPLU'
              Title.Caption = 'PLU-number'
              Width = 69
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TxtDescr'
              Title.Caption = 'Description'
              Width = 337
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'QtyLine'
              Title.Caption = 'Quantity'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PrcInclVAT'
              Title.Caption = 'Price'
              Visible = True
            end>
        end
      end
    end
  end
  inherited StsBarInfo: TStatusBar
    Top = 433
  end
  object BtnModifyDocNb: TBitBtn [4]
    Left = 216
    Top = 80
    Width = 77
    Height = 46
    Hint = 'Connect one supplier '
    Caption = 'Modify'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = BtnModifyDocNbClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      0400000000000001000000000000000000001000000010000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
      000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
      00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
      F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
      0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
      FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
      FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
      0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
      00333377737FFFFF773333303300000003333337337777777333}
    Margin = 2
    NumGlyphs = 2
    Spacing = 2
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
    Left = 584
    Top = 4
  end
  object DscDocumentBO: TDataSource
    DataSet = DmdFpnBODocument.QryDetDocumentBO
    Left = 248
    Top = 304
  end
  object DscDocBOTrans: TDataSource
    DataSet = DmdFpnBODocument.QryLstDocBOTrans
    Left = 336
    Top = 303
  end
end
