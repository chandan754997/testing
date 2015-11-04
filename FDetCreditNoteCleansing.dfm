inherited FrmDetCreditCouponCleansing: TFrmDetCreditCouponCleansing
  Left = 106
  Top = 153
  Width = 517
  Height = 395
  Caption = 'Report credit coupon cleansing1'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded
    Left = 40
    Top = 78
    Visible = False
  end
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Left = 40
    Top = 138
    Visible = False
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Left = 280
    Top = 78
    Visible = False
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Left = 280
    Top = 138
    Visible = False
  end
  inherited StsBarExec: TStatusBar
    Top = 349
    Width = 509
    Visible = False
  end
  inherited PgsBarExec: TProgressBar
    Top = 333
    Width = 509
  end
  inherited PnlBtnsTop: TPanel
    Width = 509
    inherited BtnStart: TSpeedButton
      Left = 72
    end
    inherited BtnExit: TSpeedButton
      Left = 443
    end
    inherited BtnPrintSetup: TSpeedButton
      Left = 234
      Visible = False
    end
  end
  inherited GbxLogging: TGroupBox
    Left = -50
    Top = -565
  end
  inherited DtmPckDayFrom: TDateTimePicker
    Left = 120
    Top = 73
    Visible = False
  end
  inherited Panel1: TPanel
    Top = -228
    Height = 0
    Visible = False
    inherited ChkLbxOperator: TCheckListBox
      Height = 0
      ParentFont = False
    end
    inherited BtnSelectAll: TBitBtn
      Top = -64
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = -32
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Left = 120
    Top = 133
    Visible = False
  end
  inherited RbtDateDay: TRadioButton
    Left = 16
    Top = 54
    Visible = False
  end
  inherited RbtDateLoaded: TRadioButton
    Left = 16
    Top = 110
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker
    Top = 73
    Visible = False
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Top = 133
    Visible = False
  end
  inherited SvcExHApp: TSvcExceptHandler
    Left = 296
    Top = 0
  end
  inherited SvcAppInstCheck: TSvcAppInstance
    Top = 0
  end
  inherited TmrExec: TTimer
    Left = 168
    Top = 0
  end
  inherited ActLstApp: TActionList
    Left = 392
    Top = 0
  end
  inherited ImgLstApp: TImageList
    Left = 344
    Top = 0
  end
  inherited MnuApp: TMainMenu
    Left = 120
    Top = 0
    inherited MniFile: TMenuItem
      object MniPreview: TMenuItem [0]
        Bitmap.Data = {
          2E020000424D2E0200000000000036000000280000000C0000000E0000000100
          180000000000F801000000000000000000000000000000000000008080008080
          0000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F0000000080800080
          80008080008080008080000000BFBFBFBFBFBFBFBFBF00000000808000808000
          8080000000000000000000000000000000000000000000000000000000000000
          000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF0000FFFFFFFFFFFFFF7F7F7FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
          BFBFBFBFBFBFBFBFBFBFBF7F7F7FFFFFFF7F7F7F000000000000000000000000
          000000000000000000000000000000BFBFBFFFFFFF7F7F7F00000000FF0000FF
          0000FF0000FF0000FF0000FF0000FF00000000BFBFBFFFFFFF7F7F7F00000000
          FF00FF00FFFF00FFFF00FFFF00FFFF00FF00FF00000000BFBFBFFFFFFF7F7F7F
          00000000FF000000FF0000FF00FF000000FF0000FF00FF00000000BFBFBFFFFF
          FF7F7F7F00000000FF000000FF0000FF00FF000000FF0000FF00FF00000000BF
          BFBFFFFFFF7F7F7F00000000FF0000FF0000FF0000FF0000FF0000FF0000FF00
          000000BFBFBFFFFFFF7F7F7F0000000000000000000000000000000000000000
          00000000000000BFBFBFFFFFFF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
          7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        Caption = '&Preview'
        OnClick = MniPreviewClick
      end
    end
  end
end
