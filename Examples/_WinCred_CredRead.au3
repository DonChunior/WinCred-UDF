#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7

#include "..\WinCred.au3"

Opt("MustDeclareVars", 1)

Example()

Func Example()
	; Reads a credential from the Windows Credential Manager
	; and displays all available information.

	Local Const $sTargetName = "Example-Read-Target"
	Local Const $sUserName = "TestUser"
	Local Const $vCredentialBlob = Binary("MySecretPassword")

	; First create a credential that we can then read
	_WinCred_CredWrite($sTargetName, $CRED_TYPE_GENERIC, $sUserName, $vCredentialBlob)
	If @error Then
		ConsoleWrite("Error creating credential: Error " & @error & ", Extended " & @extended & @CRLF)
		Return
	EndIf

	ConsoleWrite("Credential created. Now reading it..." & @CRLF & @CRLF)

	; Read credential
	Local $aCredential = _WinCred_CredRead($sTargetName, $CRED_TYPE_GENERIC)
	If @error Then
		ConsoleWrite("Error reading credential: Error " & @error & ", Extended " & @extended & @CRLF)
		; Cleanup
		_WinCred_CredDelete($sTargetName, $CRED_TYPE_GENERIC)
		Return
	EndIf

	; Display found information
	ConsoleWrite("Credential successfully read:" & @CRLF)
	ConsoleWrite("  TargetName: " & $aCredential[0] & @CRLF)
	ConsoleWrite("  Type: " & $aCredential[1] & @CRLF)
	ConsoleWrite("  UserName: " & $aCredential[2] & @CRLF)
	ConsoleWrite("  CredentialBlob (Length): " & BinaryLen($aCredential[3]) & " Bytes" & @CRLF)
	ConsoleWrite("  Persist: " & $aCredential[4] & @CRLF)
	ConsoleWrite("  Comment: " & $aCredential[5] & @CRLF)

	; Check if the read CredentialBlob matches the original
	If $aCredential[3] = $vCredentialBlob Then
		ConsoleWrite(@CRLF & "The CredentialBlob matches the original!" & @CRLF)
	Else
		ConsoleWrite(@CRLF & "WARNING: The CredentialBlob does not match the original!" & @CRLF)
	EndIf

	; Cleanup: Delete credential again
	_WinCred_CredDelete($sTargetName, $CRED_TYPE_GENERIC)
	ConsoleWrite(@CRLF & "Example completed. Test credential has been deleted." & @CRLF)
EndFunc   ;==>Example

