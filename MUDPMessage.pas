//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : Flexpoint
// Unit     : MUDPMessage
//            Module contains UDP Message formatting
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/MUDPMessage.pas,v 1.4 2009/09/23 10:08:59 BEL\KDeconyn Exp $
// History :
// - Started from Castorama - Flexpoint 2.0 - MUDPMessage - CVS revision 1.49
// Version  ModifiedBy    Reason
// 1.50     TK   (TCS)    R2013.2.Req32010.CARU.Sales-Receipt
//=============================================================================

unit MUDPMessage;

//*****************************************************************************

interface

uses
  Classes, Filer, Operator, Windows;

//*****************************************************************************
// Global definitions
//*****************************************************************************

const
  CtPrefix = 'CDM';                       // Prefix of UDP message
  CtCodStartIdent             = 1;        // Start identification in PSales
  CtCodWrongIdent             = 2;        // Wrong identification or password
  CtCodLogIn                  = 3;        // Log-in successful
  CtCodFirstEvent             = 4;        // First event ready state
  CtCodXMLSent                = 5;        // XML receipt is sent to server
  CtCodArtAdded               = 6;        // Article was added
  CtCodCheckSecLevel          = 7;        // Check security level for action
  CtCodSecLevelLow            = 8;        // Security level to low for action
  CtCodCancArt                = 9;        // Items are removed from the ticket
  CtCodQtyChanged             = 12;       // Quantity changed
  CtCodPriceCorr              = 13;       // Price correction
  CtCodPriceCorrNOK           = 14;       // Price correction failed
  CtCodPriceCorrOK            = 15;       // Price correction succeeded
  CtCodCancLine               = 16;       // Cancel (last) line
  CtCodCancLineNOK            = 17;       // Cancel (last) line failed
  CtCodCancLineOK             = 18;       // Cancel (last) line succeeded
  CtCodDiscount               = 19;       // Discount % or amount
  CtCodDiscountNOK            = 20;       // Discount % or amount failed
  CtCodDiscountInput          = 21;       // Discount % or amount entered
  CtCodDiscountOK             = 22;       // Discount % or amount succeeded
  CtCodCancTicket             = 23;       // Cancel ticket
  CtCodCancTicketNOK          = 24;       // Cancel ticket failed
  CtCodCancTicketOK           = 25;       // Cancel ticket succeeded
  CtCodTotal                  = 26;       // Subtotal/Total was pressed
  CtCodCredCard               = 31;       // Credit card
  CtCodCredCardNOK            = 32;       // Credit failed
  CtCodDiscCard               = 35;       // Discount card
  CtCodDiscCardNOK            = 36;       // Discount card refused
  CtCodCash                   = 37;       // Payment in Cash
  CtCodNtCash                 = 38;       // Payment not in cash
  CtCodStartPrint             = 39;       // Start print of receipt
  CtCodDrawerOpen             = 40;       // Cash drawer open for payment
  CtCodPayOut                 = 41;       // Pay-out
  CtCodReturn                 = 46;       // Return of goods is started
  CtCodXMLRetSent             = 47;       // XML return receipt is sent to server
  CtCodDrawerOpenAutom        = 49;       // Cash drawer was opened automatically
  CtCodCashRet                = 50;       // Change money is given to the customer
  CtCodTotalDisc              = 52;       // Total amount of discount
  CtCodTickOnHold             = 55;       // Receipt is put on hold
  CtCodTickRecall             = 56;       // Recall of a ticket on hold
  CtCodSalesDoc               = 57;       // BV (Sales document) is scanned
  CtCodReprint                = 71;       // Reprint of last printed document
  CtCodPayIn                  = 77;       // Pay In operation is started
  CtCodSalesDocNum            = 80;       // BO doc number is supplied
  CtCodUnknownPLU             = 112;      // Unknown barcode
  CtCodTrainingAct            = 131;      // Training mode is activated
  CtCodTrainingDeact          = 132;      // Training mode is deactivated
  CtCodCount                  = 206;      // Final Count is launched
  CtCodXReport                = 209;      // X-report is printed
  CtCodZReport                = 210;      // Z-report is printed
  CtCodZReportDupl            = 217;      // Copy of Z-report is printed
  CtCodSalesReceipt           = 218;      // Print sales receipt from till      //R2013.2.Req32010.CARU.Sales-Receipt.TCS-TK

//=============================================================================
// TUDPMessage 
//=============================================================================

