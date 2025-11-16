#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7

#include "..\WinCred.au3"

Opt("MustDeclareVars", 1)

Example()

Func Example()
	; Creates a new credential in the Windows Credential Manager
	; and demonstrates how different parameters can be used.

	Local Const $sTargetName = "Example-Target"
	Local Const $sUserName = "ExampleUser"
	Local Const $vCredentialBlob = Binary("MySecretPassword123")

	; Create credential with default settings (session persistence)
	If Not _WinCred_CredWrite($sTargetName, $CRED_TYPE_GENERIC, $sUserName, $vCredentialBlob) Then
		ConsoleWrite("Error creating credential: Error " & @error & ", Extended " & @extended & @CRLF)
		Return
	EndIf

	ConsoleWrite("Credential successfully created!" & @CRLF)

	; Create credential with local persistence (remains after logout)
	Local Const $sTargetName2 = "Example-Target-Local"
	If Not _WinCred_CredWrite($sTargetName2, $CRED_TYPE_GENERIC, $sUserName, $vCredentialBlob, $CRED_PERSIST_LOCAL_MACHINE) Then
		ConsoleWrite("Error creating local credential: Error " & @error & ", Extended " & @extended & @CRLF)
	Else
		ConsoleWrite("Local credential successfully created!" & @CRLF)
	EndIf

	; Create credential without username
	Local Const $sTargetName3 = "Example-Target-NoUser"
	If Not _WinCred_CredWrite($sTargetName3, $CRED_TYPE_GENERIC, "", $vCredentialBlob) Then
		ConsoleWrite("Error creating credential without username: Error " & @error & ", Extended " & @extended & @CRLF)
	Else
		ConsoleWrite("Credential without username successfully created!" & @CRLF)
	EndIf

	; Cleanup: Delete all created credentials
	_WinCred_CredDelete($sTargetName, $CRED_TYPE_GENERIC)
	_WinCred_CredDelete($sTargetName2, $CRED_TYPE_GENERIC)
	_WinCred_CredDelete($sTargetName3, $CRED_TYPE_GENERIC)

	ConsoleWrite("Example completed. All test credentials have been deleted." & @CRLF)
EndFunc   ;==>Example

