inherited FrmMntSupplierCA: TFrmMntSupplierCA
  Caption = 'Supplier'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcTskLstAddressForSupplier: TSvcListTask
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
  inherited SvcTskLstSupplier: TSvcListTask
    Sequences = <
      item
        Name = 'IdtSupplier'
        DataType = pftLongInt
        RangeLo = '0'
        RangeHi = '999999999'
        RangeLength = 9
        RangePicture = '999999999'
        Title = 'Supplier number'
        DataSet = DmdFpnSupplierCA.SprLstSupplier
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'IdtSupplier')
        ParamValueSequence = 'IdtSupplier'
      end
      item
        Name = 'TxtPublName'
        DataType = pftString
        RangeLength = 30
        Title = 'Name'
        DataSet = DmdFpnSupplierCA.SprLstSupplier
        ParamNameSequence = '@PrmTxtSequence'
        ParamNameFrom = '@PrmTxtFrom'
        ParamNameTo = '@PrmTxtTo'
        ParamNameSubString = '@PrmTxtLike'
        ColorFields.Strings = (
          'TxtPublName')
        ParamValueSequence = 'TxtSrcPubl'
      end>
  end
end
