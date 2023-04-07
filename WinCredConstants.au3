#include-once

;~ Maximum length of the various credential string fields (in characters)
Global Const $CRED_MAX_STRING_LENGTH = 256

;~ Maximum length of the TargetName field for CRED_TYPE_GENERIC (in characters)
Global Const $CRED_MAX_GENERIC_TARGET_NAME_LENGTH = 32767

;~ Maximum length of the TargetName field for CRED_TYPE_DOMAIN_* (in characters)
Global Const $CRED_MAX_DOMAIN_TARGET_NAME_LENGTH = 256+1+80

;~ Values of the Credential Flags field.
Global Const $CRED_FLAGS_PASSWORD_FOR_CERT = 0x0001
Global Const $CRED_FLAGS_PROMPT_NOW = 0x0002
Global Const $CRED_FLAGS_USERNAME_TARGET = 0x0004
Global Const $CRED_FLAGS_OWF_CRED_BLOB = 0x0008
Global Const $CRED_FLAGS_REQUIRE_CONFIRMATION = 0x0010

;~ Values of the Credential Type field.
Global Const $CRED_TYPE_GENERIC = 1
Global Const $CRED_TYPE_DOMAIN_PASSWORD = 2
Global Const $CRED_TYPE_DOMAIN_CERTIFICATE = 3
Global Const $CRED_TYPE_DOMAIN_VISIBLE_PASSWORD = 4
Global Const $CRED_TYPE_GENERIC_CERTIFICATE = 5
Global Const $CRED_TYPE_DOMAIN_EXTENDED = 6
Global Const $CRED_TYPE_MAXIMUM = 7
Global Const $CRED_TYPE_MAXIMUM_EX = $CRED_TYPE_MAXIMUM + 1000
