//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet : FlexPoint
// Unit   : FSelDateTime = Form VideoSoft RePorT Document Back Office
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FSelDateTime.pas,v 1.1 2006/12/20 14:57:04 hofmansb Exp $
// History:
//=============================================================================

unit FSelDateTime;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, StdCtrls, ComCtrls, Buttons;

//=============================================================================
// Global definitions
//=============================================================================

//*****************************************************************************
// TFrmSelDateTime
//*****************************************************************************

type
  TFrmSelDateTime = class(TFrmCommon)
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    DtmPckFrom: TDateTimePicker;
    DtmPckTo: TDateTimePicker;
    LblDateFrom: TLabel;
    LblDateTo: TLabel;
    procedure BtnOkClick(Sender: TObject);
    procedure DtmPckFromExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  protected
    // Datafields for properties
    FDatBeginSel        : TDateTime;   // Begin date of selection
    FDatEndSel          : TDateTime;   // End date of selection
  public
  published
    property DatBeginSel : TDateTime read  FDatBeginSel
                                     write FDatBeginSel;
    property DatEndSel : TDateTime read  FDatEndSel
                                   write FDatEndSel;
  end;

var
  FrmSelDateTime: TFrmSelDateTime;

implementation

{$R *.DFM}

uses
  SfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FSelDateTime';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FSelDateTime.pas  $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/20 14:57:04 $';

//*****************************************************************************
// Implementation of TFrmSelDateTime
//*****************************************************************************

procedure TFrmSelDateTime.BtnOkClick(Sender: TObject);
begin  // of TFrmSelDateTime.BtnOkClick
  BtnOk.SetFocus;
  inherited;
  DatBeginSel := Trunc (DtmPckFrom.DateTime);
  DatEndSel   := Trunc (DtmPckTo.DateTime) + 0.9999;
end;   // of TFrmSelDateTime.BtnOkClick

//=============================================================================

procedure TFrmSelDateTime.DtmPckFromExit(Sender: TObject);
begin  // of TFrmSelDateTime.DtmPckFromExit
  inherited;
end;   // of TFrmSelDateTime.DtmPckFromExit

//=============================================================================

procedure TFrmSelDateTime.FormActivate(Sender: TObject);
begin  // of TFrmSelDateTime.FormActivate
  inherited;
  DtmPckFrom.DateTime := now;
  DtmPckTo.DateTime := now;
end;   // of TFrmSelDateTime.FormActivate

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FSelDateTime
