#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7

#include "..\WinCred.au3"

Opt("MustDeclareVars", 1)

Example()

Func Example()
	; Demonstrates how to delete a credential from the Windows Credential Manager.

	Local Const $sTargetName = "Example-Delete-Target"
	Local Const $sUserName = "TestUser"
	Local Const $vCredentialBlob = Binary("MySecretPassword")

	; First create a credential that we can then delete
	_WinCred_CredWrite($sTargetName, $CRED_TYPE_GENERIC, $sUserName, $vCredentialBlob)
	If @error Then
		ConsoleWrite("Error creating credential: Error " & @error & ", Extended " & @extended & @CRLF)
		Return
	EndIf

	ConsoleWrite("Credential successfully created." & @CRLF)

	; Check if the credential exists by reading it
	Local $aCredential = _WinCred_CredRead($sTargetName, $CRED_TYPE_GENERIC)
	If @error Then
		ConsoleWrite("Error: Credential could not be read!" & @CRLF)
		Return
	EndIf

	ConsoleWrite("Credential exists and was successfully read." & @CRLF)
	ConsoleWrite("  TargetName: " & $aCredential[0] & @CRLF & @CRLF)

	; Delete credential
	_WinCred_CredDelete($sTargetName, $CRED_TYPE_GENERIC)
	If @error Then
		ConsoleWrite("Error deleting credential: Error " & @error & ", Extended " & @extended & @CRLF)
		Return
	EndIf

	ConsoleWrite("Credential successfully deleted!" & @CRLF)

	; Verify that the credential was actually deleted
	$aCredential = _WinCred_CredRead($sTargetName, $CRED_TYPE_GENERIC)
	If @error Then
		ConsoleWrite("Confirmation: Credential no longer exists (as expected)." & @CRLF)
	Else
		ConsoleWrite("WARNING: Credential still exists!" & @CRLF)
		; Try to delete again
		_WinCred_CredDelete($sTargetName, $CRED_TYPE_GENERIC)
	EndIf

	ConsoleWrite(@CRLF & "Example completed." & @CRLF)
EndFunc   ;==>Example

