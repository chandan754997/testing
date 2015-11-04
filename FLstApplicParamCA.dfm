inherited FrmListApplicParamCA: TFrmListApplicParamCA
  PixelsPerInch = 96
  TextHeight = 13
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
end
