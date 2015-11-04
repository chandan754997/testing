inherited FrmMntCrContainerCA: TFrmMntCrContainerCA
  Left = 319
  Top = 208
  Width = 156
  Height = 392
  Caption = 'Safe to Bank'
  PixelsPerInch = 96
  TextHeight = 13
  object SvcTmgMaintenance: TSvcTaskManager
    MainTask = SvcTskFrmBags
    Left = 48
    Top = 16
  end
  object SvcTskFrmBags: TSvcFormTask
    TaskName = 'ViewBags'
    LaunchTasks = <
      item
        TaskName = 'LogOn'
        PropertiesReturned.Strings = (
          'IdtOperReg=IdtOperator'
          'TxtNameOperReg=TxtName')
      end
      item
        TaskName = 'AskContainer'
        PropertiesPassed.Strings = (
          'ObjTenderGroup'
          'QtyTotal'
          'ValTotal'
          'QtyCheq')
        PropertiesReturned.Strings = (
          'IdtContainer')
      end
      item
        TaskName = 'PrintReport'
        PropertiesPassed.Strings = (
          'LstContainer')
      end>
    Enabled = True
    OnCreateExecutor = SvcTskFrmBagsCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Left = 48
    Top = 72
  end
  object SvcTskFrmContainer: TSvcFormTask
    TaskName = 'AskContainer'
    Enabled = True
    OnCreateExecutor = SvcTskFrmContainerCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Left = 48
    Top = 128
  end
  object SvcTskFrmSafeToBankReport: TSvcFormTask
    TaskName = 'PrintReport'
    Enabled = True
    OnExecute = SvcTskFrmSafeToBankReportExecute
    OnCreateExecutor = SvcTskFrmSafeToBankReportCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Left = 48
    Top = 184
  end
  object SvcTskFrmLogOn: TSvcFormTask
    TaskName = 'LogOn'
    Enabled = True
    OnCreateExecutor = SvcTskFrmLogOnCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 48
    Top = 240
  end
end
