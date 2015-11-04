inherited FrmRptCfgChoiceCA: TFrmRptCfgChoiceCA
  Caption = 'FrmRptCfgChoiceCA'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SbxRptCfg: TScrollBox
    inherited PnlRight: TPanel
      inherited GbxFldCond: TGroupBox
        inherited SvcLFCondLower: TSvcLocalField
          Epoch = 0
        end
        inherited SvcLFCondUpper: TSvcLocalField
          Epoch = 0
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
end