type
  TUDPMessage = class(Tobject)
  private
    FPrefix       : string;      // Prefix field
    FNumber       : string;      // Cashdesk id field
    FMode         : integer;     // Even code field
    FCassirItem   : string;      // Operator id field
    FCassir       : string;      // Operator name field
    FCK_number    : string;      // PostTransaction id field
    FCount        : string;      // Receipt position number field
    FBarCode      : string;      // Goods barcode field
    FGoodsItem    : string;      // Goods id code field
    FGoodsName    : string;      // Goods name field
    FGoodsPrice   : string;      // Goods price field
    FGoodsQuant   : string;      // Goods Quantity field
    FGoodsSum     : string;      // Goods position amount field
    FSum          : string;      // Receipt amount field
    FCardType     : string;      // Card type field
    FCardNumber   : string;      // Card number field
    FDiscStr      : string;      // Discount on current line of receipt field
    FDiscSum      : string;      // receipt discount field
    FReceiverIP   : string;      // Receiver IP-address of packet field
    FReceiverPort : string;      // Receiver port of packet field
    FDateTime     : string;      // date and time of event field
    FActive       : Boolean;     // Active property
    FLogging      : Boolean;     // Logging property
    FFilePath     : string;      // Path for the txt file
    FFlgCounter   : boolean;     // Flag for receipt position number counter
    FCounter      : integer;     // Counter for receipt position number
    //  Properties
    property Prefix       : string read FPrefix write FPrefix;
    property Number       : string read FNumber write FNumber;
    property CassirItem   : string read FCassirItem write FCassirItem;
    property Cassir       : string read FCassir write FCassir;
    property CK_number    : string read FCK_number write FCK_number;
    property Count        : string read FCount write FCount;
    property BarCode      : string read FBarCode write FBarCode;
    property GoodsItem    : string read FGoodsItem write FGoodsItem;
    property GoodsName    : string read FGoodsName write FGoodsName;
    property GoodsPrice   : string read FGoodsPrice write FGoodsPrice;
    property GoodsQuant   : string read FGoodsQuant write FGoodsQuant;
    property GoodsSum     : string read FGoodsSum write FGoodsSum;
    property CardType     : string read FCardType write FCardType;
    property CardNumber   : string read FCardNumber write FCardNumber;
    property DiscStr      : string read FDiscStr write FDiscStr;
    property ReceiverIP   : string read FReceiverIP write FReceiverIP;
    property ReceiverPort : string read FReceiverPort write FReceiverPort;
    property DateTime     : string read FDateTime write FDateTime;
    property Logging      : boolean read FLogging write FLogging;
    property FilePath     : string read FFilePath write FFilePath;
    property FlgCounter   : boolean read FFlgCounter write FFlgCounter;
    property Counter      : integer read FCounter write FCounter;
  public
    constructor Create;                            // Create object
    destructor Destroy; override;                  // Destroy obejct
    // Methods
    procedure Clear;
    procedure LoadIniConfig(txtFName : string);    // Load ini config file
    procedure LogData(txtData: string);            // Log messages
    procedure CreateTxtFile(TxtMessage : string);  // Create Txt File
    procedure GetOperatorName(IdtOperator : string); //lookup operator name
    procedure Add(IdtCashdesk : integer; IntMode : integer
                 ;IdtOperator: string = '';IdtPostransaction : integer  = 0
                 ;TxtBarcode : string  = '';IdtGoods : integer  = 0
                 ;TxtGoods : string  = '';prmGoodsPrice : double  = 0.00
                 ;prmGoodsQuant : double  = 0.00;prmGoodsSum : double  = 0.00
                 ;prmSum : double  = 0.00;TxtCardnumber : string  = ''
                 ;prmdisc : double  = 0.00;prmdiscSum : double  = 0.00);
    //Functions
    function CreateMessage : string;

    //  Properties
    property Mode         : integer read FMode write FMode;
    property Sum          : string read FSum write FSum;
    property DiscSum      : string read FDiscSum write FDiscSum;
    property Active       : boolean read FActive write FActive;

  end; // of TUDPMessage

var
   FlgActFailed : Boolean;
   
//*****************************************************************************

implementation

uses
  IniFiles,
  SysUtils,
  UFpsSyst,
  SfDialog,
  SmFile,
  SmFiler;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'MUDPMessage';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:$';
  CtTxtSrcVersion = '$Revision: 1.4 $';
  CtTxtSrcDate    = '$Date: 2009/09/23 10:08:59 $';

