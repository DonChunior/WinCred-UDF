#include-once

; #INDEX# =======================================================================================================================
; Title .........: WinCred Constants
; Version .......: 1.0.0
; AutoIt Version : 3.3.16.1
; Language ......: English
; Description ...: Constants for Windows Credential Management API.
; Author(s) .....: Domenic Laritz
; Links .........: https://learn.microsoft.com/en-us/windows/win32/api/wincred/
; ===============================================================================================================================

Global Const $CRED_TYPE_GENERIC = 1
Global Const $CRED_TYPE_DOMAIN_PASSWORD = 2
Global Const $CRED_TYPE_DOMAIN_CERTIFICATE = 3
Global Const $CRED_TYPE_DOMAIN_VISIBLE_PASSWORD = 4
Global Const $CRED_TYPE_GENERIC_CERTIFICATE = 5
Global Const $CRED_TYPE_DOMAIN_EXTENDED = 6
Global Const $CRED_TYPE_MAXIMUM = 7
Global Const $CRED_TYPE_MAXIMUM_EX = $CRED_TYPE_MAXIMUM + 1000

Global Const $CRED_PRESERVE_CREDENTIAL_BLOB = 0x1

Global Const $CRED_PERSIST_SESSION = 1
Global Const $CRED_PERSIST_LOCAL_MACHINE = 2
Global Const $CRED_PERSIST_ENTERPRISE = 3
