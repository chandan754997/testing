inherited FrmDetCarteCadeauCA: TFrmDetCarteCadeauCA
  Width = 665
  Height = 378
  Caption = 'Carte Cadeau'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    Width = 657
    Height = 121
    object SvcDBLabelLoaded1: TSvcDBLabelLoaded
      Left = 32
      Top = 16
      Width = 65
      Height = 13
      Caption = 'Card Number:'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'SvcDBLabelLoaded1'
    end
    object SvcDBLabelLoaded2: TSvcDBLabelLoaded
      Left = 32
      Top = 48
      Width = 56
      Height = 13
      Caption = 'Description:'
      IdtLabel = 'SvcDBLabelLoaded2'
    end
    object SvcDBLabelLoaded3: TSvcDBLabelLoaded
      Left = 32
      Top = 80
      Width = 53
      Height = 13
      Caption = 'Days Valid:'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'SvcDBLabelLoaded3'
    end
    object SvcDBMEIdtArtCode: TSvcDBMaskEdit
      Left = 168
      Top = 16
      DataBinding.DataField = 'IdtArtCode'
      DataBinding.DataSource = DscCarteCadeau
      Properties.MaxLength = 0
      Properties.ReadOnly = True
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 0
      Width = 121
    end
    object CarteCadeau: TSvcFileMaskEdit
      Left = 168
      Top = 48
      Properties.ReadOnly = True
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 1
      Text = 'CarteCadeau'
      Width = 121
    end
    object SvcDBMEDaysValid: TSvcDBMaskEdit
      Left = 168
      Top = 80
      DataBinding.DataField = 'DaysValid'
      DataBinding.DataSource = DscCarteCadeau
      Properties.Alignment.Horz = taLeftJustify
      Style.BorderStyle = ebs3D
      Style.Edges = [bLeft, bTop, bBottom]
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 2
      Width = 121
    end
  end
  inherited PnlBottom: TPanel
    Top = 300
    Width = 657
    inherited PnlBottomRight: TPanel
      Left = 469
      inherited BtnOK: TBitBtn
        ParentShowHint = True
      end
    end
    inherited PnlBtnAdd: TPanel
      Left = 373
    end
  end
  inherited PgeCtlDetail: TPageControl
    Top = 121
    Width = 657
    Height = 179
    ActivePage = TabShtGeneralities
    TabStop = False
    OnResize = FormActivate
    object TabShtGeneralities: TTabSheet
      Caption = 'Generalities'
      object SvcDBLabelLoaded4: TSvcDBLabelLoaded
        Left = 32
        Top = 24
        Width = 43
        Height = 13
        Caption = 'Barcode:'
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'SvcDBLabelLoaded4'
      end
      object SvcDBMaskEdit1: TSvcDBMaskEdit
        Left = 168
        Top = 24
        DataBinding.DataField = 'CardBarCode'
        DataBinding.DataSource = DscCarteCadeau
        Properties.ReadOnly = True
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 0
        Width = 121
      end
    end
  end
  inherited StsBarInfo: TStatusBar
    Top = 332
    Width = 657
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
    Left = 592
  end
  object DscCarteCadeau: TDataSource
    DataSet = DmdFpnCarteCadeau.QryDetCarteCadeau
    OnDataChange = DscCommonDataChange
    Left = 160
    Top = 384
  end
end
