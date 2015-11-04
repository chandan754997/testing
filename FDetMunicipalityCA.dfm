inherited FrmDetMunicipalityCA: TFrmDetMunicipalityCA
  Left = 249
  Top = 157
  Width = 491
  Height = 257
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    Width = 483
  end
  inherited PnlBottom: TPanel
    Top = 179
    Width = 483
    inherited PnlBottomRight: TPanel
      Left = 295
    end
    inherited PnlBtnAdd: TPanel
      Left = 199
    end
  end
  inherited PgeCtlDetail: TPageControl
    Width = 483
    Height = 117
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        Width = 475
        Height = 89
        inherited GbxCountry: TGroupBox
          Width = 475
          inherited DBLkpCbxIdtCountry: TDBLookupComboBox
            Width = 283
          end
        end
      end
    end
  end
  inherited StsBarInfo: TStatusBar
    Top = 211
    Width = 483
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
