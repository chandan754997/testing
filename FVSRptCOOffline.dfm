inherited FrmVSRptCOOffline: TFrmVSRptCOOffline
  Caption = 'Report customer order offline'
  PixelsPerInch = 96
  TextHeight = 13
  object StBrCdBonPassage: TStBarCode [0]
    Left = 8
    Top = 8
    Width = 200
    Height = 75
    Color = clWhite
    ParentColor = False
    Visible = False
    AddCheckChar = True
    BarCodeType = bcEAN_13
    BarColor = clBlack
    BarToSpaceRatio = 1.000000000000000000
    BarWidth = 12.000000000000000000
    BearerBars = False
    Code = '280000000031'
    Code128Subset = csCodeA
    ShowCode = True
    ShowGuardChars = False
    TallGuardBars = False
  end
  inherited VspPreview: TVSPrinter
    OnBeforeHeader = VspPreviewBeforeHeader
    ControlData = {
      0003000052410000B02700000300010000000300010000000B00FFFF03000000
      000009000000000000000000000000000000000013000500008009000352E30B
      918FCE119DE300AA004BB8510100000090014442010005417269616C09000352
      E30B918FCE119DE300AA004BB851010000009001DC7C010005417269616C0300
      010000000B00FFFF0B00FFFF0B0000000B00FFFF090000000000000000000000
      0000000000000B00FFFF0300000000000800180000005000720069006E007400
      69006E0067002E002E002E00000008000E000000430061006E00630065006C00
      00000800200000006F006E00200074006800650020002500730020006F006E00
      20002500730000000800300000004E006F00770020007000720069006E007400
      69006E0067002000500061006700650020002500640020006F00660000000800
      0200000000000500000000000080964005000000000000809640050000000000
      0080964005000000000000809640050000000000000000000500000000000000
      0000050000000000000000000500000000000000000005000000000000000000
      0500000000000080864005000000000000000000050000000000000000000300
      64000000020001000500000000000080664003000200000005000000000000C0
      724005000000000000C0724005000000000000003E4005000000000000003E40
      0B0000000B00FFFF050000000000000059400300000000000200900102000A00
      0200140013000C00008013000000000013000000000013000000000003000100
      0000130000000000030000000000050000000000000000000300000000000800
      02000000000008000200000000000800060000007C00A8000000030007000000
      0500000000000000000005000000000000000000050000000000000000000300
      0000000013000F00008003000100000008000200000000000300030000000800
      5C000000570068006F006C0065002000260050006100670065007C0050006100
      6700650020002600570069006400740068007C002600540077006F0020005000
      61006700650073007C005400680075006D00620026006E00610069006C000000}
    object StBrCdCustCard: TStBarCode
      Left = 8
      Top = 8
      Width = 169
      Height = 49
      Color = clWhite
      ParentColor = False
      Visible = False
      AddCheckChar = True
      BarCodeType = bcEAN_13
      BarColor = clBlack
      BarToSpaceRatio = 1.000000000000000000
      BarWidth = 12.000000000000000000
      BearerBars = False
      Code = '280000000031'
      Code128Subset = csCodeA
      ShowCode = True
      ShowGuardChars = False
      TallGuardBars = False
    end
    object StBrCdSalesOrder: TStBarCode
      Left = 8
      Top = 80
      Width = 169
      Height = 49
      Color = clWhite
      ParentColor = False
      Visible = False
      AddCheckChar = True
      BarCodeType = bcEAN_13
      BarColor = clBlack
      BarToSpaceRatio = 1.000000000000000000
      BarWidth = 12.000000000000000000
      BearerBars = False
      Code = '280000000031'
      Code128Subset = csCodeA
      ShowCode = True
      ShowGuardChars = False
      TallGuardBars = False
    end
  end
end
