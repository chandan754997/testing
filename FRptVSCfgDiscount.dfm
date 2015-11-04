inherited FrmRptCfgDiscount: TFrmRptCfgDiscount
  Width = 480
  Height = 420
  Caption = 'Report Discount: select parameters'
  Constraints.MinHeight = 420
  Constraints.MinWidth = 480
  PixelsPerInch = 96
  TextHeight = 13
  inherited StsBarExec: TStatusBar
    Top = 355
    Width = 472
  end
  inherited PgsBarExec: TProgressBar
    Top = 339
    Width = 472
  end
  inherited PnlBtnsTop: TPanel
    Width = 472
    inherited BtnExit: TSpeedButton
      Left = 406
    end
  end
  inherited GbxLogging: TGroupBox
    Left = 8
    Top = -195
  end
  object SbxGeneral: TScrollBox [4]
    Left = 0
    Top = 41
    Width = 472
    Height = 298
    Align = alClient
    TabOrder = 4
    object SplSettings: TSplitter
      Left = 230
      Top = 0
      Width = 5
      Height = 294
      AutoSnap = False
      MinSize = 230
    end
    object PnlCheckOperators: TPanel
      Left = 0
      Top = 0
      Width = 230
      Height = 294
      Align = alLeft
      TabOrder = 0
      object SbxCheck: TScrollBox
        Left = 1
        Top = 1
        Width = 228
        Height = 292
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvRaised
        TabOrder = 0
        object PnlSelectLeft: TPanel
          Left = 0
          Top = 250
          Width = 224
          Height = 38
          Align = alBottom
          TabOrder = 0
          DesignSize = (
            224
            38)
          object BtnSelectAllLeft: TBitBtn
            Left = 8
            Top = 8
            Width = 100
            Height = 25
            Anchors = [akRight, akBottom]
            Caption = 'Select All'
            TabOrder = 0
            OnClick = BtnSelectAllLeftClick
          end
          object BtnDeSelectAllLeft: TBitBtn
            Left = 118
            Top = 8
            Width = 100
            Height = 25
            Anchors = [akRight, akBottom]
            Caption = 'Deselect All'
            TabOrder = 1
            OnClick = BtnDeSelectAllLeftClick
          end
        end
        object ChkLbxOperators: TCheckListBox
          Left = 0
          Top = 0
          Width = 224
          Height = 250
          Align = alClient
          ItemHeight = 13
          TabOrder = 1
        end
      end
    end
    object PnlSettings: TPanel
      Left = 235
      Top = 0
      Width = 233
      Height = 294
      Align = alClient
      TabOrder = 1
      object SbxSettings: TScrollBox
        Left = 1
        Top = 1
        Width = 231
        Height = 292
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvRaised
        TabOrder = 0
        object PnlDates: TPanel
          Left = 0
          Top = 0
          Width = 227
          Height = 54
          Align = alTop
          TabOrder = 0
          object SvcDBLblDateFrom: TSvcDBLabelLoaded
            Left = 8
            Top = 8
            Width = 23
            Height = 13
            Caption = 'From'
            IdtLabel = 'TxtFrom'
          end
          object SvcDBLblDateTo: TSvcDBLabelLoaded
            Left = 8
            Top = 32
            Width = 13
            Height = 13
            Caption = 'To'
            IdtLabel = 'TxtTo'
          end
          object DtmPckDayFrom: TDateTimePicker
            Left = 80
            Top = 4
            Width = 100
            Height = 21
            Date = 37420.429163692130000000
            Time = 37420.429163692130000000
            TabOrder = 0
          end
          object DtmPckDayTo: TDateTimePicker
            Left = 80
            Top = 28
            Width = 100
            Height = 21
            Date = 37420.429163692130000000
            Time = 37420.429163692130000000
            TabOrder = 1
          end
        end
        object PnlLayout: TPanel
          Left = 0
          Top = 54
          Width = 227
          Height = 30
          Align = alTop
          TabOrder = 1
          object SvcDBLblLayout: TSvcDBLabelLoaded
            Left = 8
            Top = 8
            Width = 32
            Height = 13
            Caption = 'Layout'
            IdtLabel = 'TxtLayout'
          end
          object CbxLayout: TComboBox
            Left = 80
            Top = 4
            Width = 140
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 0
            Text = 'Global'
            OnChange = CbxLayoutChange
            Items.Strings = (
              'Global'
              'Operator'
              'Ticket'
              'Customer'
              'Personnel')
          end
        end
        object PnlDetail: TPanel
          Left = 0
          Top = 114
          Width = 227
          Height = 30
          Align = alTop
          TabOrder = 2
          object SvcDBLblDetail: TSvcDBLabelLoaded
            Left = 8
            Top = 8
            Width = 27
            Height = 13
            Caption = 'Detail'
            IdtLabel = 'TxtDetail'
          end
          object CbxDetail: TComboBox
            Left = 80
            Top = 4
            Width = 140
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 2
            TabOrder = 0
            Text = 'All lines'
            Items.Strings = (
              'Detail lines only'
              'Total lines only'
              'All lines')
          end
        end
        object PnlSelectRight: TPanel
          Left = 0
          Top = 250
          Width = 227
          Height = 38
          Align = alBottom
          TabOrder = 3
          DesignSize = (
            227
            38)
          object BtnSelectAllRight: TBitBtn
            Left = 8
            Top = 8
            Width = 100
            Height = 25
            Anchors = [akRight, akBottom]
            Caption = 'Select All'
            TabOrder = 0
            OnClick = BtnSelectAllRightClick
          end
          object BtnDeSelectRight: TBitBtn
            Left = 121
            Top = 8
            Width = 100
            Height = 25
            Anchors = [akRight, akBottom]
            Caption = 'Deselect All'
            TabOrder = 1
            OnClick = BtnDeSelectRightClick
          end
        end
        object PnlCheckDiscountCustCategories: TPanel
          Left = 0
          Top = 144
          Width = 227
          Height = 106
          Align = alClient
          TabOrder = 4
          object PgeCtlCheck: TPageControl
            Left = 1
            Top = 1
            Width = 225
            Height = 104
            ActivePage = TabShtDiscount
            Align = alClient
            TabOrder = 0
            object TabShtDiscount: TTabSheet
              Caption = 'Discount'
              object ChkLbxDiscountTypes: TCheckListBox
                Left = 0
                Top = 0
                Width = 217
                Height = 76
                Align = alClient
                ItemHeight = 13
                TabOrder = 0
              end
            end
            object TabShtCustCategories: TTabSheet
              Caption = 'Customer Categories'
              ImageIndex = 1
              object ChkLbxCustCategories: TCheckListBox
                Left = 0
                Top = 0
                Width = 217
                Height = 76
                Align = alClient
                ItemHeight = 13
                TabOrder = 0
              end
            end
          end
        end
        object PnlNumber: TPanel
          Left = 0
          Top = 84
          Width = 227
          Height = 30
          Align = alTop
          TabOrder = 5
          object SvcDBLblNumber: TSvcDBLabelLoaded
            Left = 8
            Top = 8
            Width = 37
            Height = 13
            Caption = 'Number'
            IdtLabel = 'TxtNumber'
          end
          object SvcLFNumber: TSvcLocalField
            Left = 80
            Top = 4
            Width = 100
            Height = 21
            Cursor = crIBeam
            DataType = pftLongInt
            CaretOvr.Shape = csBlock
            Controller = OvcCtlDetail
            ControlCharColor = clRed
            DecimalPlaces = 0
            EFColors.Disabled.BackColor = clWindow
            EFColors.Disabled.TextColor = clGrayText
            EFColors.Error.BackColor = clRed
            EFColors.Error.TextColor = clBlack
            EFColors.Highlight.BackColor = clHighlight
            EFColors.Highlight.TextColor = clHighlightText
            Epoch = 0
            InitDateTime = False
            MaxLength = 11
            Options = [efoCaretToEnd]
            PictureMask = 'iiiiiiiiiii'
            TabOrder = 0
            LocalOptions = []
            Local = False
            RangeHigh = {FFFFFF7F000000000000}
            RangeLow = {00000000000000000000}
          end
        end
      end
    end
  end
  inherited SvcExHApp: TSvcExceptHandler
    Left = 432
    Top = 280
  end
  inherited SvcAppInstCheck: TSvcAppInstance
    Top = 280
  end
  object OvcCtlDetail: TOvcController
    EntryCommands.TableList = (
      'Default'
      True
      ()
      'WordStar'
      False
      ()
      'Grid'
      False
      ())
    EntryOptions = [efoAutoSelect, efoBeepOnError]
    Epoch = 1980
    Left = 384
    Top = 136
  end
end
