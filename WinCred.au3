#include-once

#include "WinCredConstants.au3"
#include <WinAPIError.au3>

; #INDEX# =======================================================================================================================
; Title .........: WinCred
; Version .......: 1.0.0
; AutoIt Version : 3.3.16.1
; Language ......: English
; Description ...: Windows Credential Management API functions.
; Author(s) .....: Domenic Laritz
; Dll ...........: Advapi32.dll
; Links .........: https://learn.microsoft.com/en-us/windows/win32/api/wincred/
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_WinCred_CredDelete
;_WinCred_CredRead
;_WinCred_CredWrite
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name ..........: _WinCred_CredDelete
; Description ...: Deletes a credential from the user's credential set.
; Syntax ........: _WinCred_CredDelete(Const Byref $sTargetName, Const Byref $iType)
; Parameters ....: $sTargetName         - Name of the credential to delete.
;                  $iType               - Type of the credential to delete. Type must be one of the $CRED_TYPE_* defined types.
; Return values .: Success              - True, if credential was deleted
;                  Failure              - False, sets @error:
;                                   |1 - Credential not found or other error (check @extended for GetLastError code)
;                                   |2 - DllCall error
;                                   |3 - Invalid parameter: $sTargetName is empty
; Author ........: Domenic Laritz
; Modified ......:
; Remarks .......: If $iType is $CRED_TYPE_DOMAIN_EXTENDED, the $sTargetName parameter must specify the user name as "Target|UserName".
; Related .......:
; Link ..........: https://learn.microsoft.com/en-us/windows/win32/api/wincred/nf-wincred-creddeletew
; Example .......: Yes
; ===============================================================================================================================
Func _WinCred_CredDelete(Const ByRef $sTargetName, Const ByRef $iType)
	; Validate parameters
	If $sTargetName = "" Then Return SetError(3, 0, False)

	; Call CredDeleteW
	Local $aResult = DllCall('Advapi32.dll', 'bool', 'CredDeleteW', 'wstr', $sTargetName, 'dword', $iType, 'dword', 0)
	If @error Then Return SetError(2, 0, False)

	If $aResult[0] Then
		Return SetError(0, 0, True)
	Else
		Return SetError(1, _WinAPI_GetLastError(), False)
	EndIf
EndFunc   ;==>_WinCred_CredDelete

