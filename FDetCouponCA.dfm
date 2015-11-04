inherited FrmDetCouponCA: TFrmDetCouponCA
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    inherited SvcDBLFIdtCoupon: TSvcDBLocalField
      Epoch = 0
      RangeHigh = {CF070000000000000000}
      RangeLow = {01000000000000000000}
    end
  end
  inherited PnlBottom: TPanel
    inherited PnlBottomRight: TPanel
      Left = 442
    end
    inherited PnlBtnAdd: TPanel
      Left = 346
    end
  end
  inherited PgeCtlDetail: TPageControl
    ActivePage = TabShtCommon
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        Width = 622
        Height = 314
        inherited GbxClassification: TGroupBox
          Width = 624
        end
        inherited GbxDayValid: TGroupBox
          Width = 624
          inherited SvcDBLblValCoupon: TSvcDBLabelLoaded
            Width = 81
            Caption = 'Valeur en argent:'
          end
          object SvcDBLabelLoaded1: TSvcDBLabelLoaded [4]
            Left = 309
            Top = 16
            Width = 91
            Height = 13
            Caption = 'Enddate validation:'
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'DatEndValidity'
          end
          inherited SvcDBLFValCoupon: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFQtyDayValid: TSvcDBLocalField
            Epoch = 0
            MaxLength = 2
            PictureMask = '99'
            OnUserValidation = SvcDBLFQtyDayValidUserValidation
            RangeHigh = {FFFFFF7F000000000000}
            RangeLow = {00000000000000000000}
          end
          object SvcDBLFDatEndValidity: TSvcDBLocalField
            Left = 474
            Top = 12
            Width = 80
            Height = 21
            DataField = 'DatEndValidity'
            DataSource = DscCoupon
            FieldType = ftDateTime
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
            PictureMask = 'MM/DD/yyyy'
            TabOrder = 3
            LocalOptions = [ldoForceCentury]
            Local = True
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
        end
        inherited GbxConsumer: TGroupBox
          Width = 624
        end
        inherited GbxDates: TGroupBox
          Width = 624
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
        end
        inherited GbxLogo: TGroupBox
          Width = 624
          inherited SvcDBMETxtLogo: TSvcDBMaskEdit
            Properties.OnEditValueChanged = SvcDBMETxtLogoPropertiesEditValueChanged
          end
        end
      end
    end
    inherited TabShtPoints: TTabSheet
      inherited SbxPoints: TScrollBox
        inherited GbxQtyPntSaveUp: TGroupBox
          inherited SvcDBLFQtyPntSaveUp: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {FFFFFF7F000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFQtyPntSign: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {FFFFFF7F000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFQtyPntStart: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {FFFFFF7F000000000000}
            RangeLow = {00000000000000000000}
          end
        end
      end
    end
    inherited TabShtPromoPack: TTabSheet
      inherited SbxPromoPack: TScrollBox
        Width = 622
        Height = 314
        inherited DBGrdPromoPack: TDBGrid
          Width = 622
          Height = 314
        end
      end
    end
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
end
