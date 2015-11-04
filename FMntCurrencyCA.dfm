inherited FrmMntCurrencyCA: TFrmMntCurrencyCA
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcTskLstCurrency: TSvcListTask
    Sequences = <
      item
        Name = 'IdtCurrency'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '999999999'
        RangeLength = 9
        RangePicture = '999999999'
        DataFieldRange = 'CurrAssort.IdtCurrency'
        Title = 'Currency'
        DataSet = DmdFpnCurrency.SprLstCurrency
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtCurrency')
        ParamValueSequence = 'CurrAssort.IdtCurrency'
      end
      item
        Name = 'TxtPublDescr'
        DataType = pftString
        RangeLength = 40
        Title = 'Description'
        DataSet = DmdFpnCurrency.SprLstCurrency
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtPublDescr')
        ParamValueSequence = 'TxtSrcPubl'
      end>
  end
end