; #FUNCTION# ====================================================================================================================
; Name ..........: _WinCred_CredRead
; Description ...: Reads a credential from the user's credential set.
; Syntax ........: _WinCred_CredRead(Const Byref $sTargetName, Const Byref $iType)
; Parameters ....: $sTargetName         - Name of the credential to read.
;                  $iType               - Type of the credential to read. Type must be one of the $CRED_TYPE_* defined types.
; Return values .: Success              - Array with credential information:
;                                   |[0] - TargetName (string)
;                                   |[1] - Type (dword)
;                                   |[2] - UserName (string)
;                                   |[3] - CredentialBlob (binary data)
;                                   |[4] - Persist (dword)
;                                   |[5] - Comment (string)
;                  Failure              - 0, sets @error:
;                                   |1 - Credential not found or other error (check @extended for GetLastError code)
;                                   |2 - DllCall error
;                                   |3 - Failed to read credential structure
; Author ........: Domenic Laritz
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: https://learn.microsoft.com/en-us/windows/win32/api/wincred/nf-wincred-credreadw
; Example .......: Yes
; ===============================================================================================================================
Func _WinCred_CredRead(Const ByRef $sTargetName, Const ByRef $iType)
	Local $aResult = 0
	Local $pCredential = 0
	Local $tCredential = 0
	Local $aCredential[6] = [0, 0, "", Binary(""), 0, ""]

	; Call CredReadW to get pointer to CREDENTIAL structure
	$aResult = DllCall('Advapi32.dll', 'bool', 'CredReadW', 'wstr', $sTargetName, 'dword', $iType, 'dword', 0, 'ptr*', 0)
	If @error Then Return SetError(2, 0, 0)

	If Not $aResult[0] Then
		Return SetError(1, _WinAPI_GetLastError(), 0)
	EndIf

	$pCredential = $aResult[4]
	If $pCredential = 0 Then Return SetError(3, 0, 0)

	; Create CREDENTIAL structure from pointer
	; Structure: Flags (DWORD), Type (DWORD), TargetName (ptr), Comment (ptr), LastWritten (FILETIME = 2 DWORDs),
	;            CredentialBlobSize (DWORD), CredentialBlob (ptr), Persist (DWORD), AttributeCount (DWORD),
	;            Attributes (ptr), TargetAlias (ptr), UserName (ptr)
	$tCredential = DllStructCreate("dword Flags;dword Type;ptr TargetName;ptr Comment;dword LastWrittenLow;dword LastWrittenHigh;" & _
			"dword CredentialBlobSize;ptr CredentialBlob;dword Persist;dword AttributeCount;" & _
			"ptr Attributes;ptr TargetAlias;ptr UserName", $pCredential)

	; Read structure fields
	Local $iCredType = DllStructGetData($tCredential, "Type")
	Local $pTargetName = DllStructGetData($tCredential, "TargetName")
	Local $pUserName = DllStructGetData($tCredential, "UserName")
	Local $iCredentialBlobSize = DllStructGetData($tCredential, "CredentialBlobSize")
	Local $pCredentialBlob = DllStructGetData($tCredential, "CredentialBlob")
	Local $iPersist = DllStructGetData($tCredential, "Persist")
	Local $pComment = DllStructGetData($tCredential, "Comment")

	; Read TargetName
	Local $sReadTargetName = __WinCred_ReadUnicodeString($pTargetName)

	; Read UserName
	Local $sUserName = __WinCred_ReadUnicodeString($pUserName)

	; Read CredentialBlob
	Local $vCredentialBlob = Binary("")
	If $pCredentialBlob <> 0 And $iCredentialBlobSize > 0 Then
		Local $tCredentialBlob = DllStructCreate("byte[" & $iCredentialBlobSize & "]", $pCredentialBlob)
		$vCredentialBlob = DllStructGetData($tCredentialBlob, 1)
	EndIf

	; Read Comment
	Local $sComment = __WinCred_ReadUnicodeString($pComment)

	; Build result array
	$aCredential[0] = $sReadTargetName
	$aCredential[1] = $iCredType
	$aCredential[2] = $sUserName
	$aCredential[3] = $vCredentialBlob
	$aCredential[4] = $iPersist
	$aCredential[5] = $sComment

	; Free the credential structure
	DllCall('Advapi32.dll', 'none', 'CredFree', 'ptr', $pCredential)

	Return SetError(0, 0, $aCredential)
EndFunc   ;==>_WinCred_CredRead

