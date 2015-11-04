inherited FrmLstCouponStatus: TFrmLstCouponStatus
  Caption = 'List couponstatus'
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
  inherited DscList: TDataSource
    OnDataChange = DscListDataChange
  end
end
