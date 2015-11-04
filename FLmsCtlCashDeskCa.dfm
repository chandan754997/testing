inherited FrmLmsCtlCashDeskCa: TFrmLmsCtlCashDeskCa
  Caption = 'FrmLmsCtlCashDeskCa'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlList: TPanel
    Height = 213
    inherited DBGrdList: TDBGrid
      Height = 211
    end
  end
  inherited PnlSeqLimRefresh: TPanel
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
  end
  inherited PnlProgress: TPanel
    Top = 368
  end
  inherited StsBarList: TStatusBar
    Top = 395
  end
  inherited OvcCtlList: TOvcController
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
  inherited MmuList: TMainMenu
    inherited MniHelp: TMenuItem
      object mniSepLogFile: TMenuItem
        Caption = '-'
      end
      object mniShowLogFile: TMenuItem
        Caption = 'Consult LogFile...'
        OnClick = mniShowLogFileClick
      end
    end
  end
end
