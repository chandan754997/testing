inherited FrmMntTndCntSafeCA: TFrmMntTndCntSafeCA
  Left = 244
  Top = 180
  Width = 276
  Height = 180
  Caption = 'Funds Transfer from safe to safe'
  PixelsPerInch = 96
  TextHeight = 13
  object SvcTmgMaintenance: TSvcTaskManager
    MainTask = SvcTskFrmRegCountSafe
    Left = 72
    Top = 8
  end
  object SvcTskFrmRegCountSafe: TSvcFormTask
    TaskName = 'RegisterCount'
    LaunchTasks = <
      item
        TaskName = 'PrintReport'
        PropertiesPassed.Strings = (
          'LstCntSafe')
      end>
    Enabled = True
    OnCreateExecutor = SvcTskFrmRegCountSafeCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 72
    Top = 72
  end
  object SvcTskFrmRptCntSafe: TSvcFormTask
    TaskName = 'PrintReport'
    Enabled = True
    OnExecute = SvcTskFrmRptCntSafeExecute
    OnCreateExecutor = SvcTskFrmRptCntSafeCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 200
    Top = 72
  end
end