//*****************************************************************************
// Implementation of TUDPMessage
//*****************************************************************************

constructor TUDPMessage.Create;
begin // of TUDPMessage.Create
  Clear;
  LoadIniConfig(ViTxtFNIniSystemFps);
  if Active then begin
    if not Assigned(FOperator) then
      FbtOpen (CIFNOperator, FOperator, SizeOf (TOperator));
    FbtClearKey (CIFNOperator, FOperator, 1);
  end;
end; // of TUDPMessage.Create

//=============================================================================

destructor TUDPMessage.Destroy;
begin // of TUDPMessage.Destroy
  try
    if Assigned (FOperator) then
      FbtClose (CIFNOperator, FOperator);
  except
  end;
  Self.Clear;
  inherited;
end; // of TUDPMessage.Destroy

//=============================================================================

procedure TUDPMessage.Clear;
begin // of TUDPMessage.Clear
  Number       := '';
  Mode         := 0;
  ReceiverIP   := '';
  ReceiverPort := '';
  FlgCounter   := False;
end; // of TUDPMessage.Clear

//=============================================================================

procedure TUDPMessage.Add(IdtCashdesk : integer; IntMode : integer
                          ;IdtOperator: string = '';IdtPostransaction : integer = 0
                          ;TxtBarcode : string = '';IdtGoods : integer = 0
                          ;TxtGoods : string = '';prmGoodsPrice : double = 0.00
                          ;prmGoodsQuant : double = 0.00;prmGoodsSum : double = 0.00
                          ;prmSum : double = 0.00;TxtCardnumber : string = ''
                          ;prmdisc : double = 0.00;prmdiscSum : double = 0.00);
var
  TxtMessage  : string;  //variable containing message for txt file

begin  // of TUDPMessage.Add

  //only make txtfile when active
  if Active then
  begin
    FlgActFailed := False;
    Number     := IntToStr(IdtCashdesk);
    Mode       := IntMode;
    GetOperatorName(IdtOperator);
    CK_number  := IntToStr(IdtPosTransaction);
    //set counterflag if event happens
    if IntMode in [CtCodFirstEvent,CtCodTickRecall] then begin
      FlgCounter := True;
      Counter := 0;
    end;
    //reset counter when end event
    if FlgCounter then
    begin
      Counter := Counter + 1;
      if IntMode in [CtCodXMLSent, CtCodXMLRetSent, CtCodTickOnHold] then
        FlgCounter := False;
    end;
    Count      := IntToStr(Counter);
    if not FlgCounter then
     Counter := 0;
    BarCode    := TxtBarcode;
    GoodsItem  := IntToStr(IdtGoods);
    GoodsName  := TxtGoods;
    GoodsPrice := FormatFloat('0.00', prmGoodsPrice);
    GoodsQuant := FormatFloat('0.00', prmGoodsQuant);
    GoodsSum   := FormatFloat('0.00', prmGoodsSum);
    Sum        := FormatFloat('0.00', prmSum);
    CardType   := '0';
    CardNumber := TxtCardNumber;
    DiscStr    := FormatFloat('0.00',prmDisc);
    DiscSum    := FormatFloat('0.00',prmdiscSum);
    Datetime   := FormatDateTime('yyyy-mm-dd hh:nn:ss',Now());
    TxtMessage := CreateMessage;
    CreateTxTFile (TxtMessage);
  end;
end;  // of TUDPMessage.Add

//=============================================================================

procedure TUDPMessage.LoadIniConfig(txtFName: string);
var
  IniFile : TIniFile;
