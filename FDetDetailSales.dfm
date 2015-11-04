inherited FrmDetDetailSales: TFrmDetDetailSales
  Height = 375
  Caption = 'Sales report by product'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded
    Top = 72
  end
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Left = 112
    Visible = False
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Top = 96
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Left = 104
    Top = 184
    Visible = False
  end
  object LblDatTrans: TLabel [4]
    Left = 248
    Top = 56
    Width = 83
    Height = 13
    Caption = 'Transaction date:'
  end
  object LblTransNum: TLabel [5]
    Left = 248
    Top = 120
    Width = 97
    Height = 13
    Caption = 'Transaction number:'
  end
  object LblCustNum: TLabel [6]
    Left = 248
    Top = 144
    Width = 85
    Height = 13
    Caption = 'Customer number:'
  end
  object LbLBarcode: TLabel [7]
    Left = 248
    Top = 168
    Width = 43
    Height = 13
    Caption = 'Barcode:'
  end
  object LblDepartment: TLabel [8]
    Left = 248
    Top = 192
    Width = 58
    Height = 13
    Caption = 'Department:'
  end
  object LblSalesType: TLabel [9]
    Left = 248
    Top = 216
    Width = 52
    Height = 13
    Caption = 'Sales type:'
  end
  object LblCustorder: TLabel [10]
    Left = 248
    Top = 240
    Width = 74
    Height = 13
    Caption = 'Customer order:'
  end
  inherited StsBarExec: TStatusBar
    Top = 329
  end
  inherited PgsBarExec: TProgressBar
    Top = 313
    TabOrder = 2
  end
  inherited PnlBtnsTop: TPanel
    TabOrder = 3
  end
  inherited GbxLogging: TGroupBox
    Left = 0
    Top = -310
    TabOrder = 4
  end
  inherited DtmPckDayFrom: TDateTimePicker
    TabOrder = 5
  end
  inherited Panel1: TPanel
    Height = 177
    Caption = ''
    TabOrder = 1
    inherited ChkLbxOperator: TCheckListBox
      Height = 101
    end
    inherited BtnSelectAll: TBitBtn
      Top = 113
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 145
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Left = 64
    Top = 160
    TabOrder = 13
    Visible = False
  end
  inherited RbtDateDay: TRadioButton
    Left = 40
    Top = 168
    TabOrder = 14
    Visible = False
  end
  inherited RbtDateLoaded: TRadioButton
    Left = 56
    Top = 152
    TabOrder = 15
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker
    TabOrder = 6
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Left = 72
    Top = 136
    TabOrder = 16
    Visible = False
  end
  object EdtTransNum: TEdit [22]
    Left = 360
    Top = 120
    Width = 121
    Height = 21
    TabOrder = 7
  end
  object EdtCustNum: TEdit [23]
    Left = 360
    Top = 144
    Width = 121
    Height = 21
    MaxLength = 12
    TabOrder = 8
  end
  object EdtBarcode: TEdit [24]
    Left = 360
    Top = 168
    Width = 121
    Height = 21
    TabOrder = 9
  end
  object EdtCustOrder: TEdit [25]
    Left = 360
    Top = 240
    Width = 121
    Height = 21
    MaxLength = 10
    TabOrder = 12
  end
  object CmbbxDepartment: TComboBox [26]
    Left = 360
    Top = 192
    Width = 122
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 10
    OnKeyDown = CmbbxDepartmentKeyDown
  end
  object CmbbxSalesType: TComboBox [27]
    Left = 360
    Top = 216
    Width = 122
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 11
  end
  inherited TmrExec: TTimer
    Left = 160
    Top = 80
  end
  inherited ActLstApp: TActionList
    Left = 64
    Top = 128
  end
  inherited ImgLstApp: TImageList
    Left = 136
    Top = 136
  end
  inherited MnuApp: TMainMenu
    Left = 64
    Top = 144
  end
end
