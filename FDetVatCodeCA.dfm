inherited FrmDetVATCodeCA: TFrmDetVATCodeCA
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    inherited SvcDBLFIdtVATCode: TSvcDBLocalField
      Epoch = 0
      RangeHigh = {FFFFFF7F000000000000}
      RangeLow = {00000000000000000000}
    end
    inherited SvcDBLFNumVATCodeOne: TSvcDBLocalField
      Epoch = 0
      RangeHigh = {0B000000000000000000}
      RangeLow = {00000000000000000000}
    end
  end
  inherited PgeCtlDetail: TPageControl
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        Height = 223
        inherited GbxPctVAT: TGroupBox
          inherited SvcDBLFPctVAT: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {00000000000000C80540}
            RangeLow = {00000000000000000000}
          end
        end
        inherited GbxNumVATCode: TGroupBox
          inherited SvcDBLFNumVATCode: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {0B000000000000000000}
            RangeLow = {00000000000000000000}
          end
        end
        inherited GbxPctVATNew: TGroupBox
          inherited SvcDBLFPctVATNew: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {00000000000000C80540}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFDatBeginPctVATNew: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
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
