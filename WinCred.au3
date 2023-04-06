#include-once

#include "WinCredConstants.au3"
#include <StructureConstants.au3>
#include <WinAPIError.au3>

; CREDENTIALW structure (https://learn.microsoft.com/en-us/windows/win32/api/wincred/ns-wincred-credentialw)
Global Const $tagCREDENTIALW = _
		"struct;" & _
		"dword Flags;" & _
		"dword Type;" & _
		"ptr TargetName;" & _
		"ptr Comment;" & _
		$tagFILETIME & ";" & _
		"dword CredentialBlobSize;" & _
		"ptr CredentialBlob;" & _
		"dword Persist;" & _
		"dword AttributeCount;" & _
		"ptr Attributes;" & _
		"ptr TargetAlias;" & _
		"ptr UserName;" & _
		"endstruct"

; #FUNCTION# ====================================================================================================================
; Name ..........: _WinCred_CredRead
; Description ...: Reads a credential from the user's credential set.
; Syntax ........: _WinCred_CredRead(Const Byref $sTargetName, Const Byref $iType)
; Parameters ....: $sTargetName         - Name of the credential to read.
;                  $iType               - Type of the credential to read. Type must be one of the $CRED_TYPE_* defined types.
; Return values .: Success              - True, if found credential
;                  Failure              - False, if not found credential
; Author ........: Domenic Laritz
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: https://learn.microsoft.com/en-us/windows/win32/api/wincred/nf-wincred-credreadw
; Example .......: No
; ===============================================================================================================================
Func _WinCred_CredRead(Const ByRef $sTargetName, Const ByRef $iType)
	Local $aResult = 0
	Local $tCREDENTIALW = 0

	$aResult = DllCall('Advapi32.dll', 'bool', 'CredReadW', 'wstr', $sTargetName, 'dword', $iType, 'dword', 0, 'ptr*', 0)
	If @error Then
		ConsoleWrite("DllCall: @error = " & @error & @CRLF)
		Exit
	EndIf
	$tCREDENTIALW = DllStructCreate($tagCREDENTIALW, $aResult[4])
	If @error Then
		ConsoleWrite("DllStructCreate (1): @error = " & @error & @CRLF)
		Exit
	EndIf
	Local $tUSERNAME = DllStructCreate("wchar[100]", DllStructGetData($tCREDENTIALW, "UserName"))
	If @error Then
		ConsoleWrite("DllStructCreate (2): @error = " & @error & @CRLF)
		Exit
	EndIf
	ConsoleWrite(DllStructGetData($tCREDENTIALW, "Type") & @CRLF)
	ConsoleWrite(DllStructGetData($tUSERNAME, 1) & @CRLF)
EndFunc   ;==>_WinCred_CredRead
