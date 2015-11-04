//=== Copyright 2008 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet : Development for Castorama
// Unit   : FSrvUDPPOSToPrisma = Form Service for UDP messages from POS TO
//                               PRISMA server
//-----------------------------------------------------------------------------
// PVCS   :  $
// History:
//=============================================================================

unit FSrvUDPPOSToPrisma;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  ScEHdler,Forms;

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring // Error messages
  CtTxtErrOnStop        = 'Occurs when service stops';
  CtTxtErrOnStart       = 'Occurs when service starts';
  CtTxtErrOnExecute     = 'Occurs when service executes';

  CtTxtInvalidPrefix = 'Prefix specified not valid';
  CtTxtInvalidMode = 'Mode specified not valid';
  CtTxtInvalidIP = 'IP adress specified not valid';
  CtTxtSocketError = 'A Socket Error has occured';
  CtTxtDeleteError = 'Cannot delete txt file';
  CtTxtMessageEmpty = 'No data found in file';

//*****************************************************************************
// Interface of TSrvUDPPOSToPrisma
//*****************************************************************************

type
  TSrvUDPPOSToPrisma = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceExecute(Sender: TService);
  private
    { Private declarations }
    ValSleepTime : integer;
    FLogging      : Boolean;     // Logging property
    FFilePath     : string;      // Path for the txt file
  protected
    { Protected declarations }
    FFlgDebugMode       : Boolean;     // Flag is set when in debugmode
  public
    { Public declarations }

    //Properties
    property FlgDebugMode: boolean read  FFlgDebugMode
                                   write FFlgDebugMode;
    property Logging      : boolean read FLogging
                                    write FLogging;
    property FilePath     : string read FFilePath
                                   write FFilePath;

    //Functions
    function GetServiceController: TServiceController; override;
    function GetSubstring(var TxtMessage : string): string;

    //Procedures
    procedure ExceptionHandler (Sender : TObject;
                                E      : Exception); virtual;
    procedure LoadIniConfig(txtFName: string);     // Load ini config file 
    procedure SendMessage(TxtMessage : string);
  end;

var
  SrvUDPPOSToPrisma: TSrvUDPPOSToPrisma;

//*****************************************************************************
//Funtions used of PSUKristal.dll
//*****************************************************************************

type

  String3 = string[3];
  String6 = string[6];
  String13 = string[13];
  String15 = string[15];
  String20 = string[20];
  String30 = string[30];

Function SendEventToUDP(Prefix      : String3;     // Object prefix
                       Number      : String6;      // Object number
                       Mode        : word;         // Event code
                       CassirItem  : String20;     // Cashier's code (tab. number)
                       Cassir      : String30;     // Cashier's name
                       CK_Number   : int64;        // Receipt number
                       Count       : word;         // Receipt position number
                       BarCode     : string13;     // Goods bar code
                       GoodsItem   : string30;     // Goods code
                       GoodsName   : string30;     // Goods name
                       GoodsPrice  : real;         // Goods price
                       GoodsQuant  : real;         // Goods quantity
                       GoodsSum    : real;         // Goods position amount
                       Sum         : real;         // Receipt amount
                       CardType    : string3;      // Card type (discount, credit)
                       CardNumber  : string20;     // Card number
                       DiscStr     : real;         // Discount on the line of receipt
                       DiscSum     : real;         // Receipt discount
                       ReceiverIP  : string15;     // Receiver IP
                       ReceiverPort: word = 21845; // Receiver port
                       DateTime    : Double = 0    // Date and time of event
                       ): integer; stdcall;

function SendEventToUDP; external 'PSUKristal.dll' name 'SendEventToUDP';

