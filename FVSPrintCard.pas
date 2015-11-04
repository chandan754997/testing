//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint Development
// Unit   : FVSPrintCard.PAS : Print form of employee cards
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSPrintCard.pas,v 1.2 2009/09/28 15:32:01 BEL\KDeconyn Exp $
// History:
// - Started from castorama - Flexpoint20 - FVSPrintCard - rev 1.3
//=============================================================================

unit FVSPrintCard;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfVSPrinter7, ActnList, ImgList, Menus, OleCtrls, SmVSPrinter7Lib_TLB,
  Buttons, ComCtrls, ToolWin, StBarC, ExtCtrls;

//*****************************************************************************

const
  CtQtyCardsOnPage = 4;
  CtPosXCard       = 500;
  CtPosYCard       = 0;
  CtWidthCard      = 4931;   //5100
  CtHeigthCard     = 3123 ;  //3180

  CtPosXLogo       = 520;
  CtPosYLogo       = 20;
  CtWidthLogo      = 2160;
  CtHeightLogo     = 660;


  CtPosXBarCode    = 2670;
  CtPosYBarCode    = -40;
  CtWidthBarCode   = 2831;  //3000
  CtHeightBarCode  = 1000;

  CtPosXEmpNum     = 620;
  CtPosYEmpNum     = 1080;
  CtWidthEmpNum    = 2630; //2700
  CtHeightEmpNum   = 345; //360

  CtPosXName       = 620;
  CtPosYName       = 1605;  //1620
  CtWidthName      = 2630;  //2700
  CtHeightName     = 345; //360

  CtPosXSurName    = 620;
  CtPosYSurName    = 2145;  //2160
  CtWidthSurName   = 2630;  //2700
  CtHeightSurName  = 345; //360

  CtPosXPosition   = 620;
  CtPosYPosition   = 2685;  //2700
  CtWidthPosition  = 2630;  //2700
  CtHeightPosition = 400; //440

  CtPosXPhoto      = 3641;  //3740
  CtPosYPhoto      = 1080;
  CtWidthPhoto     = 1730;   //1800
  CtHeightPhoto    = 1943;   //2000

  CtTxtBarCode     = 'barcode.bmp';    // bitmap image of the barcode
  CtTxtLogoName    = 'flexpoint.report.bmp';    // Logo to print on the rapport

resourcestring
  CtTxtEmployeeNumber = 'Employee number';
  CtTxtName           = 'Name';
  CtTxtSurName        = 'Surname';
  CtTxtPosition       = 'Position';
  CtTxtPage           = 'Page';        // Show's the word Page on the buttom of
                                       // each page.


type
  TFrmVSPrintCard = class(TFrmVSPreview)
    StBrCdEmp: TStBarCode;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FStrLstSelIdt  : TStringList;      // Stringlist selected Idt's
  protected
    { Protected declarations }
    FIdtEmployee   : string;
  published
    procedure PrintPageNumbers; virtual;
    property StrLstSelIdt : TStringList read  FStrLstSelIdt write FStrLstSelIdt;
  public
    { Public declarations }
    CurrentPosY : OleVariant;
    procedure PrintEmployeeCards; virtual;
    Procedure PrintCard(IdtEmployee: string); virtual;
    procedure CreateBarCode; virtual;
    procedure DestroyBarCode; virtual;
 
    property IdtEmployee: string read FIdtEmployee write FIdtEmployee;
  end;

var
  FrmVSPrintCard: TFrmVSPrintCard;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SmUtils,
  ActiveX,
  AxCtrls,
  DFpnEmployee,
  sfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FrmVSPrintCard';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSPrintCard.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2009/09/28 15:32:01 $';
  CtTxtSrcTag     = '$Name:  $';

//=============================================================================

procedure TFrmVSPrintCard.CreateBarCode;
var
  strFilePath      : string;           // pathname for barcode
begin  // of TFrmVSPrintCard.CreateBarCode
  StBrCdEmp.Code := DmdFpnEmployee.CalcNumCard(IdtEmployee);
  strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBarCode;
  StBrCdEmp.SaveToFile(strFilePath);
end; // of TFrmVSPrintCard.CreateBarCode

