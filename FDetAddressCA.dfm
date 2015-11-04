inherited FrmDetAddressCA: TFrmDetAddressCA
  Left = 32
  Top = 124
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    inherited SvcDBLFIdtAddress: TSvcDBLocalField
      Epoch = 0
      RangeHigh = {FFFFFF7F000000000000}
      RangeLow = {01000000000000000000}
    end
    inherited SvcDBMETxtName: TSvcDBMaskEdit
      Properties.MaxLength = 38
    end
  end
  inherited PgeCtlDetail: TPageControl
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        inherited GbxTitleLang: TGroupBox
          inherited SvcDBMETxtTitle: TSvcDBMaskEdit
            Properties.MaxLength = 10
          end
        end
        inherited GbxAdressInfo: TGroupBox
          inherited SvcDBMETxtStreet: TSvcDBMaskEdit
            Properties.MaxLength = 38
          end
          inherited SvcDBMETxtNumHouse: TSvcDBMaskEdit
            Properties.MaxLength = 4
          end
          inherited SvcDBMETxtNumBox: TSvcDBMaskEdit
            Properties.MaxLength = 4
          end
          inherited SvcMEMunicipalityTxtCodPost: TSvcMaskEdit
            Properties.MaxLength = 10
          end
          inherited SvcMECountryTxtName: TSvcMaskEdit
            Properties.MaxLength = 30
          end
        end
        inherited GbxPhoneFaxEmail: TGroupBox
          inherited SvcDBMETxtNumPhone: TSvcDBMaskEdit
            Properties.MaxLength = 20
          end
          inherited SvcDBMETxtNumFax: TSvcDBMaskEdit
            Properties.MaxLength = 20
          end
          inherited SvcDBMETxtEmail: TSvcDBMaskEdit
            Properties.MaxLength = 50
          end
          inherited SvcDBMETxtNumGSM: TSvcDBMaskEdit
            Properties.MaxLength = 20
          end
        end
        inherited GbxTxtDescr: TGroupBox
          inherited SvcDBMETxtDescr: TSvcDBMaskEdit
            Properties.MaxLength = 30
          end
        end
      end
    end
    inherited TabShtInformation: TTabSheet
      inherited SbxInformation: TScrollBox
        inherited GbxNumVATBank: TGroupBox
          inherited SvcDBMETxtNumVAT: TSvcDBMaskEdit
            Properties.MaxLength = 38
          end
          inherited SvcDBMETxtNumBank: TSvcDBMaskEdit
            Properties.MaxLength = 20
          end
        end
        inherited GbxIdtCustomer: TGroupBox
          inherited SvcDBLFIdtCustomer: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {FFFFFF7F000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcMECustomerTxtPublName: TSvcMaskEdit
            Properties.MaxLength = 30
          end
        end
        inherited GbxIdtSupplier: TGroupBox
          inherited SvcDBLFIdtSupplier: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {FFFFFF7F000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcMESupplierTxtPublName: TSvcMaskEdit
            Properties.MaxLength = 30
          end
        end
        inherited GbxDatBirth: TGroupBox
          inherited SvcDBLFDatBirth: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBMETxtPassPort: TSvcDBMaskEdit
            Properties.MaxLength = 40
          end
        end
        inherited GbxDatCreateModify: TGroupBox
          inherited SvcDBLFDatModify: TSvcDBLocalField
            DataField = 'DatCreate'
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFDatCreate: TSvcDBLocalField
            DataField = 'DatModify'
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
    Left = 448
  end
end
