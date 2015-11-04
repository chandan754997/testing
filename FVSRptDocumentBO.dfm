inherited FrmVSRptDocumentBO: TFrmVSRptDocumentBO
  Left = 19
  Top = 171
  Width = 638
  Height = 481
  Caption = 'Report Anomalous BO Documents'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited StsBarPreview: TStatusBar
    Top = 408
    Width = 630
  end
  inherited VspPreview: TVSPrinter
    Width = 630
    Height = 358
    OnBeforeHeader = VspPreviewBeforeHeader
    ControlData = {
      000300001D410000002500000300010000000300010000000B00FFFF03000000
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
      0200140013000C00008013000000000013000000000013000000000003000000
      0000130000000000030000000000050000000000000000000300000000000800
      02000000000008000200000000000800060000007C00A8000000030007000000
      0500000000000000000005000000000000000000050000000000000000000300
      0000000013000F00008003000100000008000200000000000300030000000800
      5C000000570068006F006C0065002000260050006100670065007C0050006100
      6700650020002600570069006400740068007C002600540077006F0020005000
      61006700650073007C005400680075006D00620026006E00610069006C000000}
  end
  inherited PnlBtnsFunctions: TPanel
    Width = 630
  end
  object QryTransInvBO: TQuery
    DatabaseName = 'DBFlexpoint'
    SQL.Strings = (
      'SELECT'
      '  POSTransDetail.IdtCVente,'
      '  POSTransDetail.CodTypeVente,'
      '  POSTransaction.DatTransBegin,'
      '  POSTransaction.IdtPOSTransaction,'
      '  POSTransaction.IdtCheckout,'
      '  POSTransaction.IdtOperator,'
      '  FlgDocExists = CASE  (SELECT TOP 1 CVente'
      '                       FROM Vente (NOLOCK)'
      
        '                      WHERE Vente.CVente = POSTransDetail.IdtCVe' +
        'nte'
      
        '                        AND Vente.Type_Vente = POSTransDetail.Co' +
        'dTypeVente)'
      '   WHEN NULL'
      '        THEN 0'
      '        ELSE 1'
      '   END,'
      '  POSTransaction.CodTrans'
      'FROM POSTransaction (NOLOCK)'
      'INNER JOIN PosTransDetail (NOLOCK) ON'
      
        '  POSTransDetail.IdtPOSTransaction = POSTransaction.IdtPOSTransa' +
        'ction'
      '  AND POSTransDetail.IdtCheckout = POSTransaction.IdtCheckout'
      '  AND POSTransDetail.CodTrans = POSTransaction.CodTrans'
      
        '  AND POSTransDetail.DatTransBegin = POSTransaction.DatTransBegi' +
        'n'
      
        'WHERE PosTransaction.DatTransBegin BETWEEN :PrmDatBegin AND :Prm' +
        'DatEnd'
      '  AND POSTransaction.FlgTraining = 0'
      '  AND POSTransaction.CodState = 4'
      '  AND POSTransDetail.IdtCVente IS NOT NULL'
      '  AND POSTransDetail.CodType = 351'
      '  AND ((POSTransaction.CodReturn IS NULL)'
      '       OR (PosTransaction.CodReturn in (11,12)))'
      '  AND NOT EXISTS'
      '      (SELECT IdtPosTransaction'
      '         FROM PosTransaction P1'
      
        '         WHERE P1.IdtPOSTransResume = POSTransaction.IdtPOSTrans' +
        'action'
      '           AND P1.IdtCheckoutResume = POSTransaction.IdtCheckout'
      
        '           AND P1.DatTransBeginResume = POSTransaction.DatTransB' +
        'egin)'
      '  AND NOT EXISTS'
      '      (SELECT IdtPOSTransaction'
      '         FROM PosTransDetail Det (NOLOCK)'
      
        '         WHERE Det.IdtPOSTransaction = POSTransaction.IdtPOSTran' +
        'saction'
      '           AND Det.IdtCheckout = POSTransaction.IdtCheckout'
      '           AND Det.CodTrans = POSTransaction.CodTrans'
      '           AND Det.DatTransBegin = POSTransaction.DatTransBegin'
      '           AND Det.IdtCVente = POSTransDetail.IdtCVente'
      '           AND Det.CodTypeVente = POSTransDetail.CodTypeVente'
      '           AND Det.CodAction in (1,2))'
      '  AND NOT EXISTS'
      '      (SELECT * FROM POSTransDetail Det1 (NOLOCK)'
      
        '         WHERE POSTransaction.IdtPOSTransaction = Det1.IdtPOSTra' +
        'nsaction'
      '           AND POSTransaction.IdtCheckOut = Det1.IdtCheckOut'
      '           AND POSTransaction.CodTrans = Det1.CodTrans'
      '           AND POSTransaction.DatTransBegin = Det1.DatTransBegin'
      '           AND Det1.CodAction = 86)'
      'ORDER BY IdtCVente')
    Left = 74
    Top = 86
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'PrmDatBegin'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'PrmDatEnd'
        ParamType = ptUnknown
      end>
  end
  object QryVenteInvBO: TQuery
    DatabaseName = 'DBFlexpoint'
    SQL.Strings = (
      
        'SELECT CETAB, CVENTE, TYPE_VENTE, DCREATION, CCLIENT, M_TOTAL_VE' +
        'NTE'
      'FROM VENTE V'
      'WHERE NOT EXISTS (SELECT 0'
      #9#9'    FROM PosTransDetail TD'
      '                   WHERE TD.IdtCVente = V.CVENTE)'
      '  AND TSITUATION_C104 = 2'
      '  AND DCREATION BETWEEN :PrmTxtDatFrom AND :PrmTxtDatTo'
      'ORDER BY CVENTE, TYPE_VENTE')
    Left = 78
    Top = 142
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'PrmTxtDatFrom'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'PrmTxtDatTo'
        ParamType = ptUnknown
      end>
  end
  object QryPosTransDetail: TQuery
    DatabaseName = 'DBFlexpoint'
    SQL.Strings = (
      'SELECT *'
      'FROM PosTransDetail'
      'WHERE IdtPosTransaction = :IdtPosTransaction'
      '  AND IdtCheckout = :IdtCheckout'
      '  AND CodTrans = :CodTrans'
      '  AND DatTransBegin = :DatTransBegin'
      '  AND CodAction = 1'
      '  AND IdtCVente IS NULL')
    Left = 74
    Top = 202
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'IdtPosTransaction'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'IdtCheckout'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'CodTrans'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'DatTransBegin'
        ParamType = ptUnknown
      end>
  end
end