//=============================================================================

procedure TFrmVSPrintCard.DestroyBarCode;
var
  strFilePath      : string;           // pathname for barcode
begin  // of TFrmVSPrintCard.DestroyBarCode
  strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBarCode;
  if FileExists (strFilePath) then
     DeleteFile(strFilePath);
end; // of TFrmVSPrintCard.DestroyBarCode

//=============================================================================

procedure TFrmVSPrintCard.PrintCard(IdtEmployee: string);
var
  strFilePath      : string;
  PicLogo          : TPicture;         // Logo to be printed
  OlePicLogo       : IPictureDisp;     // Logo picture in OLE format
  TxtName          : string;
  TxtSurname       : string;
begin // of TFrmVSPrintCard.PrintCard
  TxtName    := '';
  TxtSurname := '';
  try
    DmdFpnEmployee.QryDetEmployee.Close;
    DmdFpnEmployee.QryDetEmployee.Params[0].Clear;
    DmdFpnEmployee.QryDetEmployee.Params[0].AsInteger := StrToInt(IdtEmployee);
    DmdFpnEmployee.QryDetEmployee.Open;
    if not DmdFpnEmployee.QryDetEmployee.Eof then begin
      TxtName := DmdFpnEmployee.QryDetEmployee.FieldByName('TxtFirstName').AsString;
      TxtSurName := DmdFpnEmployee.QryDetEmployee.FieldByName('TxtLastName').AsString;
    end;
  finally
    DmdFpnEmployee.QryDetEmployee.Close;
  end;
  VspPreview.BrushStyle := bsTransparent;
  // Logo
  strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\Image\' +
                  CtTxtLogoName;
  PicLogo := TPicture.Create;
  if FileExists (strFilePath) then begin
    PicLogo.LoadFromFile(ReplaceEnvVar(strFilePath));
    GetOlePicture (PicLogo, OlePicLogo);
    VspPreview.CalcPicture := OlePicLogo;
    VspPreview.DrawPicture (OlePicLogo,
                            CtPosXLogo,
                            CurrentPosY + CtPosYLogo,
                            '100%', '100%', '', False);
  end;
  // Barcode
  strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBarCode;
  if FileExists (strFilePath) then begin
    PicLogo.LoadFromFile(ReplaceEnvVar(strFilePath));
    GetOlePicture (PicLogo, OlePicLogo);
    VspPreview.CalcPicture := OlePicLogo;
    VspPreview.DrawPicture (OlePicLogo,
                            CtPosXBarCode, CurrentPosY + CtPosYBarCode,
                            '100%', '100%', '', False);
  end;
  VspPreview.DrawRectangle(CtPosXBarCode, CurrentPosY  + CtPosYCard,
    CtPosXCard + CtWidthCard, CurrentPosY  + CtPosYCard + CtHeightBarCode, 10, 10);
  //Employee number
  VspPreview.CurrentX := CtPosXEmpNum;
  VspPreview.CurrentY := CurrentPosY  + CtPosYEmpNum - 200;
  VspPreview.Text := CtTxtEmployeeNumber;
  VspPreview.CurrentX := CtPosXEmpNum + 100;
  VspPreview.CurrentY := CurrentPosY  + CtPosYEmpNum + 60;
  VspPreview.Text := IdtEmployee;
  VspPreview.DrawRectangle(CtPosXEmpNum, CurrentPosY  + CtPosYEmpNum,
    CtPosXEmpNum + CtWidthEmpNum, CurrentPosY  + CtPosYEmpNum +
    CtHeightEmpNum, 10, 10);
  //Name
  VspPreview.CurrentX := CtPosXName;
  VspPreview.CurrentY := CurrentPosY  + CtPosYName - 200;
  VspPreview.Text := CtTxtName;
  VspPreview.CurrentX := CtPosXName + 100;
  VspPreview.CurrentY := CurrentPosY  + CtPosYName + 60;
  VspPreview.Text := TxtName;
  VspPreview.DrawRectangle(CtPosXName, CurrentPosY  + CtPosYName, CtPosXName +
    CtWidthName, CurrentPosY  + CtPosYName + CtHeightName, 10, 10);
  //Surname
  VspPreview.CurrentX := CtPosXSurName;
  VspPreview.CurrentY := CurrentPosY  + CtPosYSurName - 200;
  VspPreview.Text := CtTxtSurname;
  VspPreview.CurrentX := CtPosXSurName + 100;
  VspPreview.CurrentY := CurrentPosY  + CtPosYSurName + 60;
  VspPreview.Text := TxtSurname;
  VspPreview.DrawRectangle(CtPosXSurName, CurrentPosY  + CtPosYSurName,
    CtPosXSurName + CtWidthSurName, CurrentPosY  + CtPosYSurName +
    CtHeightSurName, 10, 10);
  //Position
  VspPreview.CurrentX := CtPosXPosition;
  VspPreview.CurrentY := CurrentPosY  + CtPosYPosition - 200;
  VspPreview.Text := CtTxtPosition;
  VspPreview.DrawRectangle(CtPosXPosition, CurrentPosY  + CtPosYPosition,
    CtPosXPosition + CtWidthPosition, CurrentPosY  + CtPosYPosition +
    CtHeightPosition, 10, 10);
  VspPreview.PenStyle := PsDot;
  VspPreview.DrawLine(CtPosXPosition + 100, CurrentPosY  + CtPosYPosition + 300,
    CtPosXPosition + CtWidthPosition - 100, CurrentPosY  + CtPosYPosition + 300);
  VspPreview.PenStyle := PsSolid;
  //Photo
  VspPreview.DrawRectangle(CtPosXPhoto, CurrentPosY  + CtPosYPhoto, CtPosXCard +
    CtWidthCard, CurrentPosY + CtHeigthCard, 10, 10);
  //Kaart
  VspPreview.DrawRectangle(CtPosXCard , CurrentPosY + CtPosYCard, CtPosXCard +
    CtWidthCard, CurrentPosY + CtHeigthCard, 10,10);
