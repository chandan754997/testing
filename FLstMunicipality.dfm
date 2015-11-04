inherited FrmListMunicipality: TFrmListMunicipality
  Width = 818
  Height = 479
  Caption = 'FrmListMunicipality'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlList: TPanel
    Top = 184
    Width = 810
    Height = 230
    inherited DBGrdList: TDBGrid
      Width = 808
      Height = 228
    end
  end
  inherited PnlButtons: TPanel
    Width = 810
    inherited PnlBtnsFunctions: TPanel
      Width = 688
    end
    inherited PnlBtnExit: TPanel
      Left = 749
    end
    inherited PnlBtnClose: TPanel
      Left = 689
    end
  end
  inherited PnlMRU: TPanel
    Top = 155
    Width = 810
    DesignSize = (
      810
      29)
    inherited CbxMRU: TComboBox
      Width = 657
    end
  end
  inherited PnlSeqLimRefresh: TPanel
    Top = 69
    Width = 810
    inherited PnlRefresh: TPanel
      Left = 722
    end
    inherited PnlSeqAndLim: TPanel
      Width = 714
      inherited PnlSequences: TPanel
        Width = 714
        inherited CbxSequences: TComboBox
          Width = 507
        end
      end
      inherited PnlLimits: TPanel
        Top = 28
        Width = 852
        Align = alCustom
        inherited SvcLFLimitFrom: TSvcLocalField
          Width = 645
          Epoch = 0
        end
        inherited CbxLimitFrom: TComboBox
          Width = 645
        end
        inherited CbxLimitTo: TComboBox
          Width = 645
        end
        inherited SvcLFLimitTo: TSvcLocalField
          Width = 645
          Epoch = 0
        end
        inherited SvcMELimitFrom: TSvcMaskEdit
          Width = 643
        end
        inherited SvcMELimitTo: TSvcMaskEdit
          Width = 645
        end
      end
    end
  end
  inherited StsBarList: TStatusBar
    Width = 810
  end
  object Panel1: TPanel [5]
    Left = 0
    Top = 40
    Width = 810
    Height = 29
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 5
    DesignSize = (
      810
      29)
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 42
      Height = 13
      Caption = 'Country :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object SvcMELimitCtry: TComboBox
      Left = 202
      Top = 4
      Width = 505
      Height = 21
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 0
      OnChange = CbxMRUChange
      Items.Strings = (
        '')
    end
  end
  inherited OvcCtlList: TOvcController
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
  object DscGetCountry: TDataSource
    Left = 624
  end
end
