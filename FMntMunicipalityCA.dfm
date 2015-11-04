inherited FrmMntMunicipalityCA: TFrmMntMunicipalityCA
  Left = 327
  Top = 144
  Caption = 'Maintenance municipality'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcTskLstMunicipality: TSvcListTask
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
        ParamNameSubString = '@PrmTxtSubString'
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
        ParamNameSubString = '@PrmTxtSubString'
        ColorFields.Strings = (
          'TxtNameCountry')
        ParamValueSequence = 'TxtNameCountry'
      end>
  end
end
