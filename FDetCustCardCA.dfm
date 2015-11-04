inherited FrmDetCustCardCA: TFrmDetCustCardCA
  ClientWidth = 523
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    Width = 523
    Height = 129
    inherited SvcDBLblCodCustCard: TSvcDBLabelLoaded
      Top = 110
    end
    object SvcDBLblNumMasterCard: TSvcDBLabelLoaded [4]
      Left = 8
      Top = 86
      Width = 97
      Height = 13
      Caption = 'Master card number:'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'NumMasterCard'
    end
    object SvcDBLblFlgActive: TSvcDBLabelLoaded [5]
      Left = 300
      Top = 86
      Width = 33
      Height = 13
      Caption = 'Active:'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'FlgActive'
    end
    inherited SvcDBLFNumCard: TSvcDBLocalField
      Epoch = 0
    end
    inherited SvcDBLFIdtCustomer: TSvcDBLocalField
      Epoch = 0
      RangeHigh = {FFC99A3B000000000000}
      RangeLow = {00000000000000000000}
    end
    inherited DBLkpCbxCodCustCard: TDBLookupComboBox
      Left = 150
      Top = 106
      Width = 235
      DropDownRows = 3
      TabOrder = 5
    end
    object SvcDBLFNumMasterCard: TSvcDBLocalField
      Left = 150
      Top = 82
      Width = 130
      Height = 21
      DataField = 'NumMasterCard'
      DataSource = DscCustCard
      FieldType = ftString
      AutoSize = False
      CaretOvr.Shape = csBlock
      Controller = OvcCtlDetail
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      MaxLength = 21
      Options = [efoRightAlign, efoRightJustify, efoTrimBlanks]
      PictureMask = '9999999999999'
      TabOrder = 3
      OnUserValidation = SvcDBLFNumCardUserValidation
      LocalOptions = []
      Local = False
    end
    object DBCbxFlgActive: TDBCheckBox
      Left = 372
      Top = 84
      Width = 17
      Height = 17
      DataField = 'FlgActive'
      DataSource = DscCustCard
      TabOrder = 4
      ValueChecked = '1'
      ValueUnchecked = '0'
    end
  end
  inherited PnlBottom: TPanel
    Width = 523
    inherited PnlBottomRight: TPanel
      Left = 335
    end
    inherited PnlBtnAdd: TPanel
      Left = 239
    end
  end
  inherited PgeCtlDetail: TPageControl
    Top = 129
    Width = 523
    Height = 209
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        Width = 515
        Height = 181
        inherited SvcDBLblDatCreate: TSvcDBLabelLoaded
          Left = 240
          Top = 150
        end
        inherited SvcDBLblCustCardQtyPntGift: TSvcDBLabelLoaded
          Top = 56
        end
        inherited SvcDBLblQtyPntAcquire: TSvcDBLabelLoaded
          Left = 240
        end
        inherited SvcDBLblQtyPntExchange: TSvcDBLabelLoaded
          Left = 240
        end
        inherited SvcDBLblDatExpire: TSvcDBLabelLoaded
          Left = 240
          Top = 8
        end
        inherited SvcDBLblDatModify: TSvcDBLabelLoaded
          Top = 152
        end
        object SvcDBLblDatRelease: TSvcDBLabelLoaded [7]
          Left = 242
          Top = 32
          Width = 63
          Height = 13
          Caption = 'Date release:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'DatRelease'
        end
        object SvcDBLblCodDiscount: TSvcDBLabelLoaded [8]
          Left = 240
          Top = 104
          Width = 69
          Height = 13
          Caption = 'Kind Discount:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'CodDiscount'
        end
        object SvcDBLblPctDiscount: TSvcDBLabelLoaded [9]
          Left = 240
          Top = 128
          Width = 56
          Height = 13
          Caption = 'Discount %:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'PctDiscount'
        end
        object SvcDBLblFlgPoints: TSvcDBLabelLoaded [10]
          Left = 8
          Top = 104
          Width = 78
          Height = 13
          Caption = 'Calculate points:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'FlgPoints'
        end
        object SvcDBLblFlgRebate: TSvcDBLabelLoaded [11]
          Left = 8
          Top = 128
          Width = 80
          Height = 13
          Caption = 'Calculate rebate:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'FlgRebate'
        end
        inherited SvcDBLFDatCreate: TSvcDBLocalField
          Left = 381
          Top = 148
          Epoch = 0
          TabOrder = 10
          RangeHigh = {25600D00000000000000}
          RangeLow = {591D0100000000000000}
        end
        inherited SvcDBLFCustCardQtyPntGift: TSvcDBLocalField
          Left = 150
          Top = 52
          Epoch = 0
          TabOrder = 3
          RangeHigh = {0F270000000000000000}
          RangeLow = {00000000000000000000}
        end
        inherited SvcDBLFDatPntBegin: TSvcDBLocalField
          Left = 150
          Epoch = 0
          TabOrder = 0
          RangeHigh = {25600D00000000000000}
          RangeLow = {591D0100000000000000}
        end
        inherited SvcDBLFQtyPntAcquire: TSvcDBLocalField
          Left = 380
          Epoch = 0
          TabOrder = 4
          RangeHigh = {FFE0F505000000000000}
          RangeLow = {00000000000000000000}
        end
        inherited SvcDBLFQtyPntExchange: TSvcDBLocalField
          Left = 380
          Epoch = 0
          TabOrder = 5
          RangeHigh = {FFE0F505000000000000}
          RangeLow = {00000000000000000000}
        end
        inherited SvcDBLFDatExpire: TSvcDBLocalField
          Left = 380
          Top = 4
          Epoch = 0
          TabOrder = 1
          RangeHigh = {25600D00000000000000}
          RangeLow = {591D0100000000000000}
        end
        inherited SvcDBLFDatModify: TSvcDBLocalField
          Left = 150
          Top = 148
          Epoch = 0
          TabOrder = 11
          RangeHigh = {25600D00000000000000}
          RangeLow = {591D0100000000000000}
        end
        object SvcDBLFDatRelease: TSvcDBLocalField
          Left = 380
          Top = 28
          Width = 80
          Height = 21
          DataField = 'DatRelease'
          DataSource = DscCustCard
          FieldType = ftDateTime
          CaretOvr.Shape = csBlock
          Controller = OvcCtlDetail
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          MaxLength = 10
          Options = [efoCaretToEnd]
          PictureMask = 'dd/mm/yyyy'
          TabOrder = 2
          LocalOptions = [ldoForceCentury]
          Local = True
          RangeHigh = {25600D00000000000000}
          RangeLow = {591D0100000000000000}
        end
        object DBLkpCbxCodDiscount: TDBLookupComboBox
          Left = 380
          Top = 100
          Width = 130
          Height = 21
          DataField = 'LkpCodDiscount'
          DataSource = DscCustCard
          DropDownRows = 3
          TabOrder = 7
          OnClick = DBLkpCbxCodDiscountClick
        end
        object SvcDBLFPctDiscount: TSvcDBLocalField
          Left = 380
          Top = 124
          Width = 80
          Height = 21
          DataField = 'PctDiscount'
          DataSource = DscCustCard
          FieldType = ftBCD
          CaretOvr.Shape = csBlock
          Controller = OvcCtlDetail
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          MaxLength = 6
          Options = [efoForceOvertype, efoRightAlign]
          PictureMask = '999.99'
          TabOrder = 9
          LocalOptions = []
          Local = False
          RangeHigh = {00000000000000C80540}
          RangeLow = {00000000000000000000}
        end
        object DBCbxFlgPoints: TDBCheckBox
          Left = 150
          Top = 102
          Width = 17
          Height = 17
          DataField = 'FlgPoints'
          DataSource = DscCustCard
          TabOrder = 6
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object DBCbxFlgRebate: TDBCheckBox
          Left = 150
          Top = 126
          Width = 17
          Height = 17
          DataField = 'FlgRebate'
          DataSource = DscCustCard
          TabOrder = 8
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
      end
    end
  end
  inherited StsBarInfo: TStatusBar
    Width = 523
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
  end
  inherited DscCustCard: TDataSource
    DataSet = DmdFpnCustomerCA.QryDetCustCard
  end
end