end; // of TFrmVSPrintCard.PrintCard

//=============================================================================

procedure TFrmVSPrintCard.PrintEmployeeCards;
var
  idx      : Integer;
  CntCards : Integer;
begin // of TFrmVSPrintCard.PrintEmployeeCards
  CntCards := 0;
  CurrentPosY := VspPreview.CurrentY;
  for idx:=0 to StrLstSelIdt.Count - 1 do begin
    if CntCards = 4 then begin
      CntCards := 0;
      VspPreview.NewPage;
      CurrentPosY := VspPreview.CurrentY;
    end;
    IdtEmployee := StrLstSelIdt.Strings[idx];
    CreateBarcode;
    PrintCard(IdtEmployee);
    CntCards := CntCards + 1;
    CurrentPosY := CurrentPosY + 3500;
    DestroyBarcode;
  end;
end; // of TFrmVSPrintCard.PrintEmployeeCards

//=============================================================================

procedure TFrmVSPrintCard.FormCreate(Sender: TObject);
begin // of TFrmVSPrintCard.FormCreate
  inherited;
  StrLstSelIdt := TStringList.Create;
end; // of TFrmVSPrintCard.FormCreate

//=============================================================================

procedure TFrmVSPrintCard.FormActivate(Sender: TObject);
begin // of TFrmVSPrintCard.FormActivate
  VspPreview.Orientation := orPortrait;
  VspPreview.StartDoc;
  PrintEmployeeCards;
  VspPreview.EndDoc;
  inherited;
end; // of TFrmVSPrintCard.FormActivate

//=============================================================================

procedure TFrmVSPrintCard.PrintPageNumbers;
var
  CntPageNb        : Integer;          // Temp Pagenumber
begin // of TFrmVSPrintCard.PrintPageNumbers
  for CntPageNb := 1 to VspPreview.PageCount do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, TRUE);
      CurrentX := VspPreview.PageWidth - VspPreview.MarginRight - 1000;
      CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom + 350;
      Text := CtTxtPage + ' ' + IntToStr (CntPageNb) + '/' +
                                IntToStr (VspPreview.PageCount);
      EndOverlay;
    end;
  end;
end; // of TFrmVSPrintCard.PrintPageNumbers

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate, CtTxtSrcTag);

end.
