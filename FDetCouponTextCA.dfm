inherited FrmDetCoupTextCA: TFrmDetCoupTextCA
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    inherited SvcLFTxtPublDescr: TSvcLocalField
      Epoch = 0
    end
    inherited SvcLFIdtCoupon: TSvcLocalField
      Epoch = 0
      RangeHigh = {FFFF0000000000000000}
      RangeLow = {00000000000000000000}
    end
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
  inherited DscDetDescr: TDataSource
    DataSet = DmdFpnCouponCA.QryLstCoupTextCoupon
  end
  inherited DscListDescr: TDataSource
    DataSet = DmdFpnCouponCA.QryLstCoupText
  end
end
