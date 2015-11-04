inherited FrmDetCodPos: TFrmDetCodPos
  Left = 374
  Top = 348
  Width = 501
  Height = 428
  Caption = 'Checkout Types'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    Width = 493
    object SvcDBLblIdtCheckout: TSvcDBLabelLoaded
      Left = 8
      Top = 20
      Width = 15
      Height = 13
      Caption = 'N'#176':'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'CocPOS'
    end
    object SvcDBMEIdtcheckout: TSvcDBMaskEdit
      Left = 104
      Top = 16
      DataBinding.DataField = 'IdtCheckout'
      DataBinding.DataSource = DscPOS
      Properties.EditMask = '999999999999'
      Properties.MaxLength = 0
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 0
      Width = 130
    end
  end
  inherited PnlBottom: TPanel
    Top = 343
    Width = 493
    inherited PnlBottomRight: TPanel
      Left = 305
    end
    inherited PnlBtnAdd: TPanel
      Left = 209
    end
  end
  inherited PgeCtlDetail: TPageControl
    Width = 493
    Height = 281
    ActivePage = TabShtCommon
    object TabShtCommon: TTabSheet
      Caption = 'Common'
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 485
        Height = 49
        Align = alTop
        TabOrder = 0
        object SvcDBLblPosType: TSvcDBLabelLoaded
          Left = 2
          Top = 20
          Width = 27
          Height = 13
          Caption = 'Type:'
          StoredProc = DmdFpnUtils.SprCnvApplicText
          IdtLabel = 'SvcDBLblPosType'
        end
        object DBLkpCbxCodPos: TDBLookupComboBox
          Left = 96
          Top = 16
          Width = 145
          Height = 21
          DataField = 'LkpCodPos'
          DataSource = DscPOS
          TabOrder = 0
        end
      end
    end
  end
  inherited StsBarInfo: TStatusBar
    Top = 375
    Width = 493
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
    Left = 280
    Top = 48
  end
  object DscPOS: TDataSource
    DataSet = DmdFpnCodPos.QryDetCodPos
    OnDataChange = DscCommonDataChange
    Left = 344
    Top = 48
  end
end
