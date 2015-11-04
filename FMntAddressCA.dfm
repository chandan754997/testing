inherited FrmMntAddressCA: TFrmMntAddressCA
  Left = 371
  Caption = 'FrmMntAddressCA'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcTskLstAddress: TSvcListTask
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
  inherited SvcTskLstCustomerForAddress: TSvcListTask
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
    IdtFields.Strings = (
      'IdtCustomer'
      'CodCreator')
    HiddenFields.Strings = (
      'CodCreator')
  end
  inherited SvcTskLstMunicipalityForAddress: TSvcListTask
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
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'TxtCodPost')
        ParamValueSequence = 'TxtCodPost'
      end
      item
        Name = 'TxtName'
        DataType = pftString
        RangeLength = 30
        Title = 'Municipality'
        DataSet = DmdFpnMunicipalityCA.SprLstMunicipality
        ParamNameSequence = '@PrmTxtSearch'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtSubstring'
        ColorFields.Strings = (
          'TxtNameMunicipality'
          '')
        ParamValueSequence = 'TxtNameMunicipality'
      end
      item
        Name = 'CountryTxtName'
        DataType = pftString
        RangeLength = 30
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
end
