object SrvUDPPOSToPrisma: TSrvUDPPOSToPrisma
  OldCreateOrder = False
  OnCreate = ServiceCreate
  DisplayName = 'Sycron UDP to Prisma'
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 851
  Width = 834
end
