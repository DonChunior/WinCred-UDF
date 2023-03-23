#include-once

#include "WinCredConstants.au3"
#include <WinAPIError.au3>

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

	$aResult = DllCall('Advapi32.dll', 'bool', 'CredReadW', 'wstr', $sTargetName, 'dword', $iType, 'dword', 0, 'ptr*', 0)
	If @error Then Return SetError(2, 0, 0)

	If $aResult[0] Then
		Return SetError(0, 0, True)
	Else
		Return SetError(1, _WinAPI_GetLastError(), False)
	EndIf
EndFunc   ;==>_WinCred_CredRead
