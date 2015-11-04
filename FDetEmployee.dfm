inherited FrmDetEmployee: TFrmDetEmployee
  Left = 204
  Width = 564
  Height = 424
  Caption = 'Employee'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    Width = 556
    Height = 89
    object SvcDBLblIdtEmployee: TSvcDBLabelLoaded
      Left = 8
      Top = 12
      Width = 87
      Height = 13
      Caption = 'Employee number:'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'IdtEmployee'
    end
    object SvcDBLblTxtLastName: TSvcDBLabelLoaded
      Left = 8
      Top = 40
      Width = 52
      Height = 13
      Caption = 'Last name:'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'TxtLastName'
    end
    object SvcDBLblFirstName: TSvcDBLabelLoaded
      Left = 8
      Top = 68
      Width = 51
      Height = 13
      Caption = 'First name:'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'TxtFirstName'
    end
    object lblNumCard: TLabel
      Left = 240
      Top = 12
      Width = 54
      Height = 13
      Caption = '123456789'
    end
    object SvcDBLFIdtEmployee: TSvcDBLocalField
      Left = 128
      Top = 8
      Width = 97
      Height = 21
      DataField = 'IdtEmployee'
      DataSource = DscEmployee
      FieldType = ftInteger
      CaretOvr.Shape = csBlock
      Controller = OvcCtlDetail
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      MaxLength = 9
      Options = [efoRightAlign]
      PictureMask = '999999999'
      TabOrder = 0
      OnExit = SvcDBLFIdtEmployeeExit
      LocalOptions = []
      Local = False
      RangeHigh = {FFC99A3B000000000000}
      RangeLow = {00000000000000000000}
    end
    object SvcDBMETxtLastName: TSvcDBMaskEdit
      Left = 128
      Top = 40
      DataBinding.DataField = 'TxtLastName'
      DataBinding.DataSource = DscEmployee
      Properties.MaxLength = 20
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 1
      Width = 201
    end
    object SvcDBMETxtFirstName: TSvcDBMaskEdit
      Left = 128
      Top = 64
      DataBinding.DataField = 'TxtFirstName'
      DataBinding.DataSource = DscEmployee
      Properties.MaxLength = 20
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 2
      Width = 201
    end
  end
  inherited PnlBottom: TPanel
    Top = 346
    Width = 556
    inherited PnlBottomRight: TPanel
      Left = 368
      inherited BtnCancel: TBitBtn
        Left = 97
      end
    end
    inherited PnlBtnAdd: TPanel
      Left = 272
    end
  end
  inherited PgeCtlDetail: TPageControl
    Top = 89
    Width = 556
    Height = 257
    ActivePage = Common
    TabStop = False
    object Common: TTabSheet
      Caption = 'Common'
      object SbxCommon: TScrollBox
        Left = 0
        Top = 0
        Width = 548
        Height = 229
        HorzScrollBar.Range = 350
        VertScrollBar.Range = 200
        Align = alClient
        AutoScroll = False
        BorderStyle = bsNone
        TabOrder = 0
        object SvcDBLblTxtLastNamePartner: TSvcDBLabelLoaded
          Left = 8
          Top = 16
          Width = 88
          Height = 13
          Caption = 'Last name partner:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtLastNamePartner'
        end
        object SvcDBLblTxtFirstNamePartner: TSvcDBLabelLoaded
          Left = 8
          Top = 48
          Width = 87
          Height = 13
          Caption = 'First name partner:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'TxtFirstNamePartner'
        end
        object SvcDBLblDatStartContract: TSvcDBLabelLoaded
          Left = 8
          Top = 80
          Width = 67
          Height = 13
          Caption = 'Start contract:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'DatStartContract'
        end
        object SvcDBLblDatEndContract: TSvcDBLabelLoaded
          Left = 8
          Top = 112
          Width = 64
          Height = 13
          Caption = 'End contract:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'DatEndContract'
        end
        object SvcDBLblDatActivated: TSvcDBLabelLoaded
          Left = 8
          Top = 144
          Width = 48
          Height = 13
          Caption = 'Activated:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'Datactivated'
        end
        object SvcDBLblDatDisactivated: TSvcDBLabelLoaded
          Left = 8
          Top = 176
          Width = 62
          Height = 13
          Caption = 'Disactivated:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'DatDisactivated'
        end
        object SvcDBLFDatEndContract: TSvcDBLocalField
          Left = 128
          Top = 112
          Width = 73
          Height = 21
          DataField = 'DatEndContract'
          DataSource = DscEmployee
          FieldType = ftDate
          CaretOvr.Shape = csBlock
          Controller = OvcCtlDetail
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          MaxLength = 10
          Options = [efoCaretToEnd]
          PictureMask = 'DD/mm/yyyy'
          TabOrder = 3
          LocalOptions = []
          Local = True
          RangeHigh = {25600D00000000000000}
          RangeLow = {591D0100000000000000}
        end
        object SvcDBDatStartContract: TSvcDBLocalField
          Left = 128
          Top = 80
          Width = 73
          Height = 21
          DataField = 'DatStartContract'
          DataSource = DscEmployee
          FieldType = ftDate
          CaretOvr.Shape = csBlock
          Controller = OvcCtlDetail
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          MaxLength = 10
          Options = [efoCaretToEnd]
          PictureMask = 'DD/mm/yyyy'
          TabOrder = 2
          LocalOptions = []
          Local = True
          RangeHigh = {25600D00000000000000}
          RangeLow = {591D0100000000000000}
        end
        object SvcDBLFDatActivated: TSvcDBLocalField
          Left = 128
          Top = 144
          Width = 73
          Height = 21
          DataField = 'DatActivated'
          DataSource = DscEmployee
          FieldType = ftDate
          CaretOvr.Shape = csBlock
          Controller = OvcCtlDetail
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          MaxLength = 10
          Options = [efoCaretToEnd]
          PictureMask = 'DD/mm/yyyy'
          TabOrder = 4
          LocalOptions = []
          Local = True
          RangeHigh = {25600D00000000000000}
          RangeLow = {591D0100000000000000}
        end
        object SvcDBLFDatDisactivated: TSvcDBLocalField
          Left = 128
          Top = 176
          Width = 73
          Height = 21
          DataField = 'DatDisactivated'
          DataSource = DscEmployee
          FieldType = ftDate
          CaretOvr.Shape = csBlock
          Controller = OvcCtlDetail
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          MaxLength = 10
          Options = [efoCaretToEnd]
          PictureMask = 'DD/mm/yyyy'
          TabOrder = 5
          LocalOptions = []
          Local = True
          RangeHigh = {25600D00000000000000}
          RangeLow = {591D0100000000000000}
        end
        object SvcDBMETxtLastNamePartner: TSvcDBMaskEdit
          Left = 128
          Top = 16
          DataBinding.DataField = 'TxtLastNamePartner'
          DataBinding.DataSource = DscEmployee
          Properties.MaxLength = 20
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 0
          Width = 201
        end
        object SvcDBMETxtFirstNamePartner: TSvcDBMaskEdit
          Left = 128
          Top = 48
          DataBinding.DataField = 'TxtFirstNamePartner'
          DataBinding.DataSource = DscEmployee
          Properties.MaxLength = 20
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 1
          Width = 201
        end
      end
    end
  end
  inherited StsBarInfo: TStatusBar
    Top = 378
    Width = 556
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
    Left = 456
    Top = 24
  end
  object DscEmployee: TDataSource
    OnDataChange = DscCommonDataChange
    Left = 392
    Top = 24
  end
end
