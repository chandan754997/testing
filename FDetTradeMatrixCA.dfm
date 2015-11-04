inherited FrmDetTradeMatrixCA: TFrmDetTradeMatrixCA
  Height = 500
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlBottom: TPanel
    Top = 422
  end
  inherited PgeCtlDetail: TPageControl
    Height = 381
    inherited TabShtCommon: TTabSheet
      inherited SbxCommon: TScrollBox
        Height = 353
        object GbxRussia: TGroupBox
          Left = 0
          Top = 275
          Width = 624
          Height = 62
          Align = alTop
          TabOrder = 3
          object SvcDBLblTxtINN: TSvcDBLabelLoaded
            Left = 8
            Top = 16
            Width = 22
            Height = 13
            Caption = 'INN:'
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'TxtINN'
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
            Left = 320
            Top = 16
            Width = 33
            Height = 13
            Caption = 'OKPO:'
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'TxtOKPO'
          end
          object SvcDBLblTxtCompanyType: TSvcDBLabelLoaded
            Left = 320
            Top = 40
            Width = 85
            Height = 13
            Caption = 'Type of company:'
            StoredProc = DmdFpnUtils.SprCnvApplicText
            IdtLabel = 'TxtCompanyType'
          end
          object SvcDBMEINN: TSvcDBMaskEdit
            Left = 136
            Top = 12
            DataBinding.DataField = 'TxtINN'
            DataBinding.DataSource = DscTradeMatrix
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 0
            Width = 130
          end
          object SvcDBMEKPP: TSvcDBMaskEdit
            Left = 136
            Top = 36
            DataBinding.DataField = 'TxtKPP'
            DataBinding.DataSource = DscTradeMatrix
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 1
            Width = 130
          end
          object SvcDBMEOKPO: TSvcDBMaskEdit
            Left = 447
            Top = 12
            DataBinding.DataField = 'TxtOKPO'
            DataBinding.DataSource = DscTradeMatrix
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 2
            Width = 89
          end
          object SvcDBMECompanyType: TSvcDBMaskEdit
            Left = 447
            Top = 36
            DataBinding.DataField = 'TxtCompanyType'
            DataBinding.DataSource = DscTradeMatrix
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            StyleDisabled.Color = clWindow
            TabOrder = 3
            Width = 89
          end
        end
      end
    end
    inherited TabShtTaskTarget: TTabSheet
      inherited SbxTaskTarget: TScrollBox
        Height = 353
        inherited PnlClientTMTask: TPanel
          Height = 353
          inherited PnlGridTMTask: TPanel
            Height = 353
            inherited DBGrdTMTask: TDBGrid
              Height = 353
            end
          end
        end
        inherited PnlBtnTMTask: TPanel
          Height = 353
        end
      end
    end
  end
  inherited StsBarInfo: TStatusBar
    Top = 454
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
    Left = 304
    Top = 24
  end
  inherited DscTradeMatrix: TDataSource
    DataSet = DmdFpnTradeMatrixCA.QryDetTradeMatrix
    Left = 392
    Top = 24
  end
  inherited DscTMTask: TDataSource
    Left = 480
    Top = 24
  end
  inherited DscTMLanguage: TDataSource
    Left = 568
    Top = 24
  end
end
