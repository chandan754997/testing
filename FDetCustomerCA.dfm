inherited FrmDetCustomerCA: TFrmDetCustomerCA
  Left = 185
  Top = 124
  Width = 745
  Height = 700
  Align = alCustom
  AutoSize = True
  Caption = 'Customer'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    Width = 737
    object SvcDBLblIdtCustomer: TSvcDBLabelLoaded
      Left = 8
      Top = 12
      Width = 85
      Height = 13
      Caption = 'Customer number:'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'IdtCustomer'
    end
    object SvcDBLblTxtPublName: TSvcDBLabelLoaded
      Left = 8
      Top = 38
      Width = 31
      Height = 13
      Caption = 'Name:'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'TxtPublName'
    end
    object SvcDBLFIdtCustomer: TSvcDBLocalField
      Left = 136
      Top = 8
      Width = 80
      Height = 21
      DataField = 'IdtCustomer'
      DataSource = DscCustomer
      FieldType = ftInteger
      CaretOvr.Shape = csBlock
      Controller = OvcCtlDetail
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      MaxLength = 10
      Options = [efoRightAlign, efoRightJustify]
      PictureMask = '9999999999'
      TabOrder = 0
      LocalOptions = []
      Local = False
      RangeHigh = {FFFFFF7F000000000000}
      RangeLow = {00000000000000000000}
    end
    object SvcDBMETxtPublName: TSvcDBMaskEdit
      Left = 136
      Top = 34
      DataBinding.DataField = 'TxtPublName'
      DataBinding.DataSource = DscCustomer
      Properties.BeepOnError = True
      Properties.MaxLength = 30
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 1
      Width = 281
    end
  end
  inherited PnlBottom: TPanel
    Top = 641
    Width = 737
    inherited PnlBottomRight: TPanel
      Left = 549
      TabOrder = 2
    end
    inherited BtnApply: TBitBtn
      TabOrder = 3
    end
    inherited PnlBtnAdd: TPanel
      Left = 453
      TabOrder = 1
    end
    inherited BtnAddOn: TBitBtn
      TabOrder = 4
    end
    object btnReprint: TBitBtn
      Left = 220
      Top = 4
      Width = 110
      Height = 25
      Caption = 'Reprint BP'
      TabOrder = 5
      OnClick = btnReprintClick
      Glyph.Data = {
        72010000424D7201000000000000760000002800000015000000150000000100
        040000000000FC00000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888885F08888888888888888888885F08870000000000000078885F0880D
        7D7D7D7D7D7D708885F08000000000000000000885F080DDDDDDDDDDDDDDDD08
        85F080DD0D0D0DDDDD00DD0885F080DDDDDDDDDDDDDDDD0886C08088F8F8F8F8
        F8F8F80881118800000000000000008884408880D0FFFFFFFF0D0888864C8880
        00F007070F0008888000888880FFFFFFFF0888888118888880F0708888088888
        8088888880FFFFF0000888888200888880F070F0F08888888A20888880FFFFF0
        0888888888AC8888800000008888888884088888888888888888888889008888
        88888888888888888000888888888888888888888000}
    end
    object btnBonPassage: TBitBtn
      Left = 104
      Top = 4
      Width = 110
      Height = 25
      Caption = 'Bon de passage'
      TabOrder = 6
      OnClick = btnBonPassageClick
      Glyph.Data = {
        72010000424D7201000000000000760000002800000015000000150000000100
        040000000000FC00000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888886958888880000000000888885508888888800000088888886958888
        000444444444488885508884FFF000FFFFFFF488878588844444440004444488
        8CEE8884FFFFFFFFFFFFF48880408884FFFFFFFFFFFFF48889088884FFFFFFFF
        FFFFF48882028800FFFFFFFFFFFFF00884008800FFFF7FFF7FFFF00881918800
        FFFF0FFF0FFFF00880008800F88878887888F008804088884FFF0FFF0FFF4888
        810088884FFF7FFF7FFF4888800288884FFFFFFFFFFF4888844488884FFFFFFF
        FFFF488881018888844444440004888880008888888888880008888880008888
        88888888888888888880888888888888888888888888}
    end
    object BtnCustomerSheet: TBitBtn
      Left = 339
      Top = 4
      Width = 110
      Height = 25
      Caption = 'Customer Sheet'
      TabOrder = 0
      Visible = False
      OnClick = BtnCustomerSheetClick
      Glyph.Data = {
        66030000424D6603000000000000360000002800000010000000110000000100
        1800000000003003000000000000000000000000000000000000CAFFFECAFFFE
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000FFFFFFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000FFFFFF000000000000
        000000000000000000000000000000808080C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
        0000000000C0C0C0808080C0C0C0C0C0C0C0C0C0000000FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFF000000808080808080C0C0
        C0C0C0C0000000FFFFFFFFFFFFFFFFFFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C000
        0000FFFFFFFFFFFF000000C0C0C0C0C0C0C0C0C0000000FFFFFFFFFFFFFFFFFF
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000000000000000000000000000C0C0
        C0C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0C0C0C0000000FFFFFFFFFFFFFFFFFF
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FFFFFFC0C0
        C0C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0C0C0C0000000FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0
        C0C0C0C0000000FFFFFFFFFFFFFFFFFFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0FFFFFFC0C0C0C0C0C0000000FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0
        C0C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0C0C0C0000000FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0
        C0C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0CAFFFECAFFFEFFFFFF000000000000
        000000000000000000000000000000000000000000000000000000000000CAFF
        FECAFFFECAFFFEFFFFFF}
    end
  end
  inherited PgeCtlDetail: TPageControl
    Width = 737
    Height = 560
    ActivePage = TabShtCommon
    TabStop = False
    OnChange = PgeCtlDetailChange
    object TabShtCommon: TTabSheet
      Caption = 'Common'
      object GbxFlgCreditLim: TGroupBox
        Left = 0
        Top = 330
        Width = 729
        Height = 38
        Align = alTop
        TabOrder = 3
        object SvcDBLblFlgCreditLim: TSvcDBLabelLoaded
          Left = 8
          Top = 15
          Width = 50
          Height = 13
          Caption = 'Credit limit:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'FlgCreditLim'
        end
        object SvcDBLblValCreditLim: TSvcDBLabelLoaded
          Left = 280
          Top = 15
          Width = 88
          Height = 13
          Caption = 'Amount credit limit:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'ValCreditLim'
        end
        object LblIdtCurrency: TLabel
          Left = 463
          Top = 16
          Width = 68
          Height = 13
          Caption = 'LblIdtCurrency'
        end
        object DBCbxFlgCreditLim: TDBCheckBox
          Left = 136
          Top = 13
          Width = 17
          Height = 17
          Caption = '|'
          DataField = 'FlgCreditLim'
          DataSource = DscCustomer
          TabOrder = 0
          ValueChecked = '1'
          ValueUnchecked = '0'
          OnClick = DBCbxFlgCreditLimClick
        end
        object SvcDBLFValCreditLim: TSvcDBLocalField
          Left = 376
          Top = 11
          Width = 80
          Height = 21
          DataField = 'ValCreditLim'
          DataSource = DscCustomer
          FieldType = ftBCD
          CaretOvr.Shape = csBlock
          Controller = OvcCtlDetail
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          MaxLength = 12
          Options = [efoCaretToEnd]
          PictureMask = '#########.##'
          TabOrder = 1
          LocalOptions = []
          Local = False
          RangeHigh = {E175587FED2AB1ECFE7F}
          RangeLow = {E175587FED2AB1ECFEFF}
        end
      end
      object GbxFlgActive: TGroupBox
        Left = 0
        Top = 406
        Width = 729
        Height = 116
        Align = alTop
        TabOrder = 4
        object SvcDBLblCodVATSystem: TSvcDBLabelLoaded
          Left = 8
          Top = 43
          Width = 47
          Height = 13
          Caption = 'VAT duty:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'CodVATSystem'
        end
        object SvcDBLblQtyCopyInv: TSvcDBLabelLoaded
          Left = 8
          Top = 67
          Width = 123
          Height = 13
          Caption = 'Number of invoice copies:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'QtyCopyInv'
        end
        object SvcDBLblTxtNumVAT: TSvcDBLabelLoaded
          Left = 8
          Top = 16
          Width = 64
          Height = 13
          Caption = 'Number VAT:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtNumVAT'
        end
        object SvcDBLblNumInvExpDays: TSvcDBLabelLoaded
          Left = 214
          Top = 67
          Width = 103
          Height = 13
          Caption = 'N'#176' days before expiry:'
          Visible = False
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'NumInvExpDays'
        end
        object SvcDBLblSiretNo: TSvcDBLabelLoaded
          Left = 8
          Top = 90
          Width = 52
          Height = 13
          Caption = 'SIRET No.'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtCompanyType'
        end
        object DBLkpCbxCodVATSystem: TDBLookupComboBox
          Left = 136
          Top = 39
          Width = 281
          Height = 21
          DataField = 'LkpCodVATSystem'
          DataSource = DscCustomer
          DropDownRows = 2
          TabOrder = 1
        end
        object SvcDBLFQtyCopyInv: TSvcDBLocalField
          Left = 136
          Top = 63
          Width = 60
          Height = 21
          DataField = 'QtyCopyInv'
          DataSource = DscCustomer
          FieldType = ftInteger
          CaretOvr.Shape = csBlock
          Controller = OvcCtlDetail
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          MaxLength = 1
          Options = [efoRightAlign, efoRightJustify]
          PictureMask = '9'
          TabOrder = 2
          LocalOptions = []
          Local = False
          RangeHigh = {09000000000000000000}
          RangeLow = {00000000000000000000}
        end
        object SvcDBLFNumInvExpDays: TSvcDBLocalField
          Left = 355
          Top = 63
          Width = 61
          Height = 21
          DataField = 'NumInvExpDays'
          DataSource = DscCustomer
          FieldType = ftInteger
          CaretOvr.Shape = csBlock
          Controller = OvcCtlDetail
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Enabled = False
          MaxLength = 10
          Options = [efoReadOnly, efoRightAlign, efoRightJustify]
          PictureMask = 'iiiiiiiiii'
          TabOrder = 3
          Visible = False
          LocalOptions = []
          Local = False
          RangeHigh = {FFFFFF7F000000000000}
          RangeLow = {00000080000000000000}
        end
        object SvcDBMETxtNumVAT: TSvcDBMaskEdit
          Left = 136
          Top = 12
          DataBinding.DataField = 'TxtNumVat'
          DataBinding.DataSource = DscCustomer
          Properties.BeepOnError = True
          Properties.MaxLength = 38
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 0
          Width = 281
        end
        object SvcDBMEtxtSiretNo: TSvcDBMaskEdit
          Left = 136
          Top = 88
          DataBinding.DataField = 'TxtCompanyType'
          DataBinding.DataSource = DscCustomer
          Properties.MaskKind = emkRegExpr
          Properties.EditMask = '\d+'
          Properties.MaxLength = 0
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 4
          Width = 153
        end
      end
      object GbxFlgAddress: TGroupBox
        Left = 0
        Top = 0
        Width = 729
        Height = 113
        Align = alTop
        TabOrder = 0
        object SvcDBLblTxtStreet: TSvcDBLabelLoaded
          Left = 8
          Top = 40
          Width = 31
          Height = 13
          Caption = 'Street:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtStreet'
        end
        object SvcDBLblTxtTitle: TSvcDBLabelLoaded
          Left = 8
          Top = 16
          Width = 23
          Height = 13
          Caption = 'Title:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtTitle'
        end
        object SvcDBLblTxtCountry: TSvcDBLabelLoaded
          Left = 280
          Top = 88
          Width = 39
          Height = 13
          Caption = 'Country:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtNameCountry'
        end
        object SvcDBLblTxtCodPost: TSvcDBLabelLoaded
          Left = 8
          Top = 64
          Width = 51
          Height = 13
          Caption = 'Post code:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtCodPost'
        end
        object SvcDBLblTxtNameMunicipality: TSvcDBLabelLoaded
          Left = 279
          Top = 64
          Width = 58
          Height = 13
          Caption = 'Municipality:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtNameMunicipality'
        end
        object SvcDBLblTxtProvince: TSvcDBLabelLoaded
          Left = 8
          Top = 88
          Width = 42
          Height = 13
          Caption = 'Province'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtNameProvince'
        end
        object SvcDBBDFRGenName: TSvcDBLabelLoaded
          Left = 280
          Top = 16
          Width = 31
          Height = 13
          Caption = 'Name:'
          Visible = False
          IdtLabel = 'TxtPublName'
        end
        object DBLkpCbxIdtMunicipality: TDBLookupComboBox
          Left = 344
          Top = 60
          Width = 185
          Height = 21
          DataField = 'LkpIdtMunicipalityTxtName'
          DataSource = DscAddress
          Enabled = False
          TabOrder = 4
          OnCloseUp = DBLkpCbxIdtMunicipalityCloseUp
          OnEnter = DBLkpCbxIdtMunicipalityEnter
        end
        object BtnSelectMunicipality: TBitBtn
          Left = 536
          Top = 57
          Width = 79
          Height = 25
          Hint = 'Select municipality for this address'
          Caption = 'Select...'
          TabOrder = 5
          OnClick = BtnSelectMunicipalityClick
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
        object SvcDBMETxtTitle: TSvcDBMaskEdit
          Left = 136
          Top = 12
          DataBinding.DataField = 'TxtTitle'
          DataBinding.DataSource = DscAddress
          Properties.BeepOnError = True
          Properties.MaxLength = 30
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 0
          Width = 129
        end
        object SvcDBMETxtStreet: TSvcDBMaskEdit
          Left = 136
          Top = 36
          DataBinding.DataField = 'TxtStreet'
          DataBinding.DataSource = DscAddress
          Properties.BeepOnError = True
          Properties.MaxLength = 50
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 2
          Width = 393
        end
        object SvcDBMEMunicipalityTxtCodPost: TSvcDBMaskEdit
          Left = 136
          Top = 60
          DataBinding.DataField = 'MunicipalityTxtCodPost'
          DataBinding.DataSource = DscAddress
          Properties.BeepOnError = True
          Properties.MaxLength = 10
          Properties.OnValidate = SvcDBMEMunicipalityTxtCodPostPropertiesValidate
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 3
          OnExit = SvcDBMEMunicipalityTxtCodPostExit
          Width = 129
        end
        object SvcDBMETxtProvince: TSvcDBMaskEdit
          Left = 136
          Top = 84
          DataBinding.DataField = 'TxtProvince'
          DataBinding.DataSource = DscCustomer
          Properties.BeepOnError = True
          Properties.MaxLength = 20
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 6
          Width = 129
        end
        object SvcDBMETxtCountry: TSvcDBMaskEdit
          Left = 344
          Top = 84
          DataBinding.DataField = 'CountryTxtName'
          DataBinding.DataSource = DscAddress
          Properties.BeepOnError = True
          Properties.MaxLength = 30
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 7
          Width = 113
        end
        object SvcDBLblTxtGenPublName: TSvcDBMaskEdit
          Left = 344
          Top = 8
          DataBinding.DataField = 'TxtPublName'
          DataBinding.DataSource = DscCustomer
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 1
          Visible = False
          Width = 121
        end
      end
      object GbxFlgRussia: TGroupBox
        Left = 0
        Top = 264
        Width = 729
        Height = 66
        Align = alTop
        TabOrder = 2
        object SvcDBLblTxtInn: TSvcDBLabelLoaded
          Left = 8
          Top = 16
          Width = 22
          Height = 13
          Caption = 'INN:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtInn'
        end
        object SvcDBLblTxtKPP: TSvcDBLabelLoaded
          Left = 8
          Top = 40
          Width = 24
          Height = 13
          Caption = 'KPP:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtKPP'
        end
        object SvcDBLblTxtOKPO: TSvcDBLabelLoaded
          Left = 280
          Top = 40
          Width = 33
          Height = 13
          Caption = 'OKPO:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtOKPO'
        end
        object SvcDBLblTxtTypeCompany: TSvcDBLabelLoaded
          Left = 280
          Top = 16
          Width = 85
          Height = 13
          Caption = 'Type of company:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtTypeCompany'
        end
        object SvcDBMETxtINN: TSvcDBMaskEdit
          Left = 136
          Top = 12
          DataBinding.DataField = 'TxtINN'
          DataBinding.DataSource = DscCustomer
          Properties.BeepOnError = True
          Properties.MaxLength = 12
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 0
          Width = 130
        end
        object SvcDBMETxtKPP: TSvcDBMaskEdit
          Left = 136
          Top = 36
          DataBinding.DataField = 'TxtKPP'
          DataBinding.DataSource = DscCustomer
          Properties.BeepOnError = True
          Properties.MaxLength = 9
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 1
          Width = 130
        end
        object SvcDBMETxtOKPO: TSvcDBMaskEdit
          Left = 376
          Top = 36
          DataBinding.DataField = 'TxtOKPO'
          DataBinding.DataSource = DscCustomer
          Properties.BeepOnError = True
          Properties.MaxLength = 8
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 2
          Width = 130
        end
        object SvcDBMETxtTypeCompany: TSvcDBMaskEdit
          Left = 376
          Top = 12
          DataBinding.DataField = 'TxtCompanyType'
          DataBinding.DataSource = DscCustomer
          Properties.BeepOnError = True
          Properties.MaxLength = 20
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 3
          Width = 153
        end
      end
      object GbxValSale: TGroupBox
        Left = 0
        Top = 368
        Width = 729
        Height = 38
        Align = alTop
        TabOrder = 5
        object SvcDBLabelLoaded2: TSvcDBLabelLoaded
          Left = 8
          Top = 15
          Width = 54
          Height = 13
          Caption = 'Value sales'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'ValSale'
        end
        object LblIdtCurrencyValSale: TLabel
          Left = 223
          Top = 16
          Width = 68
          Height = 13
          Caption = 'LblIdtCurrency'
        end
        object SvcDBLFValSale: TSvcDBLocalField
          Left = 136
          Top = 11
          Width = 80
          Height = 21
          DataField = 'ValSale'
          DataSource = DscCustomer
          FieldType = ftBCD
          CaretOvr.Shape = csBlock
          Controller = OvcCtlDetail
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          MaxLength = 12
          Options = [efoCaretToEnd]
          PictureMask = '#########.##'
          TabOrder = 0
          LocalOptions = []
          Local = False
          RangeHigh = {E175587FED2AB1ECFE7F}
          RangeLow = {E175587FED2AB1ECFEFF}
        end
      end
      object GbxIdtCustPrcCat: TGroupBox
        Left = 0
        Top = 226
        Width = 729
        Height = 38
        Align = alTop
        TabOrder = 6
        object SvcDBLblIdtCustPrcCat: TSvcDBLabelLoaded
          Left = 8
          Top = 15
          Width = 71
          Height = 13
          Caption = 'Price category:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'LnkCustPrcCat'
        end
        object SvcMECustPrcCatTxtExplanation: TSvcMaskEdit
          Left = 225
          Top = 12
          Enabled = False
          Properties.MaxLength = 40
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 1
          Width = 302
        end
        object BtnSelectCustPrcCat: TBitBtn
          Left = 536
          Top = 10
          Width = 79
          Height = 25
          Hint = 'Select price category for this customer'
          Caption = 'Select...'
          TabOrder = 2
          OnClick = BtnSelectCustPrcCatClick
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
        object SvcDBLFIdtCustPrcCat: TSvcDBLocalField
          Left = 136
          Top = 12
          Width = 80
          Height = 21
          DataField = 'IdtCustPrcCat'
          DataSource = DscCustomer
          FieldType = ftInteger
          ZeroAsNull = True
          CaretOvr.Shape = csBlock
          Controller = OvcCtlDetail
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          MaxLength = 10
          Options = [efoRightAlign, efoRightJustify]
          PictureMask = '9999999999'
          TabOrder = 0
          OnUserValidation = SvcDBLFIdtCustPrcCatUserValidation
          LocalOptions = []
          Local = False
          RangeHigh = {FFFFFF7F000000000000}
          RangeLow = {00000000000000000000}
        end
      end
      object BDFRGroupBox: TGroupBox
        Left = 0
        Top = 113
        Width = 729
        Height = 113
        Align = alTop
        Caption = 'Invoice Address'
        TabOrder = 1
        object SvcDBLblInvStreet: TSvcDBLabelLoaded
          Left = 8
          Top = 40
          Width = 31
          Height = 13
          Caption = 'Street:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtStreet'
        end
        object SvcDBLblInvTitle: TSvcDBLabelLoaded
          Left = 8
          Top = 16
          Width = 23
          Height = 13
          Caption = 'Title:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtTitle'
        end
        object SvcDBLblInvCountry: TSvcDBLabelLoaded
          Left = 280
          Top = 88
          Width = 39
          Height = 13
          Caption = 'Country:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtNameCountry'
        end
        object SvcDBLblInvCodPost: TSvcDBLabelLoaded
          Left = 8
          Top = 64
          Width = 51
          Height = 13
          Caption = 'Post code:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtCodPost'
        end
        object SvcDBLblInvNameMunicipality: TSvcDBLabelLoaded
          Left = 279
          Top = 64
          Width = 58
          Height = 13
          Caption = 'Municipality:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtNameMunicipality'
        end
        object SvcDBLblInvProvince: TSvcDBLabelLoaded
          Left = 8
          Top = 88
          Width = 42
          Height = 13
          Caption = 'Province'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtNameProvince'
        end
        object SvcDBBDFRInvName: TSvcDBLabelLoaded
          Left = 280
          Top = 8
          Width = 31
          Height = 13
          Caption = 'Name:'
          Visible = False
          IdtLabel = 'TxtPublName'
        end
        object DBLkpCbxInvMunicipality: TDBLookupComboBox
          Left = 344
          Top = 60
          Width = 185
          Height = 21
          DataField = 'LkpInvMunicipalityTxtName'
          DataSource = DscAddInvoice
          Enabled = False
          TabOrder = 4
          OnCloseUp = DBLkpCbxInvMunicipalityCloseUp
          OnEnter = DBLkpCbxInvMunicipalityEnter
        end
        object BtnSelectInvMunicipality: TBitBtn
          Left = 536
          Top = 57
          Width = 79
          Height = 25
          Hint = 'Select municipality for this address'
          Caption = 'Select...'
          TabOrder = 5
          OnClick = BtnSelectInvMunicipalityClick
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
        object SvcDBMEInvTitle: TSvcDBMaskEdit
          Left = 136
          Top = 12
          DataBinding.DataField = 'TxtTitle'
          DataBinding.DataSource = DscAddInvoice
          Properties.BeepOnError = True
          Properties.MaxLength = 30
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 0
          Width = 129
        end
        object SvcDBMEInvStreet: TSvcDBMaskEdit
          Left = 136
          Top = 36
          DataBinding.DataField = 'TxtStreet'
          DataBinding.DataSource = DscAddInvoice
          Properties.BeepOnError = True
          Properties.MaxLength = 50
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 2
          Width = 393
        end
        object SvcDBMEInvMunicipalityCodPost: TSvcDBMaskEdit
          Left = 136
          Top = 60
          DataBinding.DataField = 'MunicipalityTxtInvCodPost'
          DataBinding.DataSource = DscAddInvoice
          Properties.BeepOnError = True
          Properties.MaxLength = 10
          Properties.OnValidate = SvcDBMEInvMunicipalityCodPostPropertiesValidate
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 3
          OnExit = SvcDBMEInvMunicipalityCodPostExit
          Width = 129
        end
        object SvcDBMEInvProvince: TSvcDBMaskEdit
          Left = 136
          Top = 84
          DataBinding.DataField = 'TxtProvince'
          DataBinding.DataSource = DscCustomer
          Properties.BeepOnError = True
          Properties.MaxLength = 20
          Properties.ReadOnly = False
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 6
          Width = 129
        end
        object SvcDBMEInvCountry: TSvcDBMaskEdit
          Left = 344
          Top = 84
          DataBinding.DataField = 'CountryTxtName'
          DataBinding.DataSource = DscAddInvoice
          Properties.BeepOnError = True
          Properties.MaxLength = 30
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 7
          Width = 113
        end
        object SvcDBLblTxtInvPublName: TSvcDBMaskEdit
          Left = 344
          Top = 8
          DataBinding.DataField = 'TxtName'
          DataBinding.DataSource = DscAddInvoice
          DragCursor = crHandPoint
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 1
          Visible = False
          Width = 121
        end
      end
      object DBRGCustCommunication: TDBRadioGroup
        Left = 0
        Top = 522
        Width = 729
        Height = 47
        Align = alTop
        DataField = 'CustCommunication'
        DataSource = DscCustomer
        Items.Strings = (
          'Don'#39't receive Commertial Communication'
          'Receive Commertial Communication')
        TabOrder = 7
        Values.Strings = (
          '0'
          '1'
          '')
      end
    end
    object TabShtCustCard: TTabSheet
      Caption = 'Cards'
      ImageIndex = 3
      object SbxCustCard: TScrollBox
        Left = 0
        Top = 0
        Width = 731
        Height = 411
        Align = alClient
        AutoScroll = False
        BorderStyle = bsNone
        TabOrder = 0
        object DBGrdCustCard: TDBGrid
          Left = 0
          Top = 0
          Width = 627
          Height = 411
          Align = alClient
          DataSource = DscLstCustCard
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDblClick = DBGrdCustCardDblClick
          OnKeyPress = DBGridCommonKeyPress
          OnTitleClick = DBGrdCustCardTitleClick
          Columns = <
            item
              Alignment = taRightJustify
              Expanded = False
              FieldName = 'NumCard'
              Title.Alignment = taRightJustify
              Title.Caption = 'Card number'
              Width = 110
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CodCustCardAsTxtShort'
              Title.Caption = 'Kind card'
              Width = 126
              Visible = True
            end
            item
              Alignment = taRightJustify
              Expanded = False
              FieldName = 'DatExpire'
              Title.Alignment = taRightJustify
              Title.Caption = 'Expires'
              Visible = True
            end>
        end
        object PnlBtnCustCard: TPanel
          Left = 627
          Top = 0
          Width = 104
          Height = 411
          Align = alRight
          TabOrder = 1
          object BtnNewCustCard: TBitBtn
            Left = 8
            Top = 16
            Width = 90
            Height = 25
            Hint = 'Create a new PLU-number'
            Caption = 'New...'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = BtnCustCardClick
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              0400000000000001000000000000000000001000000010000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              33333333FF33333333FF333993333333300033377F3333333777333993333333
              300033F77FFF3333377739999993333333333777777F3333333F399999933333
              33003777777333333377333993333333330033377F3333333377333993333333
              3333333773333333333F333333333333330033333333F33333773333333C3333
              330033333337FF3333773333333CC333333333FFFFF77FFF3FF33CCCCCCCCCC3
              993337777777777F77F33CCCCCCCCCC3993337777777777377333333333CC333
              333333333337733333FF3333333C333330003333333733333777333333333333
              3000333333333333377733333333333333333333333333333333}
            Margin = 2
            NumGlyphs = 2
            Spacing = 2
          end
          object BtnEditCustCard: TBitBtn
            Left = 8
            Top = 48
            Width = 90
            Height = 25
            Hint = 'Edit current positioned PLU-number'
            Caption = 'Edit...'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = BtnCustCardClick
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              0400000000000001000000000000000000001000000010000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
              333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
              0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
              07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
              07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
              0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
              33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
              B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
              3BB33773333773333773B333333B3333333B7333333733333337}
            Margin = 2
            NumGlyphs = 2
            Spacing = 2
          end
          object BtnRemoveCustCard: TBitBtn
            Left = 8
            Top = 112
            Width = 90
            Height = 25
            Hint = 'Remove current positioned PLU-number'
            Caption = 'Remove...'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnClick = BtnCustCardClick
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              0400000000000001000000000000000000001000000010000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              3333333333333333FF3333333333333003333333333333377F33333333333307
              733333FFF333337773333C003333307733333777FF333777FFFFC0CC03330770
              000077777FF377777777C033C03077FFFFF077FF77F777FFFFF7CC00000F7777
              777077777777777777773CCCCC00000000003777777777777777333330030FFF
              FFF03333F77F7F3FF3F7333C0C030F00F0F03337777F7F77373733C03C030FFF
              FFF03377F77F7F3F333733C03C030F0FFFF03377F7737F733FF733C000330FFF
              0000337777F37F3F7777333CCC330F0F0FF0333777337F737F37333333330FFF
              0F03333333337FFF7F7333333333000000333333333377777733}
            Margin = 2
            NumGlyphs = 2
            Spacing = 2
          end
          object BtnConsultCustCard: TBitBtn
            Left = 8
            Top = 80
            Width = 90
            Height = 25
            Hint = 'Consult connected supplier'
            Caption = 'Consult...'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = BtnCustCardClick
            Glyph.Data = {
              76010000424D7601000000000000760000002800000020000000100000000100
              0400000000000001000000000000000000001000000010000000000000000000
              800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              33333FFFFFFFFFFFFFFF000000000000000077777777777777770FFFFFFFFFFF
              FFF07F3FF3FF3FFF3FF70F00F00F000F00F07F773773777377370FFFFFFFFFFF
              FFF07F3FF3FF33FFFFF70F00F00FF00000F07F773773377777F70FEEEEEFF0F9
              FCF07F33333337F7F7F70FFFFFFFF0F9FCF07F3FFFF337F737F70F0000FFF0FF
              FCF07F7777F337F337370F0000FFF0FFFFF07F777733373333370FFFFFFFFFFF
              FFF07FFFFFFFFFFFFFF70CCCCCCCCCCCCCC07777777777777777088CCCCCCCCC
              C880733777777777733700000000000000007777777777777777333333333333
              3333333333333333333333333333333333333333333333333333}
            Margin = 2
            NumGlyphs = 2
            Spacing = 2
          end
        end
      end
    end
  end
  inherited StsBarInfo: TStatusBar
    Top = 622
    Width = 737
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
    Top = 16
  end
  object DscCustomer: TDataSource
    DataSet = DmdFpnCustomerCA.QryDetCustomer
    OnDataChange = DscCustomerDataChange
    Left = 504
  end
  object DscCustCard: TDataSource
    Left = 576
  end
  object DscLstCustCard: TDataSource
    Left = 576
    Top = 48
  end
  object DscAddress: TDataSource
    DataSet = DmdFpnAddressCA.QryLstAddrMailingAddress
    OnDataChange = DscCustomerDataChange
    Left = 508
    Top = 49
  end
  object DscGetCountry: TDataSource
    Left = 656
    Top = 48
  end
  object DscMunicipalityFilter: TDataSource
    DataSet = DmdFpnMunicipality.QryDetMunicipality
    Left = 648
  end
  object DscAddInvoice: TDataSource
    DataSet = DmdFpnCustomerCA.QryDetInvoice
    OnDataChange = DscCustomerDataChange
    Left = 448
    Top = 64
  end
  object DscAddTxtProvince: TDataSource
    DataSet = DmdFpnCustomerCA.QryDetTxtProvince
    Left = 664
    Top = 112
  end
  object DscInvMunicipalityFilter: TDataSource
    DataSet = DmdFpnMunicipalityCA.QryDetInvMunicipality
    Left = 640
    Top = 208
  end
end
