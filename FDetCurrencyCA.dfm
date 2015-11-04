inherited FrmDetCurrencyCA: TFrmDetCurrencyCA
  PixelsPerInch = 96
  TextHeight = 13
  inherited PgeCtlDetail: TPageControl
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        Height = 259
        inherited GbxCurrencyInfo: TGroupBox
          inherited SvcDBLblFlgExchMultiply: TSvcDBLabelLoaded
            Left = 248
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'FlgExchMultiply'
          end
          inherited SvcDBLFQtyDecim: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {04000000000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcLFValExchange: TSvcLocalField
            Epoch = 0
            RangeHigh = {00000000008024B40F40}
            RangeLow = {00000000000000000000}
          end
          inherited DBChxFlgExchMultiply: TDBCheckBox
            Left = 392
          end
        end
        inherited GbxDates: TGroupBox
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
        inherited GbxNumCurrency: TGroupBox
          inherited SvcDBLFNumCurrency: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {FFFFFF7F000000000000}
            RangeLow = {00000080000000000000}
          end
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
