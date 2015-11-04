inherited FrmRptCfgChoice: TFrmRptCfgChoice
  Left = 298
  Top = 203
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlSpdBtnsAndPgsBar: TPanel
    inherited PnlSpdBtns: TPanel
      inherited LblSize: TLabel
        Caption = 'F&ont size:'
      end
      inherited PnlSpdBtnsLeft: TPanel
        inherited BtnExportToFile: TSpeedButton
          Visible = True
        end
      end
      inherited CbxFontSize: TComboBox
        TabStop = False
      end
    end
  end
  inherited SbxRptCfg: TScrollBox
    object SptRptCfgChoice: TSplitter
      Left = 395
      Top = 0
      Width = 4
      Height = 336
    end
    object PnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 395
      Height = 336
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object SptRptFields: TSplitter
        Left = 179
        Top = 0
        Width = 4
        Height = 317
      end
      object PnlLeftCenter: TPanel
        Left = 183
        Top = 0
        Width = 37
        Height = 317
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object BtnIncl: TSpeedButton
          Left = 6
          Top = 17
          Width = 25
          Height = 25
          Hint = 'Include field'
          Caption = '>'
          ParentShowHint = False
          ShowHint = True
          OnClick = MniInclExclClick
        end
        object BtnInclAll: TSpeedButton
          Left = 6
          Top = 46
          Width = 25
          Height = 25
          Hint = 'Include all fields'
          Caption = '>>'
          ParentShowHint = False
          ShowHint = True
          OnClick = MniInclExclAllClick
        end
        object BtnExcl: TSpeedButton
          Left = 6
          Top = 85
          Width = 25
          Height = 25
          Hint = 'Exclude field'
          Caption = '<'
          ParentShowHint = False
          ShowHint = True
          OnClick = MniInclExclClick
        end
        object BtnExclAll: TSpeedButton
          Left = 6
          Top = 114
          Width = 25
          Height = 25
          Hint = 'Exclude all fields'
          Caption = '<<'
          ParentShowHint = False
          ShowHint = True
          OnClick = MniInclExclAllClick
        end
        object BtnMoveUp: TSpeedButton
          Left = 6
          Top = 216
          Width = 25
          Height = 25
          Hint = 'Move field one postion up'
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            0400000000000001000000000000000000001000000010000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000333
            3333333333777F33333333333309033333333333337F7F333333333333090333
            33333333337F7F33333333333309033333333333337F7F333333333333090333
            33333333337F7F33333333333309033333333333FF7F7FFFF333333000090000
            3333333777737777F333333099999990333333373F3333373333333309999903
            333333337F33337F33333333099999033333333373F333733333333330999033
            3333333337F337F3333333333099903333333333373F37333333333333090333
            33333333337F7F33333333333309033333333333337373333333333333303333
            333333333337F333333333333330333333333333333733333333}
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
          OnClick = MniMoveUpClick
        end
        object BtnMoveDn: TSpeedButton
          Left = 6
          Top = 248
          Width = 25
          Height = 25
          Hint = 'Move field one position down'
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            0400000000000001000000000000000000001000000010000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
            333333333337F33333333333333033333333333333373F333333333333090333
            33333333337F7F33333333333309033333333333337373F33333333330999033
            3333333337F337F33333333330999033333333333733373F3333333309999903
            333333337F33337F33333333099999033333333373333373F333333099999990
            33333337FFFF3FF7F33333300009000033333337777F77773333333333090333
            33333333337F7F33333333333309033333333333337F7F333333333333090333
            33333333337F7F33333333333309033333333333337F7F333333333333090333
            33333333337F7F33333333333300033333333333337773333333}
          NumGlyphs = 2
          ParentShowHint = False
          ShowHint = True
          OnClick = MniMoveDnClick
        end
      end
      object LbxChoice: TListBox
        Left = 220
        Top = 0
        Width = 175
        Height = 317
        Style = lbOwnerDrawFixed
        Align = alClient
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 2
        OnClick = LbxAvailChoiceClick
        OnDblClick = LbxAvailChoiceDblClick
        OnDrawItem = LbxDrawItem
        OnEnter = LbxAvailChoiceEnter
      end
      object LbxAvail: TListBox
        Left = 0
        Top = 0
        Width = 179
        Height = 336
        Style = lbOwnerDrawFixed
        Align = alLeft
        ItemHeight = 13
        MultiSelect = True
        TabOrder = 0
        OnClick = LbxAvailChoiceClick
        OnDblClick = LbxAvailChoiceDblClick
        OnDrawItem = LbxDrawItem
        OnEnter = LbxAvailChoiceEnter
      end
    end
    object PnlRight: TPanel
      Left = 399
      Top = 0
      Width = 233
      Height = 336
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object GbxFldCond: TGroupBox
        Left = 0
        Top = 0
        Width = 233
        Height = 185
        Align = alTop
        Caption = 'Field conditions'
        TabOrder = 0
        DesignSize = (
          233
          185)
        object LblCondLower: TLabel
          Left = 6
          Top = 90
          Width = 52
          Height = 13
          Caption = 'Lower limit:'
          Enabled = False
        end
        object LblCondUpper: TLabel
          Left = 6
          Top = 130
          Width = 52
          Height = 13
          Caption = 'Upper limit:'
          Enabled = False
        end
        object LblFldCondTrue: TLabel
          Left = 8
          Top = 24
          Width = 25
          Height = 13
          Caption = 'True:'
        end
        object LblCondition: TLabel
          Left = 6
          Top = 50
          Width = 47
          Height = 13
          Caption = 'Condition:'
        end
        object LblCondSubStr: TLabel
          Left = 6
          Top = 90
          Width = 25
          Height = 13
          Caption = 'With:'
        end
        object CbxCondLower: TComboBox
          Left = 6
          Top = 103
          Width = 220
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 5
          Enabled = False
          ItemHeight = 0
          TabOrder = 5
          OnChange = CbxCondLowUpChange
        end
        object SvcLFCondLower: TSvcLocalField
          Left = 6
          Top = 103
          Width = 220
          Height = 21
          Cursor = crIBeam
          DataType = pftString
          Anchors = [akLeft, akTop, akRight]
          CaretOvr.Shape = csBlock
          Controller = OvcCtlRptCfg
          ControlCharColor = clRed
          DecimalPlaces = 0
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Enabled = False
          Epoch = 0
          InitDateTime = False
          PictureMask = 'XXXXXXXXXXXXXXX'
          TabOrder = 3
          OnChange = SvcLFCondLowUpChange
          OnUserValidation = SvcLFCondLowerUserValidation
          LocalOptions = [lfoForceCentury]
          Local = True
        end
        object CbxFieldCond: TComboBox
          Left = 6
          Top = 63
          Width = 220
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 5
          Enabled = False
          ItemHeight = 13
          TabOrder = 2
          OnChange = CbxFieldCondChange
          Items.Strings = (
            'No condition'
            'Value must be empty'
            'Value must be filled in'
            'Value between limits'
            'Value contains substring')
        end
        object RbtFldCondAll: TRadioButton
          Left = 56
          Top = 24
          Width = 70
          Height = 17
          Caption = 'All'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object RbtFldCondOne: TRadioButton
          Left = 130
          Top = 24
          Width = 95
          Height = 17
          Caption = 'Only one'
          TabOrder = 1
        end
        object SvcLFCondUpper: TSvcLocalField
          Left = 6
          Top = 143
          Width = 220
          Height = 21
          Cursor = crIBeam
          DataType = pftString
          Anchors = [akLeft, akTop, akRight]
          CaretOvr.Shape = csBlock
          Controller = OvcCtlRptCfg
          ControlCharColor = clRed
          DecimalPlaces = 0
          EFColors.Disabled.BackColor = clWindow
          EFColors.Disabled.TextColor = clGrayText
          EFColors.Error.BackColor = clRed
          EFColors.Error.TextColor = clBlack
          EFColors.Highlight.BackColor = clHighlight
          EFColors.Highlight.TextColor = clHighlightText
          Enabled = False
          Epoch = 0
          InitDateTime = False
          PictureMask = 'XXXXXXXXXXXXXXX'
          TabOrder = 4
          OnChange = SvcLFCondLowUpChange
          OnUserValidation = SvcLFCondUpperUserValidation
          LocalOptions = [lfoForceCentury]
          Local = True
        end
        object CbxCondUpper: TComboBox
          Left = 6
          Top = 143
          Width = 220
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          DropDownCount = 5
          Enabled = False
          ItemHeight = 0
          TabOrder = 6
          OnChange = CbxCondLowUpChange
        end
        object SvcMECondLower: TSvcMaskEdit
          Left = 6
          Top = 103
          Anchors = [akLeft, akTop, akRight]
          Properties.OnValidate = SvcMECondLowerPropertiesValidate
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 7
          Width = 220
        end
        object SvcMECondUpper: TSvcMaskEdit
          Left = 6
          Top = 143
          Anchors = [akLeft, akTop, akRight]
          Properties.OnValidate = SvcMECondUpperPropertiesValidate
          Style.BorderStyle = ebs3D
          Style.HotTrack = False
          StyleDisabled.Color = clWindow
          TabOrder = 8
          Width = 220
        end
      end
      object GbxInclOnRpt: TGroupBox
        Left = 0
        Top = 185
        Width = 233
        Height = 80
        Align = alTop
        Caption = 'Include on report'
        TabOrder = 1
        object ChxInclLegend: TCheckBox
          Left = 8
          Top = 23
          Width = 100
          Height = 17
          TabStop = False
          Caption = '&Legend'
          TabOrder = 0
        end
        object ChxInclConditions: TCheckBox
          Left = 8
          Top = 48
          Width = 100
          Height = 17
          TabStop = False
          Caption = '&Conditions'
          TabOrder = 1
        end
      end
    end
  end
  inherited PnlSeqAndLim: TPanel
    inherited PnlLimits: TPanel
      inherited SvcLFLimitFrom: TSvcLocalField
        Epoch = 0
      end
      inherited SvcLFLimitTo: TSvcLocalField
        Epoch = 0
      end
    end
  end
  inherited OvcCtlRptCfg: TOvcController
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
  end
  inherited MnuRptCfg: TMainMenu
    object MniSelection: TMenuItem [1]
      Caption = '&Selection'
      object MniIncl: TMenuItem
        Caption = '&Include'
        ShortCut = 16429
        OnClick = MniInclExclClick
      end
      object MniInclAll: TMenuItem
        Caption = 'I&nclude all'
        ShortCut = 24621
        OnClick = MniInclExclAllClick
      end
      object MniSep5: TMenuItem
        Caption = '-'
      end
      object MniExcl: TMenuItem
        Caption = '&Exclude'
        ShortCut = 16430
        OnClick = MniInclExclClick
      end
      object MniExclAll: TMenuItem
        Caption = 'E&xclude all'
        ShortCut = 24622
        OnClick = MniInclExclAllClick
      end
      object MniSep6: TMenuItem
        Caption = '-'
      end
      object MniMoveUp: TMenuItem
        Caption = '&Move &Up'
        ShortCut = 16469
        OnClick = MniMoveUpClick
      end
      object MniMoveDn: TMenuItem
        Caption = 'Move &Down'
        ShortCut = 16452
        OnClick = MniMoveDnClick
      end
    end
  end
end
