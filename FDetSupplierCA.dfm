inherited FrmDetSupplierCA: TFrmDetSupplierCA
  Left = 260
  Top = 142
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    inherited SvcDBLFIdtSupplier: TSvcDBLocalField
      Epoch = 0
      RangeHigh = {FFFFFF7F000000000000}
      RangeLow = {00000000000000000000}
    end
  end
  inherited PgeCtlDetail: TPageControl
    ActivePage = TabShtAddress
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        inherited GbxDatCreateModify: TGroupBox
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
    inherited TabShtAddress: TTabSheet
      inherited SbxAddress: TScrollBox
        Height = 311
        inherited DBGrdAddress: TDBGrid
          Height = 311
        end
        inherited PnlBtnAddress: TPanel
          Height = 311
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
  inherited DscSupplier: TDataSource
    DataSet = DmdFpnSupplierCA.QryDetSupplier
  end
end
