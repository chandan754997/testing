inherited FrmDetManInvoiceCommentCA: TFrmDetManInvoiceCommentCA
  Left = 363
  Top = 317
  Width = 443
  Height = 158
  Caption = 'Invoice Comment'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    Width = 435
    Height = 9
  end
  inherited PnlBottom: TPanel
    Top = 73
    Width = 435
    inherited PnlBottomRight: TPanel
      Left = 247
      inherited BtnOK: TBitBtn
        OnClick = BtnOKClick
      end
    end
    inherited PnlBtnAdd: TPanel
      Left = 151
    end
  end
  inherited PgeCtlDetail: TPageControl
    Top = 9
    Width = 435
    Height = 64
    ActivePage = TabShtComments
    object TabShtComments: TTabSheet
      Caption = 'Comments'
      object SvcDBLblComment: TSvcDBLabelLoaded
        Left = 8
        Top = 19
        Width = 44
        Height = 13
        Caption = 'Comment'
        IdtLabel = 'SvcDBLblComment'
      end
      object SvcMEComment: TSvcMaskEdit
        Left = 104
        Top = 11
        Properties.MaxLength = 250
        Properties.OnChange = SvcMECommentPropertiesChange
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 0
        Width = 305
      end
    end
  end
  inherited StsBarInfo: TStatusBar
    Top = 105
    Width = 435
  end
  inherited OvcCtlDetail: TOvcController
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
