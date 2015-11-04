object SrvMQWSAssyncIncomingCA: TSrvMQWSAssyncIncomingCA
  OldCreateOrder = True
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  Dependencies = <
    item
      Name = 'MSSQLSERVER'
      IsGroup = False
    end>
  DisplayName = 'Sycron WS to FP Assync'
  AfterInstall = ServiceAfterInstall
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 150
  Width = 215
end
