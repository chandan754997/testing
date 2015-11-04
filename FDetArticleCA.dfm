inherited FrmDetArticleCA: TFrmDetArticleCA
  Left = 175
  Top = 122
  Width = 663
  Height = 510
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    Width = 655
    inherited SvcDBMEIdtArticle: TSvcDBMaskEdit
      Properties.MaxLength = 14
    end
    inherited SvcDBMETxtPublDescr: TSvcDBMaskEdit
      Properties.MaxLength = 40
    end
  end
  inherited PnlBottom: TPanel
    Top = 425
    Width = 655
    inherited PnlBottomRight: TPanel
      Left = 467
    end
    inherited PnlBtnAdd: TPanel
      Left = 371
    end
  end
  inherited PgeCtlDetail: TPageControl
    Width = 655
    Height = 363
    ActivePage = TabShtGeneral
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        Width = 647
        Height = 335
        inherited GbxActive: TGroupBox
          Width = 647
        end
        inherited GbxContents: TGroupBox
          Width = 647
          Height = 106
          inherited SvcDBLblFlgAd: TSvcDBLabelLoaded
            Top = 86
          end
          object SvcDBLblCodBlocked: TSvcDBLabelLoaded [6]
            Left = 8
            Top = 86
            Width = 42
            Height = 13
            Caption = 'Blocked:'
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'FlgBlocked'
          end
          object SvcDBLblCodLabelLayout: TSvcDBLabelLoaded [7]
            Left = 416
            Top = 62
            Width = 60
            Height = 13
            Caption = 'Label layout:'
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'IdtLabelerLayout'
          end
          inherited SvcDBLFQtyIndivCons: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {FF000000000000000000}
            RangeLow = {01000000000000000000}
          end
          inherited SvcDBLFQtyContents: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {1D5A643BDFFF4FC30F40}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFQtyIndivPurch: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {FF000000000000000000}
            RangeLow = {01000000000000000000}
          end
          inherited DBChxFlgAd: TDBCheckBox
            Top = 84
          end
          object DBLkpCbxCodBlocked: TDBLookupComboBox
            Left = 136
            Top = 82
            Width = 241
            Height = 21
            DataField = 'LkpCodBlocked'
            DataSource = DscArticle
            DropDownRows = 10
            TabOrder = 6
          end
          object DBLkpCbxCodLabelLayout: TDBLookupComboBox
            Left = 520
            Top = 58
            Width = 120
            Height = 21
            DataField = 'LkpCodLabelerLayout'
            DataSource = DscArticle
            DropDownRows = 10
            TabOrder = 7
          end
        end
        inherited GbxClassification: TGroupBox
          Width = 647
          inherited SvcDBMEIdtClassification: TSvcDBMaskEdit
            Properties.MaxLength = 15
          end
        end
        inherited GbxVAT: TGroupBox
          Width = 647
        end
        inherited GbxMainPLU: TGroupBox
          Width = 647
          inherited SvcDBLblFlgKlapper: TSvcDBLabelLoaded
            StoredProc = DmdFpnUtils.SprCnvApplicText
          end
          inherited SvcLFArtPLUNumPLU: TSvcLocalField
            Epoch = 0
          end
        end
        inherited GbxIdtOrderBook: TGroupBox
          Width = 647
        end
      end
    end
    inherited TabShtArtPLU: TTabSheet
      inherited SbxArtPLU: TScrollBox
        Width = 647
        Height = 335
        inherited DBGrdArtPLU: TDBGrid
          Width = 543
          Height = 335
        end
        inherited PnlBtnArtPLU: TPanel
          Left = 543
          Height = 335
        end
      end
    end
    inherited TabShtArtSupplier: TTabSheet
      inherited SbxSupplier: TScrollBox
        Width = 647
        Height = 335
        inherited DBGrdArtSupplier: TDBGrid
          Width = 543
          Height = 335
        end
        inherited PnlBtnArtSupplier: TPanel
          Left = 543
          Height = 335
        end
      end
    end
    inherited TabShtArtPrice: TTabSheet
      inherited SbxArtPrice: TScrollBox
        Width = 647
        Height = 335
        inherited PnlBtnArtPrice: TPanel
          Left = 543
          Height = 335
          inherited PnlPriceTypes: TPanel
            Top = 192
          end
        end
        inherited DBGrdArtPrice: TDBGrid
          Width = 543
          Height = 335
        end
      end
    end
    inherited TabShtPromoPack: TTabSheet
      inherited SbxPromoPack: TScrollBox
        Width = 647
        Height = 342
        inherited DBGrdPromoArt: TDBGrid
          Width = 543
          Height = 342
        end
        inherited PnlBtnPromoPack: TPanel
          Left = 543
          Height = 342
        end
      end
    end
    inherited TabShtGeneral: TTabSheet
      Caption = 'General (1)'
      inherited SbxGeneral: TScrollBox
        Width = 647
        Height = 335
        inherited GbxDiv: TGroupBox
          Width = 647
          inherited SvcDBMEIdtArtMake: TSvcDBMaskEdit
            Properties.MaxLength = 10
          end
        end
        inherited GbxGeneral: TGroupBox
          Width = 647
          inherited SvcDBMEIdtArtMain: TSvcDBMaskEdit
            Properties.MaxLength = 14
          end
        end
        inherited GbxDates: TGroupBox
          Width = 647
          inherited SvcDBLFDatCreate: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFDatModify: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFDatOutAssort: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
        end
        object GbxImport: TGroupBox
          Left = 0
          Top = 188
          Width = 647
          Height = 61
          Align = alTop
          TabOrder = 3
          object SvcDBLblCodCountry: TSvcDBLabelLoaded
            Left = 8
            Top = 16
            Width = 60
            Height = 13
            Caption = 'ISO Country:'
            IdtLabel = 'SvcDBLblCodCountry'
          end
          object SvcDBLblNumberGTD: TSvcDBLabelLoaded
            Left = 8
            Top = 40
            Width = 64
            Height = 13
            Caption = 'GTD number:'
            IdtLabel = 'SvcDBLblNumberGTD'
          end
          object SvcDBMEISOCountry: TSvcDBMaskEdit
            Left = 128
            Top = 12
            DataBinding.DataField = 'TxtISOCountry'
            DataBinding.DataSource = DscArticle
            Properties.MaxLength = 15
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 0
            Width = 129
          end
          object SvcDBMEGTDNumber: TSvcDBMaskEdit
            Left = 128
            Top = 36
            DataBinding.DataField = 'NumGTD'
            DataBinding.DataSource = DscArticle
            Properties.MaxLength = 32
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 1
            Width = 129
          end
        end
        object GbxEcoTax: TGroupBox
          Left = 0
          Top = 249
          Width = 647
          Height = 40
          Align = alTop
          TabOrder = 4
          object SvcDBLblPrcD3E: TSvcDBLabelLoaded
            Left = 336
            Top = 16
            Width = 62
            Height = 13
            Caption = 'Price ecotax:'
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'PrcD3E'
          end
          object SvcDBLblFlgD3E: TSvcDBLabelLoaded
            Left = 8
            Top = 16
            Width = 36
            Height = 13
            Caption = 'Ecotax:'
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'FlgD3E'
          end
          object DBChkBxD3E: TDBCheckBox
            Left = 128
            Top = 15
            Width = 17
            Height = 17
            Caption = '|'
            DataField = 'FlgD3E'
            DataSource = DscArticle
            TabOrder = 0
            ValueChecked = '1'
            ValueUnchecked = '0'
            OnClick = DBChkBxD3EClick
          end
          object SvcDBLFPrcD3E: TSvcDBLocalField
            Left = 456
            Top = 12
            Width = 81
            Height = 21
            DataField = 'PrcD3E'
            DataSource = DscArticle
            FieldType = ftBCD
            AutoSize = False
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
            PictureMask = 'iiiiiii.ii'
            TabOrder = 1
            LocalOptions = []
            Local = False
            RangeHigh = {E075587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
        end
        object GbxPCB: TGroupBox
          Left = 0
          Top = 329
          Width = 647
          Height = 42
          Align = alTop
          TabOrder = 6
          object SvcDBLblQtyPCB: TSvcDBLabelLoaded
            Left = 8
            Top = 16
            Width = 66
            Height = 13
            Caption = 'Quantity PCB:'
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'QtyPCB'
          end
          object SvcDBLFQtyPCB: TSvcDBLocalField
            Left = 128
            Top = 12
            Width = 81
            Height = 21
            DataField = 'QtyPCB'
            DataSource = DscArticle
            FieldType = ftBCD
            AutoSize = False
            CaretOvr.Shape = csBlock
            Controller = OvcCtlDetail
            EFColors.Disabled.BackColor = clWindow
            EFColors.Disabled.TextColor = clGrayText
            EFColors.Error.BackColor = clRed
            EFColors.Error.TextColor = clBlack
            EFColors.Highlight.BackColor = clHighlight
            EFColors.Highlight.TextColor = clHighlightText
            MaxLength = 11
            Options = [efoCaretToEnd]
            PictureMask = 'iiiiiii.iii'
            TabOrder = 0
            LocalOptions = []
            Local = False
            RangeHigh = {E075587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
        end
        object GbxMOBTax: TGroupBox
          Left = 0
          Top = 289
          Width = 659
          Height = 40
          Align = alTop
          TabOrder = 5
          object SvcDBLblFlgMOB: TSvcDBLabelLoaded
            Left = 8
            Top = 16
            Width = 45
            Height = 13
            Caption = 'MOBTax:'
            IdtLabel = 'FlgMOB'
          end
          object SvcDBLblPrcMOB: TSvcDBLabelLoaded
            Left = 336
            Top = 16
            Width = 72
            Height = 13
            Caption = 'Price MOBTax:'
            IdtLabel = 'PrcMOB'
          end
          object DBChkBxMOB: TDBCheckBox
            Left = 128
            Top = 15
            Width = 17
            Height = 17
            DataField = 'FlgMOB'
            DataSource = DscArticle
            Enabled = False
            TabOrder = 0
            ValueChecked = '1'
            ValueUnchecked = '0'
            OnClick = DBChkBxMOBClick
          end
          object SvcDBLFPrcMOB: TSvcDBLocalField
            Left = 456
            Top = 12
            Width = 81
            Height = 21
            DataField = 'PrcMOB'
            DataSource = DscArticle
            FieldType = ftBCD
            AutoSize = False
            CaretOvr.Shape = csBlock
            Controller = OvcCtlDetail
            EFColors.Disabled.BackColor = clWindow
            EFColors.Disabled.TextColor = clGrayText
            EFColors.Error.BackColor = clRed
            EFColors.Error.TextColor = clBlack
            EFColors.Highlight.BackColor = clHighlight
            EFColors.Highlight.TextColor = clHighlightText
            Enabled = False
            MaxLength = 10
            Options = [efoCaretToEnd]
            PictureMask = 'iiiiiii.ii'
            TabOrder = 1
            LocalOptions = []
            Local = False
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
        end
      end
    end
    inherited TabShtArtStockInvent: TTabSheet
      inherited SbxArtStockInvent: TScrollBox
        Width = 647
        Height = 335
        inherited GbxArtShelf: TGroupBox
          Width = 647
          Height = 213
          inherited PnlBtnArtShelf: TPanel
            Left = 541
            Height = 196
          end
          inherited DBGrdArtShelf: TDBGrid
            Width = 539
            Height = 196
          end
        end
        inherited GbxIdtShelf: TGroupBox
          Width = 647
          inherited PnlIdtShelfCombo: TPanel
            Width = 643
          end
          inherited PnlIdtShelfSelect: TPanel
            Width = 643
          end
          inherited PnlQtyFacing: TPanel
            Width = 643
            inherited SvcLFArtShelfQtyFacing: TSvcLocalField
              Epoch = 0
              RangeHigh = {FFFFFF7F000000000000}
              RangeLow = {00000000000000000000}
            end
          end
        end
        inherited PnlStockInvent: TPanel
          Width = 647
          inherited GbxArtInvent: TGroupBox
            Width = 326
          end
        end
      end
    end
    inherited TabShtDiscount: TTabSheet
      inherited SbxDiscount: TScrollBox
        Width = 647
        Height = 342
        inherited SptDiscount: TSplitter
          Width = 647
        end
        inherited DBGrdDiscountArtSupplier: TDBGrid
          Width = 647
        end
        inherited DBGrdDiscFactor: TDBGrid
          Width = 659
          Height = 245
          Columns = <
            item
              Expanded = False
              FieldName = 'LkpCodLevel'
              Title.Caption = 'Level'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'IdtDiscount'
              Title.Caption = 'Discount identification'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FlgApply'
              Title.Caption = 'Apply'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'LkpCodType'
              Title.Caption = 'Type'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Val1Factor'
              Title.Alignment = taRightJustify
              Title.Caption = 'Param 1'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Val2Factor'
              Title.Alignment = taRightJustify
              Title.Caption = 'Param 2'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'LkpIdtCurrencyIdtCurrency'
              Title.Caption = 'Currency'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DatBegin'
              Title.Caption = 'Begin date'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DatEnd'
              Title.Caption = 'End date'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'LkpCodApply'
              Title.Caption = 'Apply on'
              Visible = True
            end>
        end
      end
    end
    inherited TabShtArtColl: TTabSheet
      inherited SbxArtColl: TScrollBox
        Width = 647
        Height = 335
        inherited DBGrdArtColl: TDBGrid
          Width = 647
          Height = 207
        end
        inherited GbxIdtArticleArtColl: TGroupBox
          Width = 647
          inherited SvcLFQtyInColl: TSvcLocalField
            Epoch = 0
            RangeHigh = {FFFFFF7F000000000000}
            RangeLow = {01000000000000000000}
          end
        end
        inherited GbxIdtArtColl: TGroupBox
          Width = 647
        end
      end
    end
    inherited TabShtContribution: TTabSheet
      inherited SbxContribution: TScrollBox
        Width = 647
        Height = 335
        inherited GbxDeposit: TGroupBox
          Width = 647
        end
        inherited GbxRecycle: TGroupBox
          Width = 647
        end
      end
    end
    object TabShtGeneral2: TTabSheet
      Caption = 'General (2)'
      ImageIndex = 10
      object SbxGeneral2: TScrollBox
        Left = 0
        Top = 0
        Width = 647
        Height = 335
        Align = alClient
        BorderStyle = bsNone
        TabOrder = 0
        object GbxServiceArticle: TGroupBox
          Left = 0
          Top = 0
          Width = 647
          Height = 40
          Align = alTop
          TabOrder = 0
          object SvcDBLblCodType: TSvcDBLabelLoaded
            Left = 8
            Top = 16
            Width = 39
            Height = 13
            Caption = 'Codtype'
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'CodType'
          end
          object SvcDBLblFlgComment: TSvcDBLabelLoaded
            Left = 456
            Top = 16
            Width = 47
            Height = 13
            Caption = 'Comment:'
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'FlgComment'
          end
          object DBChkBxComment: TDBCheckBox
            Left = 520
            Top = 15
            Width = 17
            Height = 17
            Caption = '|'
            DataField = 'FlgComment'
            DataSource = DscArticle
            TabOrder = 0
            ValueChecked = '1'
            ValueUnchecked = '0'
            OnClick = DBChkBxD3EClick
          end
          object DBLkpCbxCodType: TDBLookupComboBox
            Left = 130
            Top = 11
            Width = 303
            Height = 21
            DataField = 'LkpCodType'
            DataSource = DscArticle
            DropDownRows = 3
            TabOrder = 1
          end
        end
      end
    end
  end
  inherited StsBarInfo: TStatusBar
    Top = 457
    Width = 655
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
  inherited DscArtPLU: TDataSource
    Top = 424
  end
  inherited DscArticle: TDataSource
    Top = 424
  end
  inherited DscArtAssort: TDataSource
    Top = 424
  end
  inherited DscArtPrice: TDataSource
    Top = 424
  end
  inherited DscArtSupplier: TDataSource
    Top = 424
  end
  inherited DscPromoArt: TDataSource
    Left = 328
    Top = 424
  end
  inherited DscDiscount: TDataSource
    Top = 424
  end
  inherited DscDiscFactor: TDataSource
    Top = 424
  end
  inherited DscContribAssort: TDataSource
    Left = 604
    Top = 382
  end
end