const
  KE_SUCCESS_SENDED     = 0;
  KE_INVALID_PREFIX     = 1;
  KE_INVALID_MODE       = 2;
  KE_INVALID_IP         = 3;
  KE_SOCKET_ERROR       = 4;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  IniFiles,
  SfDialog,
  SmFile,
  SmUtils,
  UFpsSyst;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FSrvUDPPOSToPrisma';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FSrvUDPPOSToPrisma.pas  $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2010/07/27 09:23:16 $';

//*****************************************************************************
// Implementation of not-interfaced routines
//*****************************************************************************

procedure ServiceController(CtrlCode: DWord); stdcall;
begin // of ServiceController
  SrvUDPPOSToPrisma.Controller(CtrlCode);
end;  // of ServiceController

//*****************************************************************************
// Implementation of TSrvUDPPOSToPrisma
//*****************************************************************************

function TSrvUDPPOSToPrisma.GetServiceController: TServiceController;
begin // of TSrvUDPPOSToPrisma.GetServiceController
  Result := ServiceController;
end;  // of TSrvUDPPOSToPrisma.GetServiceController

//=============================================================================

procedure TSrvUDPPOSToPrisma.ServiceCreate(Sender: TObject);
var
  CntParam         : Integer;         // Parameter index
begin  // of TSrvUDPPOSToPrisma.ServiceCreate
  SmUtils.ViFlgAutom := True;
  // To start in debug mode
  SfDialog.AddRunParams ('/DEBUG', 'To run from command prompt');
  for CntParam := 1 to System.ParamCount do begin
    if AnsiCompareText (Paramstr (CntParam),'/DEBUG') = 0 then begin
      FlgDebugMode := True;
      DoStart;
      Break;
    end;
  end;
end;   // of TSrvUDPPOSToPrisma.ServiceCreate

//=============================================================================

procedure TSrvUDPPOSToPrisma.ServiceStart(Sender: TService;
  var Started: Boolean);
