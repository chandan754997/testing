inherited FrmMntCaisseMonnaieCA: TFrmMntCaisseMonnaieCA
  Left = 263
  Top = 241
  Width = 208
  Height = 465
  Caption = 'Caisse Monnaie'
  PixelsPerInch = 96
  TextHeight = 13
  object SvcTmgMaintenance: TSvcTaskManager
    MainTask = SvcTskFrmCaisseMonnaie
    Left = 80
    Top = 32
  end
  object SvcTskFrmCaisseMonnaie: TSvcFormTask
    TaskName = 'CaisseMonnaie'
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
        TaskName = 'Report'
        PropertiesPassed.Strings = (
          'IdtOperReg'
          'TxtNameOperReg'
          'StrLstBody')
      end>
    Enabled = True
    OnCreateExecutor = SvcTskFrmCaisseMonnaieCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Left = 80
    Top = 88
  end
  object SvcTskFrmLogOn: TSvcFormTask
    TaskName = 'LogOn'
    Enabled = True
    OnCreateExecutor = SvcTskFrmLogOnCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Left = 80
    Top = 144
  end
  object SvcTskFrmCaisseMonnaieReport: TSvcFormTask
    TaskName = 'Report'
    Enabled = True
    OnExecute = SvcTskFrmCaisseMonnaieReportExecute
    OnCreateExecutor = SvcTskFrmCaisseMonnaieReportCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpCenter
    Left = 80
    Top = 200
  end
end
