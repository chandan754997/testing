object FrmMntSafeToBankCA: TFrmMntSafeToBankCA
  Left = 406
  Top = 197
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Safe to Bank'
  ClientHeight = 270
  ClientWidth = 182
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object SvcTmgMaintenance: TSvcTaskManager
    MainTask = SvcTskFrmContainers
    Left = 72
    Top = 16
  end
  object SvcTskFrmContainers: TSvcFormTask
    TaskName = 'ViewContainers'
    LaunchTasks = <
      item
        TaskName = 'LogOn'
        PropertiesReturned.Strings = (
          'IdtOperReg=IdtOperator'
          'TxtNameOperReg=TxtName')
      end
      item
        TaskName = 'PrintReport'
        PropertiesPassed.Strings = (
          'CodRunFunc'
          'LstContainer')
      end>
    Enabled = True
    BeforeExecute = SvcTskFrmContainersBeforeExecute
    OnCreateExecutor = SvcTskFrmContainersCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 72
    Top = 72
  end
  object SvcTskFrmSafeToBankReport: TSvcFormTask
    TaskName = 'PrintReport'
    Enabled = True
    OnExecute = SvcTskFrmSafeToBankReportExecute
    OnCreateExecutor = SvcTskFrmSafeToBankReportCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 72
    Top = 128
  end
  object SvcTskFrmLogOn: TSvcFormTask
    TaskName = 'LogOn'
    Enabled = True
    OnCreateExecutor = SvcTskFrmLogOnCreateExecutor
    DynamicExecutor = True
    RelativeFormPosition = rfpRightBottom
    Left = 72
    Top = 200
  end
end
