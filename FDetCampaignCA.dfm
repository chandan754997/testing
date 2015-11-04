inherited FrmDetCampaignCA: TFrmDetCampaignCA
  PixelsPerInch = 96
  TextHeight = 13
  inherited PgeCtlDetail: TPageControl
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        inherited GbxCampaignInfo: TGroupBox
          inherited LblEnd: TLabel
            Left = 248
          end
          inherited LblDate: TLabel
            Width = 23
            Caption = 'Date'
          end
          inherited LblBeginLog: TLabel
            Left = 400
          end
          inherited LblEndLog: TLabel
            Left = 512
          end
          inherited SvcDBLFDatBegin: TSvcDBLocalField
            Width = 80
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFDatEnd: TSvcDBLocalField
            Left = 248
            Width = 80
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFHouBegin: TSvcDBLocalField
            Width = 80
            Epoch = 0
            RangeHigh = {7F510100000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFHouEnd: TSvcDBLocalField
            Left = 248
            Width = 80
            Epoch = 0
            RangeHigh = {7F510100000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFDatBeginLog: TSvcDBLocalField
            Left = 400
            Width = 80
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFDatEndLog: TSvcDBLocalField
            Left = 512
            Width = 80
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
        end
        inherited GbxDates: TGroupBox
          inherited SvcDBLblDatModify: TSvcDBLabelLoaded
            Left = 248
          end
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
        inherited GbxSynchronize: TGroupBox
          inherited LblSyncBegin: TLabel
            Width = 111
            Height = 26
          end
          inherited LblSyncEnd: TLabel
            Left = 248
            Width = 103
            Height = 26
          end
          inherited LblMsgSynchronize: TLabel
            Left = 496
            Top = 16
            Width = 121
          end
          inherited ChlSyncBegin: TCheckListBox
            Left = 128
            Width = 113
          end
          inherited ChlSyncEnd: TCheckListBox
            Left = 368
            Width = 113
          end
          inherited RgpSyncBegin: TRadioGroup
            Width = 235
          end
          inherited RgpSyncEnd: TRadioGroup
            Left = 248
            Width = 235
          end
          inherited BtnSynchronize: TBitBtn
            Left = 488
            Width = 126
          end
        end
      end
    end
    inherited TabShtArtPrice: TTabSheet
      inherited SbxArtPrice: TScrollBox
        inherited DBGrdArtPrice: TDBGrid
          Columns = <
            item
              Expanded = False
              FieldName = 'IdtArticle'
              Title.Caption = 'Article'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TxtPublDescr'
              Title.Caption = 'Description'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CodTypeAsTxtShort'
              Title.Caption = 'Kind price'
              Width = 83
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'IdtType'
              Title.Caption = 'Kind-identification'
              Width = 90
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DatBeginAsDate'
              Title.Alignment = taRightJustify
              Title.Caption = 'Initial date'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'DatEndAsDate'
              Title.Alignment = taRightJustify
              Title.Caption = 'End date'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'PrcUnit'
              Title.Alignment = taRightJustify
              Title.Caption = 'Price/unit'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'IdtCurrency'
              Title.Caption = 'Currency'
              Visible = True
            end>
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
  inherited PmuSynchronize: TPopupMenu
    Left = 580
    Top = 15
  end
end
