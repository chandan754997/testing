inherited FrmLstCustCA: TFrmLstCustCA
  Height = 545
  Caption = 'FrmLstCustCA'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlList: TPanel
    Height = 333
    inherited DBGrdList: TDBGrid
      Width = 622
      Height = 311
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      OnDrawColumnCell = DBGrdListDrawColumnCell
    end
  end
  inherited PnlButtons: TPanel
    inherited PnlBtnsFunctions: TPanel
      Width = 502
    end
    inherited PnlBtnExit: TPanel
      Left = 563
    end
    inherited PnlBtnClose: TPanel
      Left = 503
    end
  end
  inherited PnlSeqLimRefresh: TPanel
    inherited PnlSeqAndLim: TPanel
      inherited PnlLimits: TPanel
        inherited SvcLFLimitFrom: TSvcLocalField
          Epoch = 0
        end
        inherited SvcLFLimitTo: TSvcLocalField
          Epoch = 0
        end
      end
    end
  end
  inherited StsBarList: TStatusBar
    Top = 488
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
  inherited DscList: TDataSource
    OnDataChange = DscListDataChange
  end
end
