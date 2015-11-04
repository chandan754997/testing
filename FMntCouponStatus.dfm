inherited FrmMntCouponStatus: TFrmMntCouponStatus
  Caption = 'FrmMntCouponStatus'
  PixelsPerInch = 96
  TextHeight = 13
  object SvcTmgMaintenance: TSvcTaskManager
    MainTask = SvcTskLstCouponStatus
    Left = 56
    Top = 16
  end
  object SvcTskLstCouponStatus: TSvcListTask
    TaskName = 'ListCouponStatus'
    LaunchTasks = <
      item
        TaskName = 'DetailCouponStatus'
        PropertiesPassed.Strings = (
          'SelectedJob=CodJob'
          'StrLstIdtValues'
          'StrLstFieldValues=StrLstRelatedInfo'
          'TxtTaskName=TxtTaskNameMRU')
        PropertiesReturned.Strings = (
          'StrLstIdtValues'
          'FlgRowModified=FlgDBApplied')
      end>
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
    Enabled = True
    OnCreate = SvcTskLstCreate
    OnCreateExecutor = SvcTskLstCouponStatusCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Sequences = <
      item
        Name = 'IdtCouponStatus'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '999999999'
        RangeLength = 9
        RangePicture = '999999999'
        Title = 'Coupon number'
        DataSet = DmdFpnCouponStatusCA.SprLstCouponStatus
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtCouponStatus')
        ParamValueSequence = 'IdtCouponStatus'
      end
      item
        Name = 'DatIssue'
        DataType = pftDate
        AllowSubString = False
        RangeLength = 0
        DataFieldRange = 'DatIssue'
        Title = 'Date coupon'
        DataSet = DmdFpnCouponStatusCA.SprLstCouponStatus
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'DatIssue')
        ParamValueSequence = 'DatIssue;IdtCouponStatus'
      end
      item
        Name = 'TxtValCoupon'
        DataType = pftString
        RangeLength = 40
        DataFieldRange = 'TxtValCoupon'
        Title = 'Description value coupon'
        DataSet = DmdFpnCouponStatusCA.SprLstCouponStatus
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtValCoupon')
        ParamValueSequence = 'TxtValCoupon;IdtCouponStatus'
      end
      item
        Name = 'CodState'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '4'
        RangeLength = 1
        DataFieldRange = 'CodState'
        Title = 'Status'
        DataSet = DmdFpnCouponStatusCA.SprLstCouponStatus
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ParamValueSequence = 'CodState;IdtCouponStatus'
      end>
    ListName = 'CouponStatus'
    IdtFields.Strings = (
      'IdtCouponStatus')
    HiddenFields.Strings = (
      'CodState')
    LookupDataSet = DmdFpnCouponStatusCA.SprLstCouponStatus
    DetailTask = 'DetailCouponStatus'
    ShowRecordCount = False
    Left = 56
    Top = 72
  end
  object SvcTskDetCouponStatus: TSvcFormTask
    TaskName = 'DetailCouponStatus'
    LaunchTasks = <
      item
        TaskName = 'ListClassificationForCoupon'
        PropertiesPassed.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'TxtIdentForSel=TxtSelectMaster')
        PropertiesReturned.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'StrLstRelatedInfo=StrLstFieldValues')
      end
      item
        TaskName = 'ListCustomerForCoupon'
        PropertiesPassed.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'TxtIdentForSel=TxtSelectMaster')
        PropertiesReturned.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'StrLstRelatedInfo=StrLstFieldValues')
      end>
    Enabled = True
    OnCreateExecutor = SvcTskDetCouponStatusCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 208
    Top = 72
  end
  object SvcTskListClassificationForCoupon: TSvcListTask
    TaskName = 'ListClassificationForCoupon'
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
    Enabled = True
    OnCreate = SvcTskLstCreate
    OnCreateExecutor = SvcTskListClassificationForCouponCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Sequences = <
      item
        Name = 'IdtClassification'
        DataType = pftString
        RangeLength = 14
        Title = 'Identification Classification'
        Caption = 'Classification '
        DataSet = DmdFpnClassificationCA.SprLstClassification
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtClassification')
        ParamValueSequence = 'IdtClassification'
      end
      item
        Name = 'TxtPublDescr'
        DataType = pftString
        RangeLength = 40
        Title = 'Description'
        DataSet = DmdFpnClassificationCA.SprLstClassification
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtPublDescr')
        ParamValueSequence = 'TxtSrcPubl'
      end>
    ListName = 'Classification'
    IdtFields.Strings = (
      'IdtClassification')
    HiddenFields.Strings = (
      'CodLevel'
      'CodType')
    MRUMax = 10
    MRUFields.Strings = (
      'IdtClassification'
      'TxtPublDescr')
    LookupSequence = 0
    ShowRecordCount = False
    Left = 72
    Top = 136
  end
  object SvcTskLstCustomerForCoupon: TSvcListTask
    TaskName = 'ListCustomerForCoupon'
    LaunchTasks = <
      item
        TaskName = 'DetailCustomer'
        PropertiesPassed.Strings = (
          'SelectedJob=CodJob'
          'StrLstIdtValues'
          'StrLstFieldValues=StrLstRelatedInfo'
          'TxtTaskName=TxtTaskNameMRU')
        PropertiesReturned.Strings = (
          'StrLstIdtValues'
          'FlgRowModified=FlgDBApplied')
      end>
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
    Enabled = True
    OnCreate = SvcTskLstCreate
    OnCreateExecutor = SvcTskLstCustomerForCouponCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Sequences = <
      item
        Name = 'IdtCustomer'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '999999999'
        RangeLength = 9
        RangePicture = '999999999'
        Title = 'Customer number'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtCustomer')
        ParamValueSequence = 'IdtCustomer'
      end
      item
        Name = 'TxtPublName'
        DataType = pftString
        RangeLength = 30
        Title = 'Name'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtPublName')
        ParamValueSequence = 'TxtSrcPubl'
      end
      item
        Name = 'TxtFirstName'
        DataType = pftString
        RangeLength = 30
        DataFieldRange = 'Address.TxtFirstName'
        Title = 'FirstName'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtFirstName')
        ParamValueSequence = 'Address.TxtFirstName'
        BehaveAsSprLst = False
      end
      item
        Name = 'TxtStreet'
        DataType = pftString
        RangeLength = 50
        DataFieldRange = 'Address.TxtStreet'
        Title = 'Address'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'Address')
        ParamValueSequence = 'Address.TxtStreet'
      end
      item
        Name = 'TxtCommunity'
        DataType = pftString
        RangeLength = 30
        DataFieldRange = 'Municipality.TxtName'
        Title = 'Community'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'Community')
        ParamValueSequence = 'Municipality.TxtName'
        BehaveAsSprLst = False
      end
      item
        Name = 'TxtNumVat'
        DataType = pftString
        RangeLength = 38
        DataFieldRange = 'Customer.TxtNumVAT'
        Title = 'VAT number'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtNumVat')
        ParamValueSequence = 'Customer.TxtNumVAT'
        BehaveAsSprLst = False
      end>
    ListName = 'Customer'
    IdtFields.Strings = (
      'IdtCustomer'
      'CodCreator')
    HiddenFields.Strings = (
      'CodCreator')
    MRUMax = 10
    MRUFields.Strings = (
      'IdtCustomer'
      'TxtPublName')
    LookupSequence = 0
    ShowRecordCount = False
    Left = 72
    Top = 184
  end
end
