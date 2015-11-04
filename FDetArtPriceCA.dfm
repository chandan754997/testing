inherited FrmDetArtPriceCA: TFrmDetArtPriceCA
  Left = 219
  Top = 82
  Width = 667
  Height = 526
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    Width = 659
    inherited SvcDBMEIdtArticle: TSvcDBMaskEdit
      Properties.MaxLength = 14
    end
  end
  inherited PnlBottom: TPanel
    Top = 448
    Width = 659
    inherited PnlBottomRight: TPanel
      Left = 471
    end
    inherited PnlBtnAdd: TPanel
      Left = 375
    end
  end
  inherited PgeCtlDetail: TPageControl
    Width = 659
    Height = 390
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        Width = 651
        Height = 362
        HorzScrollBar.Range = 420
        VertScrollBar.Position = 0
        inherited GbxPriceKind: TGroupBox
          Top = 0
          Width = 651
          inherited SvcDBLFIdtCustomer: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {FFFFFF7F000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFIdtSupplier: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {FFFFFF7F000000000000}
            RangeLow = {00000000000000000000}
          end
        end
        inherited GbxMisc: TGroupBox
          Top = 171
          Width = 651
          inherited PnlExcise: TPanel
            Width = 647
            inherited SvcDBLFValExcise: TSvcDBLocalField
              Epoch = 0
              RangeHigh = {E175587FED2AB1ECFE7F}
              RangeLow = {00000000000000000000}
            end
            inherited SvcLFValExcise: TSvcLocalField
              Epoch = 0
              RangeHigh = {73B2DBB9838916F2FE43}
              RangeLow = {73B2DBB9838916F2FEC3}
            end
          end
          inherited PnlQtyAmount: TPanel
            Width = 647
            inherited SvcDBLFQtyPrcAmount: TSvcDBLocalField
              Epoch = 0
              RangeHigh = {FF000000000000000000}
              RangeLow = {00000000000000000000}
            end
          end
          inherited PnlIndivUnits: TPanel
            Width = 647
            inherited SvcDBLFQtyIndiv: TSvcDBLocalField
              Epoch = 0
              RangeHigh = {FF000000000000000000}
              RangeLow = {01000000000000000000}
            end
          end
        end
        inherited GbxCampaign: TGroupBox
          Top = 68
          Width = 651
          inherited SvcDBLFNumPrior: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {FF000000000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBMEIdtCampaign: TSvcDBMaskEdit
            Properties.MaxLength = 10
          end
        end
        inherited GbxCurrency: TGroupBox
          Top = 131
          Width = 651
        end
        inherited GbxPrint: TGroupBox
          Top = 300
          Width = 651
        end
      end
    end
    inherited TabShtPrice: TTabSheet
      inherited SbxPrice: TScrollBox
        Width = 651
        Height = 362
        VertScrollBar.Position = 268
        inherited GbxPurchasePrice: TGroupBox
          Top = -268
          Width = 635
          inherited PnlPurchasePriceDiscount: TPanel
            Width = 631
            inherited SvcLFPPNetPrcUnit: TSvcLocalField
              Epoch = 0
              RangeHigh = {73B2DBB9838916F2FE43}
              RangeLow = {73B2DBB9838916F2FEC3}
            end
          end
          inherited PnlPurchasePriceInfo: TPanel
            Width = 631
            inherited SvcLFPPDatBegin: TSvcLocalField
              Epoch = 0
              RangeHigh = {25600D00000000000000}
              RangeLow = {00000000000000000000}
            end
            inherited SvcLFPPDatEnd: TSvcLocalField
              Epoch = 0
              RangeHigh = {25600D00000000000000}
              RangeLow = {00000000000000000000}
            end
            inherited SvcLFPPPrcUnit: TSvcLocalField
              Epoch = 0
              RangeHigh = {73B2DBB9838916F2FE43}
              RangeLow = {73B2DBB9838916F2FEC3}
            end
            inherited SvcLFPPPrcAmount: TSvcLocalField
              Epoch = 0
              RangeHigh = {73B2DBB9838916F2FE43}
              RangeLow = {73B2DBB9838916F2FEC3}
            end
          end
          inherited PnlNoPurchasePrice: TPanel
            Width = 631
          end
        end
        inherited GbxSalesPrice: TGroupBox
          Top = -180
          Width = 635
          inherited PnlNoSalesPrice: TPanel
            Width = 631
          end
          inherited PnlSalesPrice: TPanel
            Width = 631
            inherited SvcLFSPDatBegin: TSvcLocalField
              Epoch = 0
              RangeHigh = {25600D00000000000000}
              RangeLow = {00000000000000000000}
            end
            inherited SvcLFSPDatEnd: TSvcLocalField
              Epoch = 0
              RangeHigh = {25600D00000000000000}
              RangeLow = {00000000000000000000}
            end
            inherited SvcLFSPPctProfTargUnit: TSvcLocalField
              Epoch = 0
              RangeHigh = {FF673C9EC97F00000000}
              RangeLow = {FF673C9EC9FF00000000}
            end
            inherited SvcLFSPPctProfRealUnit: TSvcLocalField
              Epoch = 0
              RangeHigh = {FF673C9EC97F00000000}
              RangeLow = {FF673C9EC9FF00000000}
            end
            inherited SvcLFSPPrcUnit: TSvcLocalField
              Epoch = 0
              RangeHigh = {FF673C9EC97F00000000}
              RangeLow = {FF673C9EC9FF00000000}
            end
            inherited SvcLFSPPctProfTargAmount: TSvcLocalField
              Epoch = 0
              RangeHigh = {FF673C9EC97F00000000}
              RangeLow = {FF673C9EC9FF00000000}
            end
            inherited SvcLFSPPctProfRealAmount: TSvcLocalField
              Epoch = 0
              RangeHigh = {FF673C9EC97F00000000}
              RangeLow = {FF673C9EC9FF00000000}
            end
            inherited SvcLFSPPrcAmount: TSvcLocalField
              Epoch = 0
              RangeHigh = {FF673C9EC97F00000000}
              RangeLow = {FF673C9EC9FF00000000}
            end
          end
        end
        inherited GbxNewPurchasePrice: TGroupBox
          Top = -72
          Width = 635
          inherited SvcDBLFNPPDatBegin: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFNPPDatEnd: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFNPPPrcUnit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {E175587FED2AB1ECFEFF}
          end
          inherited SvcLFNPPPrcAmount: TSvcLocalField
            Epoch = 0
            RangeHigh = {FF673C9EC97F00000000}
            RangeLow = {FF673C9EC9FF00000000}
          end
          inherited PnlNewPurchasePriceDiscount: TPanel
            Width = 631
            inherited SvcLFNPPNetPrcUnit: TSvcLocalField
              Epoch = 0
              RangeHigh = {FF673C9EC97F00000000}
              RangeLow = {FF673C9EC9FF00000000}
            end
          end
        end
        inherited GbxNewSalesPrice: TGroupBox
          Top = 18
          Width = 635
          inherited SvcDBLFNSPDatBegin: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFNSPDatEnd: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFNSPPctProfTargUnit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {E175587FED2AB1ECFEFF}
          end
          inherited SvcDBLFNSPPctProfTargAmount: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {E175587FED2AB1ECFEFF}
          end
          inherited SvcDBLFNSPPrcUnit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {E175587FED2AB1ECFEFF}
          end
          inherited SvcDBLFNSPPrcAmount: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {E175587FED2AB1ECFEFF}
          end
          inherited SvcDBLFNSPPctProfRealUnit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {E175587FED2AB1ECFEFF}
          end
          inherited SvcDBLFNSPPctProfRealAmount: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {E175587FED2AB1ECFEFF}
          end
        end
        inherited GbxNewCampaignPrice: TGroupBox
          Top = 126
          Width = 635
          inherited SvcDBLFNCPDatBegin: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFNCPDatEnd: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFNCPPctProfTargUnit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {E175587FED2AB1ECFEFF}
          end
          inherited SvcDBLFNCPPrcUnit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {E175587FED2AB1ECFEFF}
          end
          inherited SvcDBLFNCPHouBegin: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {7F510100000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFNCPHouEnd: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {7F510100000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFNCPPctProfRealUnit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {E175587FED2AB1ECFEFF}
          end
        end
        inherited GbxNewCompetitorPrice: TGroupBox
          Top = 234
          Width = 635
          inherited SvcDBLFNCompPDatBegin: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFNCompPDatEnd: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFNCompPPrcUnit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {E175587FED2AB1ECFEFF}
          end
          inherited SvcDBLFNCompPPrcAmount: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {E175587FED2AB1ECFEFF}
          end
        end
        inherited GbxNewMiscellaneousPrice: TGroupBox
          Top = 297
          Width = 635
          inherited SvcDBLFNMiscPDatBegin: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFNMiscPDatEnd: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFNMiscPPrcUnit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {E175587FED2AB1ECFEFF}
          end
          inherited SvcDBLFNMiscPPrcAmount: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {E175587FED2AB1ECFEFF}
          end
        end
      end
    end
    inherited TabShtHistory: TTabSheet
      inherited SbxHistory: TScrollBox
        Width = 651
        Height = 362
        inherited PnlBtnArtPrice: TPanel
          Left = 547
          Height = 362
          inherited PnlPriceTypes: TPanel
            Top = 219
          end
        end
        inherited DBGrdHisArtPrice: TDBGrid
          Width = 547
          Height = 362
        end
      end
    end
    inherited TabShtDiscount: TTabSheet
      inherited SbxDiscount: TScrollBox
        Width = 651
        Height = 362
        inherited SptDiscount: TSplitter
          Width = 651
        end
        inherited DBGrdDiscountArtSupplier: TDBGrid
          Width = 651
        end
        inherited DBGrdDiscFactor: TDBGrid
          Width = 651
          Height = 222
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
              FieldName = 'LkpIdtCurrencyTxtCurrency'
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
  end
  inherited StsBarInfo: TStatusBar
    Top = 480
    Width = 659
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
