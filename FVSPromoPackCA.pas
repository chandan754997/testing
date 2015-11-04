unit FVSPromoPackCA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfVSPrinter7, ActnList, ImgList, Menus, ExtCtrls, Buttons, OleCtrls,
  SmVSPrinter7Lib_TLB, ComCtrls, StBarC;

const
  CtTxtBarCode     = 'barcode.bmp';    // bitmap image of the barcode

type
  TFrmVSPromoPackCA = class(TFrmVSPreview)
    StBrCdPromopack: TStBarCode;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    BrcdPromopack            : string;     // Barcode promopack
    FIdtPromopack            : string;     // Promopack number
    FTxtDescrPromopack       : string;     // Description promopack
  published
    { Published declarations }
    property IdtPromoPack : string  read FIdtPromopack
                                       write FIdtPromopack;
    property BarcodePromoPack : string  read BrcdPromopack
                                       write BrcdPromopack;
    property TxtDescrPromoPack : string  read FTxtDescrPromopack
                                        write FTxtDescrPromopack;
    procedure PrintReport; virtual;
  public
    { Public declarations }
    procedure CreateBarCode; virtual;
    procedure DestroyBarCode; virtual;
  end;

var
  FrmVSPromoPackCA: TFrmVSPromoPackCA;

implementation

{$R *.dfm}

uses
  smutils,
  ActiveX,
  AXCtrls,
  SfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSPromoPackCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSPromoPackCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2008/02/21 15:52:30 $';

//=============================================================================



procedure TFrmVSPromoPackCA.DestroyBarCode;
var
  strFilePath      : string;           // pathname for barcode
begin
  strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBarCode;
  if FileExists (strFilePath) then
     DeleteFile(strFilePath);
end;

procedure TFrmVSPromoPackCA.CreateBarCode;
var
  strFilePath      : string;           // pathname for barcode
begin
  StBrCdPromopack.Code := BrcdPromopack;
  strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBarCode;
  StBrCdPromopack.SaveToFile(strFilePath);
end;

procedure TFrmVSPromoPackCA.FormActivate(Sender: TObject);
begin
  inherited;
  VspPreview.Orientation := orPortrait;
  VspPreview.StartDoc;
  StBrCdPromopack.Font.Size := 10;
  CreateBarCode;
  PrintReport;
  DestroyBarCode;
  VspPreview.EndDoc;
end;

procedure TFrmVSPromoPackCA.PrintReport;
var
  strFilePath      : string;           // pathname for logo
  PicLogo          : TPicture;         // Logo to be printed
  OlePicLogo       : IPictureDisp;     // Logo picture in OLE format
  //varPicWidth      : Real;             // Width of pic in twips
  //varPicHeight     : Real;             // Heigth of pic in twips
begin
  // IdtPromoPack
  VspPreview.FontSize := 12;
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.CurrentY := VspPreview.MarginTop + 500;
  VspPreview.Text := Trim(IdtPromoPack);
  // Description
  VspPreview.CurrentX := VspPreview.MarginLeft;
  VspPreview.CurrentY := VspPreview.CurrentY + 500;
  VspPreview.Text := TxtDescrPromoPack;
  VspPreview.FontSize := 10;
  // Barcode
  PicLogo := TPicture.Create;
  try
    strFilePath := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\' + CtTxtBarCode;
    VspPreview.CurrentY := VspPreview.CurrentY + 500;
    if FileExists (strFilePath) then begin
      PicLogo.LoadFromFile(ReplaceEnvVar(strFilePath));
      GetOlePicture (PicLogo, OlePicLogo);
      VspPreview.CalcPicture := OlePicLogo;
      //varPicWidth := PicLogo.Width/Screen.PixelsPerInch*1440;
      //varPicHeight := PicLogo.Height/Screen.PixelsPerInch*1440;
      VspPreview.DrawPicture (OlePicLogo,
                              VspPreview.MarginLeft, VspPreview.CurrentY, '100%', '100%',
                              '', False);
    end;
  finally
    PicLogo.Destroy;
  end;
end;

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end.
