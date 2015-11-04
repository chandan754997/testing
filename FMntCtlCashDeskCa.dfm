inherited FrmMntCtlCashDeskCa: TFrmMntCtlCashDeskCa
  Left = 400
  Top = 234
  Caption = 'Controle Cash Desk'
  PixelsPerInch = 96
  TextHeight = 13
  object SvcTmgMaintenance: TSvcTaskManager
    MainTask = SvcTskLmsCtlCashDesk
    Left = 56
    Top = 8
  end
  object SvcTskLmsCtlCashDesk: TSvcListTask
    TaskName = 'ListControleCashDesk'
    StoredProcApplicText = DmdFpnUtils.SprCnvApplicText
    Enabled = True
    OnCreateExecutor = SvcTskLmsCtlCashDeskCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Sequences = <
      item
        Name = 'IdtArticle'
        DataType = pftString
        RangeLength = 0
        DataFieldRange = 'IdtArticle'
        Title = 'Article Number'
        DataSet = DmdFpnCtlCashDeskCa.QryLstLogControleCaisse
        ParamValueSequence = 'Log_Controle_Caisse.IdtArticle'
      end>
    ListName = 'Item(s)'
    IdtFields.Strings = (
      'NumPLU'
      'IdtArticle'
      'CodType')
    HiddenFields.Strings = (
      'DatControle'
      'CodType')
    ShowRecordCount = False
    Left = 56
    Top = 64
  end
end
