inherited FrmDetArtPLUCA: TFrmDetArtPLUCA
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    inherited SvcDBLFNumPLU: TSvcDBLocalField
      Epoch = 0
    end
  end
  inherited PgeCtlDetail: TPageControl
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        inherited SvcDBLblFlgKlapper: TSvcDBLabelLoaded
          StoredProc = DmdFpnUtils.SprCnvApplicText
        end
        inherited SvcDBLFDatOutAssort: TSvcDBLocalField
          Epoch = 0
          RangeHigh = {25600D00000000000000}
          RangeLow = {591D0100000000000000}
        end
        inherited SvcDBLFDatCreate: TSvcDBLocalField
          Epoch = 0
          RangeHigh = {25600D00000000000000}
          RangeLow = {591D0100000000000000}
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
