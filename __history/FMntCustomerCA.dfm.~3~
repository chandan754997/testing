inherited FrmMntCustomerCA: TFrmMntCustomerCA
  Left = 350
  Top = 99
  Height = 437
  Caption = 'FrmMntCustomerCA'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcTskLstCustomer: TSvcListTask
    Sequences = <
      item
        Name = 'IdtCustomer'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '2147483647'
        RangeLength = 10
        RangePicture = '9999999999'
        Title = 'Customer number'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtCustomer')
        ParamValueSequence = 'Customer.IdtCustomer'
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
          'TxtName')
        ParamValueSequence = 'Address.TxtName'
        BehaveAsSprLst = False
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
        BehaveAsSprLst = False
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
        Name = 'TxtNumVAT'
        DataType = pftString
        RangeLength = 16
        Title = 'VAT number'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtNumVAT')
        ParamValueSequence = 'Customer.TxtNumVAT'
        BehaveAsSprLst = False
      end
      item
        Name = 'TxtCompanyType'
        DataType = pftString
        RangeLength = 14
        DataFieldRange = 'Customer.TxtCompanyType'
        Title = 'SIRET No'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtCompanyType')
        ParamValueSequence = 'Customer.TxtCompanyType'
        BehaveAsSprLst = False
      end
      item
        Name = 'DatCreate'
        DataType = pftDate
        AllowSubString = False
        RangeLength = 0
        DataFieldRange = 'Customer.DatCreate'
        Title = 'Creation Date'
        DataSet = DmdFpnCustomerCA.SprLstCustomer
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ParamValueSequence = 'Customer.Datcreate'
        BehaveAsSprLst = False
      end>
    IdtFields.Strings = (
      'IdtCustomer'
      'CodCreator')
    HiddenFields.Strings = (
      'CodCreator'
      'TxtPublName')
  end
  inherited SvcTskDetCustomer: TSvcFormTask
    LaunchTasks = <
      item
        TaskName = 'ListAddressForCustomer'
        PropertiesPassed.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'TxtIdentForSel=TxtSelectMaster')
        PropertiesReturned.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'StrLstRelatedInfo=StrLstFieldValues')
      end
      item
        TaskName = 'DetailAddress'
        PropertiesPassed.Strings = (
          'CodJobRelatedForm=CodJob'
          'StrLstRelatedIdt=StrLstIdtValues'
          'StrLstRelatedInfo')
        PropertiesReturned.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues')
      end
      item
        TaskName = 'ListCustPrcCatForCustomer'
        PropertiesPassed.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'TxtIdentForSel=TxtSelectMaster')
        PropertiesReturned.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'StrLstRelatedInfo=StrLstFieldValues')
      end
      item
        TaskName = 'DetailAddOn'
        PropertiesPassed.Strings = (
          'FldIdtTable=FldIdtMainTable'
          'CodJobRelatedForm=CodJob'
          'StrLstRelatedInfo'
          'TxtMainTableName'
          'TxtRecName=TxtMainTableDescr')
      end
      item
        TaskName = 'DetailCustCard'
        PropertiesPassed.Strings = (
          'CodJobRelatedForm=CodJob'
          'StrLstRelatedIdt=StrLstIdtValues'
          'StrLstRelatedInfo')
        PropertiesReturned.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues')
      end
      item
        TaskName = 'ListMunicipalityForAddress'
        PropertiesPassed.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'TxtIdentForSel=TxtSelectMaster')
        PropertiesReturned.Strings = (
          'StrLstRelatedIdt=StrLstIdtValues'
          'StrLstRelatedInfo=StrLstFieldValues')
      end
      item
        TaskName = 'BonPassage'
        PropertiesPassed.Strings = (
          'Customer'
          'Name'
          'Address'
          'PostalCode'
          'Municipality'
          'Amount'
          'CodCreator')
      end
      item
        TaskName = 'ReprintBonPassage'
        PropertiesPassed.Strings = (
          'Customer'
          'Name'
          'Address'
          'PostalCode'
          'Municipality'
          'Amount')
      end
      item
        TaskName = 'CustomerSheetReport'
        PropertiesPassed.Strings = (
          'Name'
          'Customer'
          'Title'
          'Address'
          'PostalCode'
          'Municipality'
          'Country'
          'Province'
          'FlgCreditLim'
          'Amount'
          'Currencycust'
          'VATNum'
          'CodeVAT'
          'InvoiceNum'
          'DateCreate'
          'DateModify'
          'CustomerCommunication')
      end>
  end
  inherited SvcTskLstAddressForCustomer: TSvcListTask
    Sequences = <
      item
        Name = 'IdtAddress'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '999999999'
        RangeLength = 9
        RangePicture = '999999999'
        Title = 'Address number'
        DataSet = DmdFpnAddressCA.SprLstAddress
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtAddress')
        ParamValueSequence = 'IdtAddress'
      end
      item
        Name = 'TxtName'
        DataType = pftString
        RangeLength = 30
        Title = 'Name'
        DataSet = DmdFpnAddressCA.SprLstAddress
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtName')
        ParamValueSequence = 'Address.TxtSrcName'
      end>
  end
  inherited SvcTskLstMunicipalityForAddress: TSvcListTask
    Enabled = True
    Sequences = <
      item
        Name = 'TxtCodPost'
        DataType = pftString
        RangeLength = 10
        Title = 'ZIP-code'
        DataSet = DmdFpnMunicipalityCA.SprLstMunicipality
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubString'
        ColorFields.Strings = (
          'TxtCodPost')
        ParamValueSequence = 'TxtCodPost'
      end
      item
        Name = 'TxtName'
        DataType = pftString
        RangeLength = 30
        DataFieldRange = 'TxtNameMunicipality'
        Title = 'Municipality'
        DataSet = DmdFpnMunicipalityCA.SprLstMunicipality
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'TxtNameMunicipality')
        ParamValueSequence = 'TxtNameMunicipality'
      end
      item
        Name = 'CountryTxtName'
        DataType = pftString
        RangeLength = 30
        DataFieldRange = 'TxtNameCountry'
        Title = 'Country'
        DataSet = DmdFpnMunicipalityCA.SprLstMunicipality
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'TxtNameCountry')
        ParamValueSequence = 'TxtNameCountry'
      end>
  end
  object SvcFrmBonPassageReport: TSvcFormTask
    TaskName = 'PrintBonPassageReport'
    Enabled = True
    OnCreateExecutor = SvcFrmBonPassageReportCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 216
    Top = 360
  end
  object SvcFrmBonPassage: TSvcFormTask
    TaskName = 'BonPassage'
    LaunchTasks = <
      item
        TaskName = 'PrintBonPassageReport'
        PropertiesPassed.Strings = (
          'BonPassage'
          'Customer'
          'Name'
          'Address'
          'PostalCode'
          'Municipality'
          'Amount'
          'Collected'
          'Order'
          'NumPLU'
          'Reprint'
          'ClientType'
          'Russia')
      end>
    Enabled = True
    OnCreateExecutor = SvcFrmBonPassageCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 216
    Top = 304
  end
  object SvcFrmReprintBonPassage: TSvcFormTask
    TaskName = 'ReprintBonPassage'
    LaunchTasks = <
      item
        TaskName = 'PrintBonPassageReport'
        PropertiesPassed.Strings = (
          'BonPassage'
          'Customer'
          'Name'
          'Address'
          'PostalCode'
          'Municipality'
          'Amount'
          'Collected'
          'Order'
          'NumPLU'
          'Reprint'
          'ClientType'
          'Russia')
      end>
    Enabled = True
    OnCreateExecutor = SvcFrmReprintBonPassageCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 72
    Top = 304
  end
  object SvcFrmCustomerSheetReport: TSvcFormTask
    TaskName = 'CustomerSheetReport'
    LaunchTasks = <
      item
        TaskName = 'detailcustomer'
        PropertiesPassed.Strings = (
          'name')
      end>
    Enabled = True
    OnCreateExecutor = SvcFrmCustomerSheetReportCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 64
    Top = 352
  end
end