begin // of TUDPMessage.LoadIniConfig
  try
    IniFile := TIniFile.Create (txtFName);
    Logging := GetBoolDef (IniFile.ReadString ('PrismaUDP','Logging','False'),
               'T', False);
    //PrismaUDP active ?
    Active := GetBoolDef (IniFile.ReadString ('PrismaUDP','Active','False'),
               'T', False);
    if Active then
    begin
      Prefix := IniFile.ReadString ('PrismaUDP','Prefix','?');
      if (FPrefix = '?') then
        LogData ('UDP : Prefix value not found in config file.');
      ReceiverIP := IniFile.ReadString ('PrismaUDP','ReceiverIP','?');
      if (FReceiverIP = '?') then
        LogData ('UDP : ReceiverIP value not found in config file.');
      ReceiverPort := IniFile.ReadString ('PrismaUDP','ReceiverPort','?');
      if (FReceiverPort = '?') then
        LogData ('UDP : ReceiverPort value not found in config file.');
      FilePath := IniFile.ReadString ('PrismaUDP','FilePath','?');
      if (FFilePath = '?') then
        LogData ('UDP : FilePath value not found in config file.')
      else begin
        // Add servername to FilePath
        if Pos(':\', FilePath) <= 0 then
          FilePath := AddServerPathToFN (FilePath);

        // check if directory exists and create if neccessary
        if not DirectoryExists(FilePath) then
          ForceDirectories(FilePath);
      end
    end;

  except
    //Error Loading Ini file ?
    On E: Exception do
      LogData ('TUDPMessage.LoadIniConfig : ' + E.Message);
  end;
end; // of TUDPMessage.LoadIniConfig

//=============================================================================

procedure TUDPMessage.LogData(txtData: string);
begin // of TUDPMessage.LogData
  if Logging then
    LogMessage ('E', txtData, 100);
end; // of TUDPMessage.LogData

//=============================================================================

procedure TUDPMessage.CreateTxtFile(TxtMessage : string);
var
  TxtFileName    :  string;
  FTxtFile       :  TextFile;
  TxtDate        :  string;
  TxtCounter     :  Integer;
  TxtFileNameNew    :  string;

begin // of TUDPMessage.CreateUDPFile
  try
    TxtDate := FormatDateTime('YYYYMMDD',now());
    TxtCounter := 1;
    TxtFileName :=  FFilePath + TxtDate + format('%5.5d',[TxtCounter]) + '.txt';
    TxtFileNameNew :=  FFilePath + 'UDP'+ TxtDate + format('%5.5d',[TxtCounter]) + '.txt';
    //Check if File doesn't exist yet
    while FileExists(TxtFileNameNew) do begin
      // changefile name
      TxtCounter := TxtCounter + 1;
      TxtFileName :=  FFilePath + TxtDate + format('%5.5d',[TxtCounter]) + '.txt';
      TxtFileNameNew :=  FFilePath + 'UDP'+ TxtDate + format('%5.5d',[TxtCounter]) + '.txt';
    end;
    FtxCreate(TxtFileName,FTxtFile);
    FtxWrite(TxtFileName,FTxtFile,TxtMessage);
    FtxFlush(TxtFileName,FTxtFile);
  finally
   FtxClose(TxtFileName,FTxtFile); 
   RenameFile(TxtFileName,TxtFileNameNew);
   DeleteFile(TxtFileName);

  end;
end; // of TUDPMessage.CreateUDPFile

//=============================================================================

function TUDPMessage.CreateMessage : string;
var
  Txtsep : string;
begin  // of TUDPMessage.CreateMessage
  Txtsep := ';';
  Result := Prefix + Txtsep + Number + Txtsep + IntToStr(Mode) + Txtsep + CassirItem
            + Txtsep + Cassir + Txtsep + CK_number + Txtsep + Count + Txtsep
            + BarCode + Txtsep + GoodsItem + Txtsep + GoodsName + Txtsep
            + GoodsPrice + Txtsep + GoodsQuant + Txtsep + GoodsSum + Txtsep
            + Sum + Txtsep + CardType + Txtsep + CardNumber + Txtsep
            + DiscStr + Txtsep + DiscSum + Txtsep + ReceiverIP + Txtsep
            + ReceiverPort + Txtsep + Datetime;
end;  // of TUDPMessage.CreateMessage

//=============================================================================

procedure TUDPMessage.GetOperatorName(IdtOperator : string);
  var
  LeesRecNr        : LongInt;          // Te lezen recordnummer operator
  LeesOper         : TOperator;        // Leeszone record operator
  TxtKey           : IsamKeyStr;       // var-parameter for getting operator
begin
  Cassir := '';
  CassirItem := '';
  if IdtOperator <> '' then begin
    try
      // Inlezen gevraagde operator
      LeesOper.IdentKaart := IdtOperator;
      if Operator.FindAndGetRec (CIFNOperator, FOperator, 3, LeesRecNr,
                               TxtKey, LeesOper, [sfbLockRec],
                               Operator.MaakSleutel) then
        Cassir :=  LeesOper.Naam;
        CassirItem := FormatFloat('000',LeesOper.NrOperator);
    except
      on E:Exception do
        LogData ('UDP : Operator name not found in database.');
    end;
  end;
end;

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of MUDPMessage
