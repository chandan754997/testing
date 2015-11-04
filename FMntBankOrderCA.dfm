inherited FrmMntBankOrderCA: TFrmMntBankOrderCA
  Left = 336
  Top = 267
  Width = 235
  Height = 390
  Caption = 'Maintenance Task'
  PixelsPerInch = 96
  TextHeight = 13
  object SvcTmgMaintenance: TSvcTaskManager
    MainTask = SvcTskFrmBankOrder
    Left = 67
    Top = 29
  end
  object SvcTskFrmBankOrder: TSvcFormTask
    TaskName = 'BankOrder'
    LaunchTasks = <
      item
        TaskName = 'LogOn'
        PropertiesReturned.Strings = (
          'IdtOperReg=IdtOperator'
          'TxtNameOperReg=TxtName')
      end
      item
        TaskName = 'ReportMoneyOrder'
        PropertiesPassed.Strings = (
          'CodRunFunc'
          'IdtOperReg'
          'TxtNameOperReg'
          'IdtOrderNumber'
          'IdtAddrPayOrg'
          'LstTransDet')
      end
      item
        TaskName = 'ReportAcceptedOrder'
        PropertiesPassed.Strings = (
          'CodRunFunc'
          'IdtOperReg'
          'TxtNameOperReg'
          'IdtOrderNumber'
          'IdtAddrPayOrg'
          'LstTransDet')
      end
      item
        TaskName = 'ReportMoneyOrderParam'
        PropertiesPassed.Strings = (
          'CodRunFunc'
          'IdtOperReg'
          'TxtNameOperReg'
          'IdtOrderNumber'
          'IdtAddrPayOrg'
          'LstTransDet')
      end>
    Enabled = True
    BeforeExecute = SvcTskFrmBankOrderBeforeExecute
    OnCreateExecutor = SvcTskFrmBankOrderCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Left = 67
    Top = 85
  end
  object SvcTskFrmLogOn: TSvcFormTask
    TaskName = 'LogOn'
    Enabled = True
    OnCreateExecutor = SvcTskFrmLogOnCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Left = 67
    Top = 141
  end
  object SvcTskFrmReportMoneyOrder: TSvcFormTask
    TaskName = 'ReportMoneyOrder'
    Enabled = True
    OnExecute = SvcTskFrmReportMoneyOrderExecute
    OnCreateExecutor = SvcTskFrmReportMoneyOrderCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Left = 67
    Top = 197
  end
  object SvcTskFrmReportAcceptedOrder: TSvcFormTask
    TaskName = 'ReportAcceptedOrder'
    Enabled = True
    OnExecute = SvcTskFrmReportAcceptedOrderExecute
    OnCreateExecutor = SvcTskFrmReportAcceptedOrderCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Left = 64
    Top = 256
  end
  object SvcTskFrmReportMoneyOrderParam: TSvcFormTask
    TaskName = 'ReportMoneyOrderParam'
    Enabled = True
    OnExecute = SvcTskFrmReportMoneyOrderParamExecute
    OnCreateExecutor = SvcTskFrmReportMoneyOrderParamCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Left = 67
    Top = 309
  end
end
