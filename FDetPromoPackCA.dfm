inherited FrmDetPromoPackCA: TFrmDetPromoPackCA
  Width = 740
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    Width = 724
    object SvcDBLblPromoPackStatus: TSvcDBLabelLoaded [3]
      Left = 216
      Top = 8
      Width = 192
      Height = 16
      Caption = 'SvcDBLblPromoPackStatus'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      IdtLabel = 'SvcDBLblPromoPackStatus'
    end
    inherited SvcDBLFIdtPromoPack: TSvcDBLocalField
      Epoch = 0
      RangeHigh = {FFFF0000000000000000}
      RangeLow = {01000000000000000000}
    end
  end
  inherited PnlBottom: TPanel
    Width = 724
    inherited PnlBottomRight: TPanel
      Left = 536
      inherited BtnOK: TBitBtn
        OnClick = BtnOKClick
      end
    end
    inherited PnlBtnAdd: TPanel
      Left = 440
    end
    object BtnActivate: TBitBtn
      Left = 208
      Top = 4
      Width = 90
      Height = 25
      Caption = 'Activate'
      TabOrder = 4
      OnClick = BtnActivateClick
      Glyph.Data = {
        C6030000424DC603000000000000360000002800000010000000130000000100
        18000000000090030000C40E0000C40E00000000000000000000C1FCFFC1FDFE
        CCFCFED2FDFBB0C5C6A1A89153623A080B090002001304032C0304010000D1FF
        FFCEFDFEC9FAF6D0FEFDC7FFFACBFFFED0FAFFE3FFFF5D5C5E9C96770240007F
        E46E9CEA9A6E8C65230B021C0000CFE9EACAFBFFC2FDFECCFBFED2FEF6D0FCF9
        C8E2E26A76782B130A756D51007B0026F5235BF2537CE175000C003703010000
        00C2D8DCD3FFFFCEFDFDD1FFFFEDFFFF04040015060024080067623710700E1A
        D41F23E42944BA3E0010003C0D0737070A2608094F5959DAFEFACBFAFD1B2120
        2E2F2B211F0F1B0C00858248060C02022806002B03031D0152493F2310130900
        0025171511120EDDFFFFD1FAFDDBFFFFD7FFFFE8FFFFC9C8C89DAB75484A1C33
        16063107033405062C0A0C000003F1FFFFE7FFFFDBFFFFC2FFFFCFFFFFC1FDFE
        C8FFF4CDFBFFB0CAC8B4C79451673302110B031311180A0A380203050000D3FF
        FFD2FDFFCBFCFDCEFFFFCEFFFDC8FFFCCCFDF6E8FFFF000000CECBAD26675114
        817F087B812D807E030000200000BFCFCFCCFCFCC6FEFDD1FEFECEFFFCD1FDFE
        848C8F2D2B3157382BABA98724787100807C0083800B80810201003303030E00
        00464B49E6FFFFCBFEFEC9FCF7A1B9BA51494E553A2E3A17098185511B473F1C
        848014857E2B79720703033F070C380B0B5132304E5B57D0FFFFCEFEFC2C3731
        06100B0B160C1B150A7173350E1E070100000101010000006F5B481803011B12
        191B0C10000503DCFFFFC7FFFFCDFCFADCFFFDC3FEFDB0CBC96E713D18130242
        1C1435010D37050A300805000000DEFFFFCFFBFDD1FFFFD1FEFDCDFEFDC4FCFC
        C9FDF8D0FBFFC2CAC9848F65262629373E723133701F00213E0507090000DCFF
        FFCBFEFFC9FFF9CBFDFBC7FEFCCDFEFFD4FFFED0E7EA000000B0B08C070E453F
        40B14341BB5E51A6190005240200758C8BDDFFFFC4FFFBC3FAFACCFFFFD0FBFF
        4E52510E0000664D3ED4CFA5030842403BAB453EB5565CB70100153601002103
        01000000E0FFFFC0F3F5C6F9F7334442B8C1B9887C695C3E26D0C39502021E1E
        196A1B166B1C1950210E133906062B05058D666B747577E1FFFFD4FFFF829C98
        687F7D6D867D696865AFA380787B6E61666B52565A4B4544553F32080202818B
        89797F7E647D7DD5FFFFCAF9FBCFFFFFD0FDFFC6FEFBE4FFFF20292523352B22
        372C233A2E2B3630363931E2F7F7CFFFF9C7FFF9C8FEFFC3FDFFCAFFFECAFFFE
        CAFFFECAFFFECAFFFECAFFFECAFFFECAFFFECAFFFECAFFFECAFFFECAFFFECAFF
        FECAFFFECAFFFECAFFFE}
      Spacing = 2
    end
    object BtnDeactivate: TBitBtn
      Left = 312
      Top = 4
      Width = 90
      Height = 25
      Caption = 'Deactivate'
      TabOrder = 5
      OnClick = BtnDeactivateClick
      Glyph.Data = {
        76050000424D7605000000000000360000002800000015000000150000000100
        18000000000040050000C40E0000C40E00000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFE5E5FFAEAEFFA7A7FFA7A7FFA7A7FFA7A7FFA7A7FFA7A7
        FFA7A7FFAEAEFFE5E5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFE9E9FF6C6CFF0909FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0909FF6C6CFFE9E9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FDFDFFDEDEFF7575FF1111FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FF1111FF7575FFDEDEFFFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        DEDEFF6C6CFF1212FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FF0000FF1212FF6B6BFFDEDEFFFFFFFFFFFFFFFFFFFFFFE8E8FF
        7575FF1212FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FF0000FF0000FF1212FF7575FFE8E8FFFFFFFFFFE5E5FF6D6DFF
        1111FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FF0000FF0000FF0000FF1111FF6C6CFFE5E5FFFFAEAEFF0909FF
        0B0BFF4646FF7070FF5B5BFF0B0BFF0E0EFF6262FF2323FF0E0EFF5151FF7070
        FF5858FF0B0BFF5454FF3535FF0000FF0000FF0909FFAEAEFFFFA7A7FF0000FF
        4D4DFFB2B2FF5C5CFFC2C2FF7676FF2020FFDFDFFF5050FF6A6AFFB2B2FF5151
        FFDADAFF7070FFBFBFFF7777FF0000FF0000FF0000FFA7A7FFFFA7A7FF0000FF
        3636FF6C6CFF2A2AFFC5C5FF9090FF2020FFDFDFFF5050FF7F7FFFB0B0FF2020
        FFDFDFFF8888FFBFBFFF7777FF0000FF0000FF0000FFA7A7FFFFA7A7FF0000FF
        0000FF1212FF6B6BFFD7D7FF6E6EFF2020FFDFDFFF5050FF7F7FFFB0B0FF2020
        FFDFDFFF8888FFC3C3FF9D9DFF4848FF1B1BFF0000FFA7A7FFFFA7A7FF0000FF
        1515FF7373FFCDCDFF8585FF1B1BFF2020FFDFDFFF5050FF7F7FFFB0B0FF2020
        FFDFDFFF8888FFC5C5FFAAAAFF8F8FFF8484FF1818FFA7A7FFFFA7A7FF0000FF
        4C4CFFD0D0FF8E8EFF1818FF0000FF2020FFDFDFFF5050FF7F7FFFB0B0FF2020
        FFDFDFFF8888FFBFBFFF7777FF5F5FFFBFBFFF3030FFA7A7FFFFA7A7FF0000FF
        6060FFC8C8FF3B3BFF6D6DFF5151FF2020FFDFDFFF5050FF7F7FFFB0B0FF2020
        FFDFDFFF8888FFBFBFFF7777FF5F5FFFBFBFFF3030FFA7A7FFFFA7A7FF0000FF
        5050FFB8B8FF5E5EFFBCBCFF8A8AFF5151FFE6E6FF7777FF8686FFB2B2FF5151
        FFDADAFF6F6FFFC2C2FF9595FF8282FFAAAAFF2525FFA7A7FFFFAEAEFF0909FF
        0A0AFF4545FF6F6FFF5A5AFF3B3BFF6F6FFF6F6FFF6F6FFF4646FF5050FF6F6F
        FF5757FF0A0AFF5A5AFF6F6FFF6F6FFF2A2AFF0909FFAEAEFFFFE5E5FF6D6DFF
        1212FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FF0000FF0000FF0000FF1212FF6C6CFFE5E5FFFFFFFFFFE8E8FF
        7575FF1212FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FF0000FF0000FF1212FF7575FFE8E8FFFFFFFFFFFFFFFFFFFFFF
        DEDEFF6C6CFF1212FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FF0000FF1212FF6C6CFFDEDEFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FDFDFFDEDEFF7575FF1212FF0000FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0000FF1212FF7575FFDEDEFFFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFE9E9FF6D6DFF0909FF0000FF0000FF0000FF0000FF0000FF0000
        FF0000FF0909FF6D6DFFE9E9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFE6E6FFAEAEFFA7A7FFA7A7FFA7A7FFA7A7FFA7A7FFA7A7
        FFA7A7FFAEAEFFE6E6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    end
  end
  inherited PgeCtlDetail: TPageControl
    Width = 724
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        Width = 716
        inherited GbxExplanation: TGroupBox
          Width = 699
        end
        inherited GbxCodes: TGroupBox
          Width = 699
          inherited DBLkpCbxCodType: TDBLookupComboBox
            OnExit = DBLkpCbxCodTypeExit
          end
        end
        inherited GbxDates: TGroupBox
          Width = 699
          inherited SvcDBLFDatBegin: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFDatEnd: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {591D0100000000000000}
          end
          inherited SvcDBLFHouBegin: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {7F510100000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFHouEnd: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {7F510100000000000000}
            RangeLow = {00000000000000000000}
          end
        end
        inherited GbxTicket: TGroupBox
          Width = 699
          inherited SvcDBLFTxtCharTicket: TSvcDBLocalField
            Epoch = 0
          end
          inherited BtnSelectLogo: TBitBtn
            Enabled = False
          end
          inherited SvcDBMETxtLogo: TSvcDBMaskEdit
            Enabled = False
          end
        end
        inherited GbxClassification: TGroupBox
          Width = 699
        end
      end
    end
    inherited TabShtPromotion: TTabSheet
      inherited SbxPromotion: TScrollBox
        Width = 716
        VertScrollBar.Position = 1069
        VertScrollBar.Range = 1400
        inherited GbxPromoPctOnLimVal: TGroupBox
          Top = -1069
          Width = 699
          inherited SvcDBLFPctOnLimValValLimit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFPctOnLimValPctPromo: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {00000000000000C80540}
            RangeLow = {00000000000000000000}
          end
        end
        inherited GbxPromoPctOnLimQty: TGroupBox
          Top = -1004
          Width = 699
          inherited SvcDBLFPctOnLimQtyQtyLimit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFPctOnLimQtyPctPromo: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {00000000000000C80540}
            RangeLow = {00000000000000000000}
          end
        end
        inherited GbxPromoGratis: TGroupBox
          Top = -940
          Width = 699
          inherited SvcDBLFGratisQtyBase: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {000000000000FFFF0E40}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFGratisQtyGratis: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {000000000000FFFF0E40}
            RangeLow = {00000000000000000000}
          end
        end
        inherited GbxPromoValOnComb: TGroupBox
          Top = -876
          Width = 699
          inherited SvcDBLFValOnCombValPromo: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFValOnCombQty1Limit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFValOnCombQty2Limit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
        end
        inherited GbxPromoValOnLimVal: TGroupBox
          Top = -788
          Width = 699
          inherited SvcDBLFValOnLimValValLimit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFValOnLimValValPromo: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
        end
        inherited GbxPromoPoint: TGroupBox
          Top = -684
          Width = 699
          inherited SvcDBLFPointVal1Limit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFPointVal2Limit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFPointQtyPoint: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {000000000000FFFF0E40}
            RangeLow = {00000000000000000000}
          end
        end
        inherited GbxPromoHeart: TGroupBox
          Top = -548
          Width = 699
          inherited SvcDBLFHeartQty: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {000000000000FFFF0E40}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFHeartIdtCoup: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E7030000000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcMEHeartCouponTxtPublDescr: TSvcMaskEdit
            Properties.EditMask = ''
            Properties.MaxLength = 40
            Text = ''
          end
        end
        inherited GbxPromoGiftCoupon: TGroupBox
          Top = -484
          Width = 699
          inherited SvcDBLFGiftValCoup1Limit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFGiftValCoup2Limit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFGiftValCoup3Limit: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFGiftIdtCoup1: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E7030000000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFGiftIdtCoup2: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E7030000000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFGiftIdtCoup3: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E7030000000000000000}
            RangeLow = {00000000000000000000}
          end
        end
        inherited GbxPromoGiftComb: TGroupBox
          Top = -268
          Width = 699
          inherited SvcDBLFGiftCombVal1Comb: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFGiftCombVal2Comb: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFGiftCombVal3Comb: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFGiftCombIdtCoup: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E7030000000000000000}
            RangeLow = {00000000000000000000}
          end
        end
        inherited GbxPromoTryIt: TGroupBox
          Top = 6
          Width = 699
          inherited SvcDBLFTryItIdtCoup: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E7030000000000000000}
            RangeLow = {00000000000000000000}
          end
        end
        inherited GbxPromoBingoCustom: TGroupBox
          Top = 116
          Width = 699
          inherited SvcDBLFBingoCustomQty: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {000000000000FFFF0E40}
            RangeLow = {00000000000000000000}
          end
          inherited SvcDBLFBingoCustomIdtCoup: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {E7030000000000000000}
            RangeLow = {00000000000000000000}
          end
        end
        inherited GbxPromoBingo: TGroupBox
          Top = -724
          Width = 699
          inherited SvcDBLFBingoQtyBingo: TSvcDBLocalField
            Epoch = 0
            RangeHigh = {000000000000FFFF0E40}
            RangeLow = {00000000000000000000}
          end
        end
        object GbxCoupSlice: TGroupBox
          Left = 0
          Top = 52
          Width = 699
          Height = 64
          Align = alTop
          TabOrder = 12
          Visible = False
          object SvcDBLabelLoaded7: TSvcDBLabelLoaded
            Left = 8
            Top = 16
            Width = 81
            Height = 13
            Caption = 'Amount per slice:'
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'PromoSliceAmt'
          end
          object SvcDBLblCoupPerSlice: TSvcDBLabelLoaded
            Left = 8
            Top = 40
            Width = 40
            Height = 13
            Caption = 'Coupon:'
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'LnkCoupon'
          end
          object SvcDBLFAmtPerSlice: TSvcDBLocalField
            Left = 168
            Top = 11
            Width = 50
            Height = 21
            DataField = 'Val1PromoCrit'
            DataSource = DscPromoPack
            FieldType = ftBCD
            CaretOvr.Shape = csBlock
            Controller = OvcCtlDetail
            EFColors.Disabled.BackColor = clWindow
            EFColors.Disabled.TextColor = clGrayText
            EFColors.Error.BackColor = clRed
            EFColors.Error.TextColor = clBlack
            EFColors.Highlight.BackColor = clHighlight
            EFColors.Highlight.TextColor = clHighlightText
            MaxLength = 5
            Options = [efoRightAlign, efoRightJustify]
            PictureMask = '99999'
            TabOrder = 0
            OnEnter = PromoInclOneEnter
            LocalOptions = []
            Local = False
            RangeHigh = {000000000000FFFF0E40}
            RangeLow = {00000000000000000000}
          end
          object SvcDBLFCoupPerSlice: TSvcDBLocalField
            Left = 112
            Top = 35
            Width = 49
            Height = 21
            DataField = 'IdtCoup1PromoCrit'
            DataSource = DscPromoPack
            FieldType = ftInteger
            CaretOvr.Shape = csBlock
            Controller = OvcCtlDetail
            EFColors.Disabled.BackColor = clWindow
            EFColors.Disabled.TextColor = clGrayText
            EFColors.Error.BackColor = clRed
            EFColors.Error.TextColor = clBlack
            EFColors.Highlight.BackColor = clHighlight
            EFColors.Highlight.TextColor = clHighlightText
            MaxLength = 3
            Options = [efoRightAlign, efoRightJustify]
            PictureMask = '999'
            TabOrder = 1
            OnUserValidation = CouponUserValidation
            LocalOptions = []
            Local = False
            RangeHigh = {E7030000000000000000}
            RangeLow = {00000000000000000000}
          end
          object BtnSelectCoupPerSlice: TBitBtn
            Left = 528
            Top = 33
            Width = 90
            Height = 25
            Caption = 'Select...'
            TabOrder = 2
            OnClick = BtnSelectCouponClick
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              0400000000000001000000000000000000001000000010000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
              555555555555555555555555555555555555555555FF55555555555559055555
              55555555577FF5555555555599905555555555557777F5555555555599905555
              555555557777FF5555555559999905555555555777777F555555559999990555
              5555557777777FF5555557990599905555555777757777F55555790555599055
              55557775555777FF5555555555599905555555555557777F5555555555559905
              555555555555777FF5555555555559905555555555555777FF55555555555579
              05555555555555777FF5555555555557905555555555555777FF555555555555
              5990555555555555577755555555555555555555555555555555}
            Margin = 2
            NumGlyphs = 2
            Spacing = 2
          end
          object SvcMECoupPerSliceTxtPublDescr: TSvcMaskEdit
            Left = 168
            Top = 35
            Properties.MaxLength = 40
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 3
            Width = 353
          end
        end
        object GbxCoupTreshold: TGroupBox
          Left = 0
          Top = -156
          Width = 699
          Height = 162
          Align = alTop
          TabOrder = 13
          Visible = False
          object SvcDBLabelLoaded6: TSvcDBLabelLoaded
            Left = 8
            Top = 18
            Width = 111
            Height = 13
            Caption = 'Limit amount treshold 1:'
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'PromoVal1Treshold'
          end
          object SvcDBLblCoupTreshold1: TSvcDBLabelLoaded
            Left = 8
            Top = 42
            Width = 49
            Height = 13
            Caption = 'Coupon 1:'
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'PromoGiftIdt1Coup'
          end
          object SvcDBLabelLoaded10: TSvcDBLabelLoaded
            Left = 8
            Top = 66
            Width = 111
            Height = 13
            Caption = 'Limit amount treshold 2:'
            Visible = False
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'PromoGiftValCoup2Limit'
          end
          object SvcDBLblCoupTreshold2: TSvcDBLabelLoaded
            Left = 8
            Top = 89
            Width = 49
            Height = 13
            Caption = 'Coupon 2:'
            Visible = False
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'PromoGiftIdt2Coup'
          end
          object SvcDBLabelLoaded12: TSvcDBLabelLoaded
            Left = 8
            Top = 114
            Width = 111
            Height = 13
            Caption = 'Limit amount treshold 3:'
            Visible = False
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'PromoGiftValCoup3Limit'
          end
          object SvcDBLblCoupTreshold3: TSvcDBLabelLoaded
            Left = 8
            Top = 138
            Width = 49
            Height = 13
            Caption = 'Coupon 3:'
            Visible = False
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'PromoGiftIdt3Coup'
          end
          object LblIdtCurrency11: TLabel
            Left = 256
            Top = 19
            Width = 80
            Height = 13
            Caption = 'LblIdtCurrency11'
          end
          object LblIdtCurrency12: TLabel
            Left = 256
            Top = 67
            Width = 80
            Height = 13
            Caption = 'LblIdtCurrency12'
            Visible = False
          end
          object LblIdtCurrency13: TLabel
            Left = 256
            Top = 115
            Width = 80
            Height = 13
            Caption = 'LblIdtCurrency13'
            Visible = False
          end
          object SvcDBLFAmtTreshold1: TSvcDBLocalField
            Left = 168
            Top = 14
            Width = 81
            Height = 21
            DataField = 'Val1PromoCrit'
            DataSource = DscPromoPack
            FieldType = ftBCD
            CaretOvr.Shape = csBlock
            Controller = OvcCtlDetail
            EFColors.Disabled.BackColor = clWindow
            EFColors.Disabled.TextColor = clGrayText
            EFColors.Error.BackColor = clRed
            EFColors.Error.TextColor = clBlack
            EFColors.Highlight.BackColor = clHighlight
            EFColors.Highlight.TextColor = clHighlightText
            MaxLength = 4
            Options = [efoForceOvertype, efoRightAlign]
            PictureMask = 'i.ii'
            TabOrder = 0
            OnEnter = PromoExclZeroEnter
            LocalOptions = [ldoLimitValue]
            Local = True
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          object SvcDBLFAmtTreshold2: TSvcDBLocalField
            Left = 168
            Top = 62
            Width = 81
            Height = 21
            DataField = 'Val2PromoCrit'
            DataSource = DscPromoPack
            FieldType = ftBCD
            CaretOvr.Shape = csBlock
            Controller = OvcCtlDetail
            EFColors.Disabled.BackColor = clWindow
            EFColors.Disabled.TextColor = clGrayText
            EFColors.Error.BackColor = clRed
            EFColors.Error.TextColor = clBlack
            EFColors.Highlight.BackColor = clHighlight
            EFColors.Highlight.TextColor = clHighlightText
            MaxLength = 4
            Options = [efoForceOvertype, efoRightAlign]
            PictureMask = 'i.ii'
            TabOrder = 4
            Visible = False
            LocalOptions = [ldoLimitValue]
            Local = True
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          object SvcDBLFAmtTreshold3: TSvcDBLocalField
            Left = 168
            Top = 110
            Width = 81
            Height = 21
            DataField = 'Val3PromoCrit'
            DataSource = DscPromoPack
            FieldType = ftBCD
            CaretOvr.Shape = csBlock
            Controller = OvcCtlDetail
            EFColors.Disabled.BackColor = clWindow
            EFColors.Disabled.TextColor = clGrayText
            EFColors.Error.BackColor = clRed
            EFColors.Error.TextColor = clBlack
            EFColors.Highlight.BackColor = clHighlight
            EFColors.Highlight.TextColor = clHighlightText
            MaxLength = 4
            Options = [efoForceOvertype, efoRightAlign]
            PictureMask = 'i.ii'
            TabOrder = 8
            Visible = False
            LocalOptions = [ldoLimitValue]
            Local = True
            RangeHigh = {E175587FED2AB1ECFE7F}
            RangeLow = {00000000000000000000}
          end
          object SvcDBLFCoupTreshold1: TSvcDBLocalField
            Left = 126
            Top = 38
            Width = 35
            Height = 21
            DataField = 'IdtCoup1PromoCrit'
            DataSource = DscPromoPack
            FieldType = ftInteger
            CaretOvr.Shape = csBlock
            Controller = OvcCtlDetail
            EFColors.Disabled.BackColor = clWindow
            EFColors.Disabled.TextColor = clGrayText
            EFColors.Error.BackColor = clRed
            EFColors.Error.TextColor = clBlack
            EFColors.Highlight.BackColor = clHighlight
            EFColors.Highlight.TextColor = clHighlightText
            MaxLength = 3
            Options = [efoRightAlign, efoRightJustify]
            PictureMask = '999'
            TabOrder = 1
            OnUserValidation = CouponUserValidation
            LocalOptions = []
            Local = False
            RangeHigh = {E7030000000000000000}
            RangeLow = {00000000000000000000}
          end
          object BtnSelectCoupTreshold1: TBitBtn
            Left = 528
            Top = 36
            Width = 90
            Height = 25
            Caption = 'Select...'
            TabOrder = 3
            OnClick = BtnSelectCouponClick
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              0400000000000001000000000000000000001000000010000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
              555555555555555555555555555555555555555555FF55555555555559055555
              55555555577FF5555555555599905555555555557777F5555555555599905555
              555555557777FF5555555559999905555555555777777F555555559999990555
              5555557777777FF5555557990599905555555777757777F55555790555599055
              55557775555777FF5555555555599905555555555557777F5555555555559905
              555555555555777FF5555555555559905555555555555777FF55555555555579
              05555555555555777FF5555555555557905555555555555777FF555555555555
              5990555555555555577755555555555555555555555555555555}
            Margin = 2
            NumGlyphs = 2
            Spacing = 2
          end
          object SvcDBLFCoupTreshold2: TSvcDBLocalField
            Left = 126
            Top = 86
            Width = 35
            Height = 21
            DataField = 'IdtCoup2PromoCrit'
            DataSource = DscPromoPack
            FieldType = ftInteger
            CaretOvr.Shape = csBlock
            Controller = OvcCtlDetail
            EFColors.Disabled.BackColor = clWindow
            EFColors.Disabled.TextColor = clGrayText
            EFColors.Error.BackColor = clRed
            EFColors.Error.TextColor = clBlack
            EFColors.Highlight.BackColor = clHighlight
            EFColors.Highlight.TextColor = clHighlightText
            MaxLength = 3
            Options = [efoRightAlign, efoRightJustify]
            PictureMask = '999'
            TabOrder = 5
            Visible = False
            OnUserValidation = CouponUserValidation
            LocalOptions = []
            Local = False
            RangeHigh = {E7030000000000000000}
            RangeLow = {00000000000000000000}
          end
          object BtnSelectCoupTreshold2: TBitBtn
            Left = 528
            Top = 84
            Width = 90
            Height = 25
            Caption = 'Select...'
            TabOrder = 7
            Visible = False
            OnClick = BtnSelectCouponClick
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              0400000000000001000000000000000000001000000010000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
              555555555555555555555555555555555555555555FF55555555555559055555
              55555555577FF5555555555599905555555555557777F5555555555599905555
              555555557777FF5555555559999905555555555777777F555555559999990555
              5555557777777FF5555557990599905555555777757777F55555790555599055
              55557775555777FF5555555555599905555555555557777F5555555555559905
              555555555555777FF5555555555559905555555555555777FF55555555555579
              05555555555555777FF5555555555557905555555555555777FF555555555555
              5990555555555555577755555555555555555555555555555555}
            Margin = 2
            NumGlyphs = 2
            Spacing = 2
          end
          object SvcDBLFCoupTreshold3: TSvcDBLocalField
            Left = 126
            Top = 134
            Width = 35
            Height = 21
            DataField = 'IdtCoup3PromoCrit'
            DataSource = DscPromoPack
            FieldType = ftInteger
            CaretOvr.Shape = csBlock
            Controller = OvcCtlDetail
            EFColors.Disabled.BackColor = clWindow
            EFColors.Disabled.TextColor = clGrayText
            EFColors.Error.BackColor = clRed
            EFColors.Error.TextColor = clBlack
            EFColors.Highlight.BackColor = clHighlight
            EFColors.Highlight.TextColor = clHighlightText
            MaxLength = 3
            Options = [efoRightAlign, efoRightJustify]
            PictureMask = '999'
            TabOrder = 9
            Visible = False
            OnUserValidation = CouponUserValidation
            LocalOptions = []
            Local = False
            RangeHigh = {E7030000000000000000}
            RangeLow = {00000000000000000000}
          end
          object BtnSelectCoupTreshold3: TBitBtn
            Left = 528
            Top = 132
            Width = 90
            Height = 25
            Caption = 'Select...'
            TabOrder = 11
            Visible = False
            OnClick = BtnSelectCouponClick
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              0400000000000001000000000000000000001000000010000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
              555555555555555555555555555555555555555555FF55555555555559055555
              55555555577FF5555555555599905555555555557777F5555555555599905555
              555555557777FF5555555559999905555555555777777F555555559999990555
              5555557777777FF5555557990599905555555777757777F55555790555599055
              55557775555777FF5555555555599905555555555557777F5555555555559905
              555555555555777FF5555555555559905555555555555777FF55555555555579
              05555555555555777FF5555555555557905555555555555777FF555555555555
              5990555555555555577755555555555555555555555555555555}
            Margin = 2
            NumGlyphs = 2
            Spacing = 2
          end
          object SvcMECoupTreshold1TxtPublDescr: TSvcMaskEdit
            Left = 168
            Top = 38
            Properties.MaxLength = 40
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 2
            Width = 353
          end
          object SvcMECoupTreshold2TxtPublDescr: TSvcMaskEdit
            Left = 168
            Top = 86
            Properties.MaxLength = 40
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 6
            Visible = False
            Width = 353
          end
          object SvcMECoupTreshold3TxtPublDescr: TSvcMaskEdit
            Left = 168
            Top = 134
            Properties.MaxLength = 40
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 10
            Visible = False
            Width = 353
          end
        end
      end
    end
    inherited TabShtArticle: TTabSheet
      inherited SbxArticle: TScrollBox
        Width = 724
        Height = 318
        inherited DBGrdPromoArt: TDBGrid
          Width = 620
          Height = 318
        end
        inherited PnlBtnPromoArt: TPanel
          Left = 620
          Height = 318
        end
      end
    end
    inherited TabShtClassification: TTabSheet
      inherited SbxClassification: TScrollBox
        Width = 724
        Height = 318
        inherited DBGrdPromoClass: TDBGrid
          Width = 620
          Height = 318
        end
        inherited PnlBtnPromoClass: TPanel
          Left = 620
          Height = 318
        end
      end
    end
    object TabShtDate: TTabSheet
      Caption = 'Date'
      ImageIndex = 4
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 716
        Height = 305
        Align = alTop
        TabOrder = 0
        object SvcDBLblDateBegin: TSvcDBLabelLoaded
          Left = 8
          Top = 23
          Width = 51
          Height = 13
          Caption = 'Initial date:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'DatBegin'
        end
        object SvcDBLblDateEnd: TSvcDBLabelLoaded
          Left = 8
          Top = 47
          Width = 46
          Height = 13
          Caption = 'End date:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'DatEnd'
        end
        object SvcDBLabelLoaded3: TSvcDBLabelLoaded
          Left = 235
          Top = 23
          Width = 51
          Height = 13
          Caption = 'Initial hour:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'HouBegin'
        end
        object SvcDBLabelLoaded4: TSvcDBLabelLoaded
          Left = 235
          Top = 47
          Width = 43
          Height = 13
          Caption = 'Endhour:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'HouEnd'
        end
        object SvcDBLFDateBegin: TSvcDBLocalField
          Left = 112
          Top = 19
          Width = 80
          Height = 22
          DataField = 'DatBegin'
          DataSource = DscPromoPack
          FieldType = ftDateTime
          AutoSize = False
          CaretOvr.Shape = csBlock
          Controller = OvcCtlDetail
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          MaxLength = 10
          Options = [efoForceOvertype]
          PictureMask = 'dd/mm/yyyy'
          TabOrder = 0
          LocalOptions = [ldoForceCentury]
          Local = True
          RangeHigh = {25600D00000000000000}
          RangeLow = {591D0100000000000000}
        end
        object SvcDBLFDateEnd: TSvcDBLocalField
          Left = 112
          Top = 43
          Width = 80
          Height = 22
          DataField = 'DatEnd'
          DataSource = DscPromoPack
          FieldType = ftDateTime
          AutoSize = False
          CaretOvr.Shape = csBlock
          Controller = OvcCtlDetail
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          MaxLength = 10
          Options = [efoForceOvertype]
          PictureMask = 'dd/mm/yyyy'
          TabOrder = 1
          LocalOptions = [ldoForceCentury]
          Local = True
          RangeHigh = {25600D00000000000000}
          RangeLow = {591D0100000000000000}
        end
        object SvcDBLFHourBegin: TSvcDBLocalField
          Left = 315
          Top = 19
          Width = 80
          Height = 22
          DataField = 'HouBegin'
          DataSource = DscPromoPack
          FieldType = ftDateTime
          DateOrTime = ftUseTime
          AutoSize = False
          CaretOvr.Shape = csBlock
          Controller = OvcCtlDetail
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          MaxLength = 5
          Options = [efoForceOvertype]
          PictureMask = 'hh:mm'
          TabOrder = 2
          LocalOptions = []
          Local = True
          RangeHigh = {7F510100000000000000}
          RangeLow = {00000000000000000000}
        end
        object SvcDBLFHourEnd: TSvcDBLocalField
          Left = 315
          Top = 43
          Width = 80
          Height = 22
          DataField = 'HouEnd'
          DataSource = DscPromoPack
          FieldType = ftDateTime
          DateOrTime = ftUseTime
          AutoSize = False
          CaretOvr.Shape = csBlock
          Controller = OvcCtlDetail
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          MaxLength = 5
          Options = [efoForceOvertype]
          PictureMask = 'hh:mm'
          TabOrder = 3
          LocalOptions = []
          Local = True
          RangeHigh = {7F510100000000000000}
          RangeLow = {00000000000000000000}
        end
        object GroupBox2: TGroupBox
          Left = 424
          Top = 16
          Width = 185
          Height = 273
          Caption = 'Occurence'
          Ctl3D = True
          ParentCtl3D = False
          TabOrder = 4
          object RdbtnSingleOccurence: TRadioButton
            Left = 24
            Top = 16
            Width = 153
            Height = 17
            Caption = 'Single occurence'
            TabOrder = 0
            OnClick = RdBtnOccurenceClick
          end
          object RdBtnMultipleOccurence: TRadioButton
            Left = 24
            Top = 42
            Width = 153
            Height = 16
            Caption = 'Multiple occurences'
            TabOrder = 1
            OnClick = RdBtnOccurenceClick
          end
          object ChkBxMonday: TCheckBox
            Left = 44
            Top = 72
            Width = 95
            Height = 17
            Caption = 'Monday'
            TabOrder = 2
          end
          object ChkBxTuesday: TCheckBox
            Left = 44
            Top = 100
            Width = 95
            Height = 17
            Caption = 'Tuesday'
            TabOrder = 3
          end
          object ChkBxWednesday: TCheckBox
            Left = 44
            Top = 128
            Width = 95
            Height = 17
            Caption = 'Wednesday'
            TabOrder = 4
          end
          object ChkBxThursday: TCheckBox
            Left = 44
            Top = 156
            Width = 95
            Height = 17
            Caption = 'Thursday'
            TabOrder = 5
          end
          object ChkBxFriday: TCheckBox
            Left = 44
            Top = 184
            Width = 95
            Height = 17
            Caption = 'Friday'
            TabOrder = 6
          end
          object ChkBxSaturday: TCheckBox
            Left = 44
            Top = 212
            Width = 95
            Height = 17
            Caption = 'Saturday'
            TabOrder = 7
          end
          object ChkBxSunday: TCheckBox
            Left = 44
            Top = 240
            Width = 95
            Height = 17
            Caption = 'Sunday'
            TabOrder = 8
          end
        end
        object DBRgpTypePeriod: TDBRadioGroup
          Left = 8
          Top = 80
          Width = 185
          Height = 105
          Caption = 'Type'
          DataField = 'CodTypePeriod'
          DataSource = DscPromoPack
          Items.Strings = (
            'Full day'
            'Happy hour'
            'Nocturne')
          TabOrder = 5
          Values.Strings = (
            '0'
            '1'
            '2')
          OnChange = DBRgpTypePeriodChange
        end
      end
    end
    object TabShtActBarcode: TTabSheet
      Caption = 'Activation barcode'
      ImageIndex = 5
      object StBrCdPromoPack: TStBarCode
        Left = 304
        Top = 8
        Width = 200
        Height = 75
        Color = clWhite
        ParentColor = False
        Visible = False
        AddCheckChar = True
        BarCodeType = bcEAN_13
        BarColor = clBlack
        BarToSpaceRatio = 1.000000000000000000
        BarWidth = 12.000000000000000000
        BearerBars = False
        Code = '123456789012'
        Code128Subset = csCodeA
        ShowCode = True
        ShowGuardChars = False
        TallGuardBars = False
      end
      object SvcDBLblBarcode: TSvcDBLabelLoaded
        Left = 8
        Top = 14
        Width = 43
        Height = 13
        Caption = 'Barcode:'
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'TxtPLUActivation'
      end
      object BitBtnPrintPromoPackReport: TBitBtn
        Left = 72
        Top = 56
        Width = 217
        Height = 25
        Caption = 'Print barcode'
        TabOrder = 0
        OnClick = BitBtnPrintPromoPackReportClick
      end
      object SvcDBLFBarcode: TSvcDBLocalField
        Left = 144
        Top = 8
        Width = 130
        Height = 21
        DataField = 'NumPLUActivation'
        DataSource = DscPromoPack
        FieldType = ftString
        CaretOvr.Shape = csBlock
        Controller = OvcCtlDetail
        EFColors.Disabled.BackColor = clWindow
        EFColors.Disabled.TextColor = clGrayText
        EFColors.Error.BackColor = clRed
        EFColors.Error.TextColor = clBlack
        EFColors.Highlight.BackColor = clHighlight
        EFColors.Highlight.TextColor = clHighlightText
        MaxLength = 13
        Options = [efoCaretToEnd]
        PictureMask = '9999999999999'
        TabOrder = 1
        OnExit = SvcDBLFBarcodeExit
        LocalOptions = []
        Local = False
      end
    end
  end
  inherited StsBarInfo: TStatusBar
    Width = 724
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
  inherited DscPromoPack: TDataSource
    Left = 656
    Top = 40
  end
  inherited DscPromoAssort: TDataSource
    Left = 352
  end
  inherited DscPromoArt: TDataSource
    Left = 432
  end
  inherited DscPromoClass: TDataSource
    Left = 504
  end
  inherited OpnPicDlgLogo: TOpenPictureDialog
    Left = 584
  end
  object DscStatPromoPack: TDataSource
    Left = 664
    Top = 65528
  end
end
