//=== Copyright 2009 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet : Castorama Development
// Unit   : MLogging.PAS
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/MLogging.pas,v 1.2 2009/09/28 13:16:16 BEL\KDeconyn Exp $
//=============================================================================

unit MLogging;

//*****************************************************************************

interface

//=============================================================================
// MLoggings
//=============================================================================

  procedure LogDebugMessage (TxtMessage: string);

//=============================================================================
// Constants
//=============================================================================

const
  CtTxtDebugLogFailed : string = 'Logging of debug messages failed...';

//*****************************************************************************

implementation

uses
  ScEHdler,
  SysUtils;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'MLogging';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/MLogging.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2009/09/28 13:16:16 $';

//*****************************************************************************
// Implementation of MLogging
//*****************************************************************************

procedure LogDebugMessage (TxtMessage: string);
begin // of LogDebugMessage
  SvcExceptHandler.BuildAndLogMessage (1, TxtMessage);
end; // of LogDebugMessage

//=============================================================================

end.  // of MLogging