; #FUNCTION# ====================================================================================================================
; Name ..........: _WinCred_CredWrite
; Description ...: Creates a new credential or modifies an existing credential in the user's credential set.
; Syntax ........: _WinCred_CredWrite(Const Byref $sTargetName, Const Byref $iType[, $sUserName = ""[, $vCredentialBlob = Binary("")[, $iPersist = $CRED_PERSIST_SESSION[, $iFlags = 0]]]])
; Parameters ....: $sTargetName         - Name of the credential.
;                  $iType               - Type of the credential. Type must be one of the $CRED_TYPE_* defined types.
;                  $sUserName           - [optional] User name of the credential. Default is "".
;                  $vCredentialBlob     - [optional] Binary data containing the credential secret. Default is Binary("").
;                  $iPersist            - [optional] Persistence of the credential. Can be $CRED_PERSIST_SESSION (Anmeldesitzung), $CRED_PERSIST_LOCAL_MACHINE (Lokaler Computer) or $CRED_PERSIST_ENTERPRISE (Unternehmen). Default is $CRED_PERSIST_SESSION.
;                  $iFlags              - [optional] Flags that control the function's operation. Can be $CRED_PRESERVE_CREDENTIAL_BLOB. Default is 0.
; Return values .: Success              - True
;                  Failure              - False, sets @error:
;                                   |1 - CredWriteW failed (check @extended for GetLastError code)
;                                   |2 - DllCall error
;                                   |3 - Invalid parameter: $sTargetName is empty
;                                   |4 - Invalid parameter: $iPersist is not a valid CRED_PERSIST_* value
; Author ........: Domenic Laritz
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: https://learn.microsoft.com/en-us/windows/win32/api/wincred/nf-wincred-credwritew
; Example .......: Yes
; ===============================================================================================================================
Func _WinCred_CredWrite(Const ByRef $sTargetName, Const ByRef $iType, $sUserName = "", $vCredentialBlob = Binary(""), $iPersist = $CRED_PERSIST_SESSION, $iFlags = 0)
	; Validate parameters
	If $sTargetName = "" Then Return SetError(3, 0, False)
	If $iPersist <> $CRED_PERSIST_SESSION And $iPersist <> $CRED_PERSIST_LOCAL_MACHINE And $iPersist <> $CRED_PERSIST_ENTERPRISE Then Return SetError(4, 0, False)

	; Calculate credential blob size
	Local $iCredentialBlobSize = BinaryLen($vCredentialBlob)

	; Create CREDENTIAL structure
	; Structure: Flags (DWORD), Type (DWORD), TargetName (ptr), Comment (ptr), LastWritten (FILETIME = 2 DWORDs),
	;            CredentialBlobSize (DWORD), CredentialBlob (ptr), Persist (DWORD), AttributeCount (DWORD),
	;            Attributes (ptr), TargetAlias (ptr), UserName (ptr)
	Local $tCredential = DllStructCreate("dword Flags;dword Type;ptr TargetName;ptr Comment;dword LastWrittenLow;dword LastWrittenHigh;" & _
			"dword CredentialBlobSize;ptr CredentialBlob;dword Persist;dword AttributeCount;" & _
			"ptr Attributes;ptr TargetAlias;ptr UserName")

	; Create string buffers for TargetName and UserName
	Local $tTargetName = DllStructCreate("wchar[" & (StringLen($sTargetName) + 1) & "]")
	DllStructSetData($tTargetName, 1, $sTargetName)

	Local $tUserName = 0
	If $sUserName <> "" Then
		$tUserName = DllStructCreate("wchar[" & (StringLen($sUserName) + 1) & "]")
		DllStructSetData($tUserName, 1, $sUserName)
	EndIf

	; Create credential blob buffer if needed
	Local $tCredentialBlob = 0
	If $iCredentialBlobSize > 0 Then
		$tCredentialBlob = DllStructCreate("byte[" & $iCredentialBlobSize & "]")
		DllStructSetData($tCredentialBlob, 1, $vCredentialBlob)
	EndIf

	; Set CREDENTIAL structure fields
	DllStructSetData($tCredential, "Flags", 0)
	DllStructSetData($tCredential, "Type", $iType)
	DllStructSetData($tCredential, "TargetName", DllStructGetPtr($tTargetName))
	DllStructSetData($tCredential, "Comment", 0)
	DllStructSetData($tCredential, "LastWrittenLow", 0)
	DllStructSetData($tCredential, "LastWrittenHigh", 0)
	DllStructSetData($tCredential, "CredentialBlobSize", $iCredentialBlobSize)
	If $iCredentialBlobSize > 0 Then
		DllStructSetData($tCredential, "CredentialBlob", DllStructGetPtr($tCredentialBlob))
	Else
		DllStructSetData($tCredential, "CredentialBlob", 0)
	EndIf
	DllStructSetData($tCredential, "Persist", $iPersist)
	DllStructSetData($tCredential, "AttributeCount", 0)
	DllStructSetData($tCredential, "Attributes", 0)
	DllStructSetData($tCredential, "TargetAlias", 0)
	If $sUserName <> "" Then
		DllStructSetData($tCredential, "UserName", DllStructGetPtr($tUserName))
	Else
		DllStructSetData($tCredential, "UserName", 0)
	EndIf

	; Call CredWriteW
	Local $aResult = DllCall('Advapi32.dll', 'bool', 'CredWriteW', 'ptr', DllStructGetPtr($tCredential), 'dword', $iFlags)
	If @error Then Return SetError(2, 0, False)

	If $aResult[0] Then
		Return SetError(0, 0, True)
	Else
		Return SetError(1, _WinAPI_GetLastError(), False)
	EndIf
EndFunc   ;==>_WinCred_CredWrite

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __WinCred_ReadUnicodeString
; Description ...: Reads a null-terminated Unicode string from a pointer.
; Syntax ........: __WinCred_ReadUnicodeString($pString)
; Parameters ....: $pString              - Pointer to null-terminated Unicode string.
; Return values .: Success              - String value
;                  Failure              - Empty string if pointer is 0 or invalid
; Author ........: Domenic Laritz
; Remarks .......: Internal function, not for public use.
; ===============================================================================================================================
Func __WinCred_ReadUnicodeString($pString)
	If $pString = 0 Then Return ""

	; Use lstrlenW to get string length
	Local $aResult = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $pString)
	If @error Or $aResult[0] = 0 Then Return ""

	Local $iLength = $aResult[0]

	; Create structure with the correct length
	Local $tString = DllStructCreate("wchar[" & ($iLength + 1) & "]", $pString)
	Local $sResult = DllStructGetData($tString, 1)

	Return $sResult
EndFunc   ;==>__WinCred_ReadUnicodeString
