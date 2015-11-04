inherited FrmMntTransPaymentCA: TFrmMntTransPaymentCA
  Left = 208
  Top = 221
  Caption = 'Payment transfers for deliveries'
  PixelsPerInch = 96
  TextHeight = 13
  object SvcTskFrmMntTransPayment: TSvcTaskManager
    MainTask = SvcTskFrmTransPayment
    Left = 56
    Top = 8
  end
  object SvcTskFrmLogOn: TSvcFormTask
    TaskName = 'LogOn'
    Enabled = True
    OnCreateExecutor = SvcTskFrmLogOnCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Left = 216
    Top = 64
  end
  object SvcTskFrmTransPayment: TSvcFormTask
    TaskName = 'TransPayment'
    LaunchTasks = <
      item
        TaskName = 'LogOn'
        PropertiesPassed.Strings = (
          'ValMinimumLength=ValMinimumLength')
        PropertiesReturned.Strings = (
          'IdtOperReg=IdtOperator'
          'TxtNameOperReg=TxtName')
      end
      item
        TaskName = 'Payment'
        PropertiesPassed.Strings = (
          'LstPaymethods=LstPaymethodes'
          'LstPrevPaymethods=LstPrevPaymethodes'
          'NumTotal=NumTotal')
        PropertiesReturned.Strings = (
          'LstPaymethods=LstPaymethodes')
      end
      item
        TaskName = 'PrintReport'
        PropertiesPassed.Strings = (
          'LstTransPayments'
          'IdtOperReg'
          'TxtNameOperReg')
      end>
    Enabled = True
    OnCreateExecutor = SvcTskFrmTransPaymentCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 216
    Top = 8
  end
  object SvcTskFrmPayment: TSvcFormTask
    TaskName = 'Payment'
    Enabled = True
    OnCreateExecutor = SvcTskFrmPaymentCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Left = 216
    Top = 120
  end
  object SvcTskFrmReport: TSvcFormTask
    TaskName = 'PrintReport'
    Enabled = True
    OnExecute = SvcTskFrmReportExecute
    OnCreateExecutor = SvcTskFrmReportCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Left = 216
    Top = 176
  end
end
