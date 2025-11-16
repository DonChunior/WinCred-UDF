# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-16

### Added

- Implementation of `_WinCred_CredWrite` function for creating and modifying credentials.
- Implementation of `_WinCred_CredRead` function for reading credentials from the user's credential set.
- Implementation of `_WinCred_CredDelete` function for deleting credentials.
- Internal helper function `__WinCred_ReadUnicodeString` for correctly reading Unicode strings from pointers.
- Constants file `WinCredConstants.au3` with all credential type and persistence constants.
- Example scripts in *Examples* directory:
  - *_WinCred_CredWrite.au3* - Demonstrates creating credentials with different persistence settings.
  - *_WinCred_CredRead.au3* - Demonstrates reading credentials and displaying all available information.
  - *_WinCred_CredDelete.au3* - Demonstrates deleting credentials and verifying deletion.