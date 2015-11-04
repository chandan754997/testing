inherited FrmMntInitPayIn: TFrmMntInitPayIn
  Left = 287
  Top = 238
  Width = 229
  Height = 277
  Caption = 'FrmMntInitPayIn'
  PixelsPerInch = 96
  TextHeight = 13
  object SvcTskMgrInitPayIn: TSvcTaskManager
    MainTask = SvcTskFrmInitPayIn
    Left = 40
    Top = 16
  end
  object SvcTskFrmInitPayIn: TSvcFormTask
    TaskName = 'InitPayIn'
    LaunchTasks = <
      item
        TaskName = 'GenerateRapport'
        PropertiesPassed.Strings = (
          'LstOperators'
          'DatReg')
      end>
    Enabled = True
    OnCreateExecutor = SvcTskFrmInitPayInCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 40
    Top = 72
  end
  object SvcTskFrmPrintInitPayIn: TSvcFormTask
    TaskName = 'GenerateRapport'
    Enabled = True
    OnExecute = SvcTskFrmPrintInitPayInExecute
    OnCreateExecutor = SvcTskFrmPrintInitPayInCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 160
    Top = 72
  end
end
