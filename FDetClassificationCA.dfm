inherited FrmDetClassificationCA: TFrmDetClassificationCA
  PixelsPerInch = 96
  TextHeight = 13
  inherited PgeCtlDetail: TPageControl
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        inherited GbxLevel: TGroupBox
          inherited PnlIdtMember: TPanel
            inherited SvcDBLFIdtMember: TSvcDBLocalField
              Epoch = 0
              RangeHigh = {FFFFFF7F000000000000}
              RangeLow = {01000000000000000000}
            end
          end
        end
        inherited PnlClassAssort: TPanel
          inherited GbxPrices: TGroupBox
            inherited SvcDBLFPrcSaleMax: TSvcDBLocalField
              Epoch = 0
              RangeHigh = {E175587FED2AB1ECFE7F}
              RangeLow = {E175587FED2AB1ECFEFF}
            end
            inherited SvcDBLFPrcSaleMin: TSvcDBLocalField
              Epoch = 0
              RangeHigh = {E175587FED2AB1ECFE7F}
              RangeLow = {E175587FED2AB1ECFEFF}
            end
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