begin  // of TSrvUDPPOSToPrisma.ServiceStart
  inherited;
  try
    ValSleeptime := 2500;
    if copy(ViTxtFNIniSystemFps,1,pos('\',ViTxtFNIniSystemFps)) = '\' then
          ViTxtFNIniSystemFps := copy(ExtractFilePath (ExtractFileDir (Application.ExeName)),1,2) + ViTxtFNIniSystemFps;
    LoadIniConfig(ViTxtFNIniSystemFps);
  except
    on E: Exception do begin
      E.message := E.message + #10 + CtTxtErrOnStart;
      ExceptionHandler(Sender, E);
    end;
  end;
end;   // of TSrvUDPPOSToPrisma.ServiceStart

//=============================================================================

procedure TSrvUDPPOSToPrisma.ServiceExecute(Sender: TService);
var
  ValSleep         : integer;          // Time to sleep
  TxtFileName      : string;
  FTxtFile         : TextFile;
  TxtMessage       : string;           // Message read from txt file
  FileFound        : TSearchrec;      
  TxtFilePath      : string;
  FlgFound         : integer;
  TxtFile          : string;

begin  // of TSrvUDPPOSToPrisma.ServiceExecute
  inherited;
  try
    while not Terminated do begin
      // Add code to read flat files and sent UDP message to Prisma server
      TxtFileName :=  'UDP*.txt';
      TxtFilePath := FilePath + TxtFileName;
      try
        FLgFound := FindFirst(TxtFilePath,faAnyFile,FileFound);
        while FlgFound = 0 do begin
          TxtFile := FilePath + FileFound.Name;
          FindClose(FileFound);
          try
            FtxOpen(TxtFile,FTxtFile);
            FtxRead(TxtFile,FTxtFile,TxtMessage);
            FtxClose(TxtFile,FTxtFile);
            SendMessage(TxtMessage);
          finally
            if not DeleteFile(TxtFile) then begin
             SvcExceptHandler.LogMessage (CtChrLogInfo,
             SvcExceptHandler.BuildLogMessage (CtNumInfoMin, [CtTxtDeleteError]));
            end;
            FLgFound := FindFirst(TxtFilePath,faAnyFile,FileFound);
          end;
        end;
      finally
        FindClose(FileFound);
      end;
      ValSleep := 0;
      while ValSleep < 2500 do begin
        Sleep(500);
        ServiceThread.ProcessRequests (False);
        ValSleep := ValSleep + 500;
      end;
    end;
  except
    on E: Exception do begin
      E.message := E.message + #10 + CtTxtErrOnExecute;
      ExceptionHandler(Sender, E);
    end;
  end;
end;   // of TSrvUDPPOSToPrisma.ServiceExecute

//=============================================================================

procedure TSrvUDPPOSToPrisma.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin  // of TSrvUDPPOSToPrisma.ServiceStop
  try
    Stopped := True;
  except
    on E: Exception do begin
      E.message := E.message + #10 + CtTxtErrOnStop;
      ExceptionHandler(Sender, E);
    end;
  end;
end;   // of TSrvUDPPOSToPrisma.ServiceStop

//=============================================================================
// TSrvUDPPOSToPrisma.ExceptionHandler : Procedure called to log exception
//                                  -----
// INPUT  : Sender = The sender that has raised the error
//          E = The exception that occurred
//=============================================================================

procedure TSrvUDPPOSToPrisma.ExceptionHandler (Sender : TObject;
                                             E      : Exception);
begin  // of TSrvUDPPOSToPrisma.ExceptionHandler
  SvcExceptHandler.LogMessage (CtChrLogError,
  SvcExceptHandler.BuildLogMessage (CtNumErrorMin, [E.Message]));
end;   // of TSrvUDPPOSToPrisma.ExceptionHandler

//=============================================================================

procedure TSrvUDPPOSToPrisma.LoadIniConfig(txtFName: string);
var
  IniFile : TIniFile;
begin // of TSrvUDPPOSToPrisma.LoadIniConfig
  IniFile := TIniFile.Create (txtFName);
  Logging := GetBoolDef (IniFile.ReadString ('PrismaUDP','Logging','False'),
             'T', False);
  FilePath := IniFile.ReadString ('PrismaUDP','FilePath','?');
  if (FilePath = '?') then
    raise Exception.Create ('UDP : FilePath value not found in configuration file.')
  else begin
    // Add servername to FilePath
    if Pos(':\', FilePath) <= 0 then
      FilePath := copy(ExtractFilePath (ExtractFileDir (Application.ExeName)),1,2) + '\Sycron' + FilePath;
  end;
end; // of TSrvUDPPOSToPrisma.LoadIniConfig

//=============================================================================

procedure TSrvUDPPOSToPrisma.SendMessage(txtMessage: string);
var
  Prefix           : string;      // Prefix field
  Number           : string;      // Cashdesk id field
  Mode             : integer;     // Even code field
  CassirItem       : string;      // Operator id field
  Cassir           : string;      // Operator name field
  CK_number        : integer;     // PostTransaction id field
  Count            : integer;     // Receipt position number field
  BarCode          : string;      // Goods barcode field
  GoodsItem        : string;      // Goods id code field
  GoodsName        : string;      // Goods name field
  GoodsPrice       : double;      // Goods price field
  GoodsQuant       : double;      // Goods Quantity field
  GoodsSum         : double;      // Goods position amount field
  Sum              : double;      // Receipt amount field
  CardType         : string;      // Card type field
  CardNumber       : string;      // Card number field
  DiscStr          : double;      // Discount on current line of receipt field
  DiscSum          : double;      // receipt discount field
  ReceiverIP       : string;      // Receiver IP-address of packet field
  ReceiverPort     : integer;     // Receiver port of packet field
  DateTime         : TDateTime;   // date and time of event field
  ErrorCode        : integer;     // Possible errorcode returned from DLL function

begin // of TSrvUDPPOSToPrisma.SendMessage
  if Length(txtmessage) <> 0 then begin
    Prefix := GetSubstring(Txtmessage);
    Number := GetSubstring(Txtmessage);
    Mode := StrToIntdef(GetSubstring(Txtmessage),0);
    CassirItem := GetSubstring(Txtmessage);
    Cassir := GetSubstring(Txtmessage);
    CK_number := StrToIntdef(GetSubstring(Txtmessage),0);
    Count := StrToIntdef(GetSubstring(Txtmessage),0);
    BarCode := GetSubstring(Txtmessage);
    GoodsItem := GetSubstring(Txtmessage);
    GoodsName := GetSubstring(Txtmessage);
    GoodsPrice := Strtofloat(GetSubstring(Txtmessage));
    GoodsQuant := Strtofloat(GetSubstring(Txtmessage));
    GoodsSum := Strtofloat(GetSubstring(Txtmessage));
    Sum := Strtofloat(GetSubstring(Txtmessage));
    CardType := GetSubstring(Txtmessage);
    CardNumber := GetSubstring(Txtmessage);
    DiscStr := Strtofloat(GetSubstring(Txtmessage));
    DiscSum := Strtofloat(GetSubstring(Txtmessage));
    ReceiverIP := GetSubstring(Txtmessage);
    ReceiverPort := strtointdef(GetSubstring(Txtmessage),0);
    DateTime := StrToDateTimedef (Txtmessage, 'yyyy-mm-dd', 'hh:mm:ss',0);
    ErrorCode := SendEventToUDP(prefix,number,mode,cassirItem,Cassir,CK_number,Count,Barcode,
                              GoodsItem,GoodsName,GoodsPrice,GoodsQuant,GoodsSum,Sum,CardType,
                              CardNumber,DiscSTr,DiscSum,ReceiverIP,ReceiverPort,DateTime);
    if ErrorCode <> 0 then begin
       case Errorcode of
         KE_INVALID_PREFIX :  begin
           SvcExceptHandler.LogMessage (CtChrLogInfo,
           SvcExceptHandler.BuildLogMessage (CtNumInfoMin, [CtTxtInvalidPrefix + #10 + CtTxtErrOnExecute]));
         end;
         KE_INVALID_MODE   :  begin
           SvcExceptHandler.LogMessage (CtChrLogInfo,
           SvcExceptHandler.BuildLogMessage (CtNumInfoMin, [CtTxtInvalidMode + #10 + CtTxtErrOnExecute]));
         end;
         KE_INVALID_IP     :  begin
           SvcExceptHandler.LogMessage (CtChrLogInfo,
           SvcExceptHandler.BuildLogMessage (CtNumInfoMin, [CtTxtInvalidIP + #10 + CtTxtErrOnExecute]));
         end;
         KE_SOCKET_ERROR   :  begin
           SvcExceptHandler.LogMessage (CtChrLogInfo,
           SvcExceptHandler.BuildLogMessage (CtNumInfoMin, [CtTxtSocketError + #10 + CtTxtErrOnExecute]));
         end;
       else
       end;
    end;
  end
  else begin
   SvcExceptHandler.LogMessage (CtChrLogInfo,
           SvcExceptHandler.BuildLogMessage (CtNumInfoMin, [CtTxtMessageEmpty + #10 + CtTxtErrOnExecute]));
  end

end; // of TSrvUDPPOSToPrisma.SendMessage

//=============================================================================

function TSrvUDPPOSToPrisma.GetSubstring(var TxtMessage : string) : string;
var
  BeginPosition       : integer;
  EndPosition         : integer;

begin // of TSrvUDPPOSToPrisma.GetSubstring
  Beginposition := 1;
  EndPosition := AnsiPos(';',TxtMessage);
  result := Copy(TxtMessage, Beginposition, EndPosition-1);
  Delete(TxtMessage,Beginposition,EndPosition)
end; // of TSrvUDPPOSToPrisma.GetSubstring

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end.  // of FSrvUDPPOSToPrisma
