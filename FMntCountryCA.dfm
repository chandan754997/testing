inherited FrmMntCountryCA: TFrmMntCountryCA
  Left = 377
  Top = 155
  Caption = 'Country'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcTskLstCountry: TSvcListTask
    Sequences = <
      item
        Name = 'TxtCodCountry'
        DataType = pftString
        RangeLength = 2
        Title = 'Code country'
        DataSet = DmdFpnCountryCA.SprLstCountry
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtCodCountry')
        ParamValueSequence = 'TxtCodCountry'
      end
      item
        Name = 'TxtName'
        DataType = pftString
        RangeLength = 30
        Title = 'Country'
        DataSet = DmdFpnCountryCA.SprLstCountry
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtNameCountry')
        ParamValueSequence = 'TxtSrcName'
      end>
  end
end
