inherited FrmDetArtShelfCA: TFrmDetArtShelfCA
  PixelsPerInch = 96
  TextHeight = 13
  inherited PgeCtlDetail: TPageControl
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        inherited GbxFlgMain: TGroupBox
          inherited SvcDBLblQtyFacing: TSvcDBLabelLoaded
            StoredProc = DmdFpnUtils.SprCnvApplicText
          end
          inherited SvcDBLFQtyFacing: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {FFFFFF7F000000000000}
            RangeLow = {00000000000000000000}
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
