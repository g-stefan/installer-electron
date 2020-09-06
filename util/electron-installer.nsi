;--------------------------------
; Electron Installer
;
; Public domain
; http://unlicense.org/
; Created by Grigore Stefan <g_stefan@yahoo.com>
;

!include "MUI2.nsh"
!include "LogicLib.nsh"

; The name of the installer
Name "Electron"

; Version
!define ElectronVersion "10.1.1"

; The file to write
OutFile "installer\electron-${ElectronVersion}-installer.exe"

Unicode True
RequestExecutionLevel admin
BrandingText "Grigore Stefan [ github.com/g-stefan ]"

; The default installation directory
InstallDir "$PROGRAMFILES64\Electron"

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\Electron" "InstallPath"

;--------------------------------
;Interface Settings

!define MUI_ABORTWARNING
!define MUI_ICON "util\system-installer.ico"
!define MUI_UNICON "util\system-installer.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "util\xyo-installer-wizard.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "util\xyo-uninstaller-wizard.bmp"

;--------------------------------
;Pages

!define MUI_COMPONENTSPAGE_SMALLDESC
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "release\LICENSE"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!ifdef INNER
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH
!endif

;--------------------------------
;Languages

!insertmacro MUI_LANGUAGE "English"

;--------------------------------
; Generate signed uninstaller
!ifdef INNER
	!echo "Inner invocation"                  ; just to see what's going on
	OutFile "build\dummy-installer.exe"       ; not really important where this is
	SetCompress off                           ; for speed
!else
	!echo "Outer invocation"
 
	; Call makensis again against current file, defining INNER.  This writes an installer for us which, when
	; it is invoked, will just write the uninstaller to some location, and then exit.
 
	!makensis '/NOCD /DINNER "util\${__FILE__}"' = 0
 
	; So now run that installer we just created as build\temp-installer.exe.  Since it
	; calls quit the return value isn't zero.
 
	!system 'set __COMPAT_LAYER=RunAsInvoker&"build\dummy-installer.exe"' = 2
 
	; That will have written an uninstaller binary for us.  Now we sign it with your
	; favorite code signing tool.
 
	!system 'grigore-stefan.sign "Electron" "build\Uninstall.exe"' = 0
 
	; Good.  Now we can carry on writing the real installer. 	 
!endif

;--------------------------------
;Signed uninstaller: Generate uninstaller only
Function .onInit
!ifdef INNER 
	; If INNER is defined, then we aren't supposed to do anything except write out
	; the uninstaller.  This is better than processing a command line option as it means
	; this entire code path is not present in the final (real) installer.
	SetSilent silent
	WriteUninstaller "$EXEDIR\Uninstall.exe"
	Quit  ; just bail out quickly when running the "inner" installer
!endif
FunctionEnd

;--------------------------------
;Installer Sections

Section "Electron (required)" MainSection

	SectionIn RO
	SetRegView 64

	; Set output path to the installation directory.
	SetOutPath $INSTDIR
	WriteRegStr HKLM "Software\Electron" "InstallPath" "$INSTDIR"

	; Write the uninstall keys for Windows
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Electron" "DisplayName" "Electron"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Electron" "Publisher" "Grigore Stefan [ github.com/g-stefan ]"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Electron" "DisplayVersion" "${ElectronVersion}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Electron" "DisplayIcon" '"$INSTDIR\electron.exe"'
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Electron" "UninstallString" '"$INSTDIR\Uninstall.exe"'
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Electron" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Electron" "NoRepair" 1

	; Program files
	File /r "release\*"

; Uninstaller
!ifndef INNER
	SetOutPath $INSTDIR 
	; this packages the signed uninstaller 
	File "build\Uninstall.exe"
!endif

	; Computing EstimatedSize
	Call GetInstalledSize
	Pop $0
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Electron" "EstimatedSize" "$0"

	; Set to HKLM
	EnVar::SetHKLM

	; Set PATH
	EnVar::Check "PATH" "$INSTDIR"
	Pop $0
	${If} $0 <> 0
		EnVar::AddValue "PATH" "$INSTDIR"
		Pop $0
	${EndIf}

	; Set to HKCU
	EnVar::SetHKCU

	; Set NODE_PATH
	EnVar::Check "NODE_PATH" "$INSTDIR\modules"
	Pop $0
	${If} $0 <> 0
		EnVar::AddValue "NODE_PATH" "$INSTDIR\modules"
		Pop $0
	${EndIf}

SectionEnd

;--------------------------------
;Descriptions

;Language strings
LangString DESC_MainSection ${LANG_ENGLISH} "Electron"

;Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${MainSection} $(DESC_MainSection)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section
!ifdef INNER
Section "Uninstall"

	SetRegView 64

	;--------------------------------
	; Validating $INSTDIR before uninstall

	!macro BadPathsCheck
	StrCpy $R0 $INSTDIR "" -2
	StrCmp $R0 ":\" bad
	StrCpy $R0 $INSTDIR "" -14
	StrCmp $R0 "\Program Files" bad
	StrCpy $R0 $INSTDIR "" -8
	StrCmp $R0 "\Windows" bad
	StrCpy $R0 $INSTDIR "" -6
	StrCmp $R0 "\WinNT" bad
	StrCpy $R0 $INSTDIR "" -9
	StrCmp $R0 "\system32" bad
	StrCpy $R0 $INSTDIR "" -8
	StrCmp $R0 "\Desktop" bad
	StrCpy $R0 $INSTDIR "" -23
	StrCmp $R0 "\Documents and Settings" bad
	StrCpy $R0 $INSTDIR "" -13
	StrCmp $R0 "\My Documents" bad done
	bad:
	  MessageBox MB_OK|MB_ICONSTOP "Install path invalid!"
	  Abort
	done:
	!macroend
 
	ClearErrors
	ReadRegStr $INSTDIR HKLM "Software\Electron" "InstallPath"
	IfErrors +2
	StrCmp $INSTDIR "" 0 +2
		StrCpy $INSTDIR "$PROGRAMFILES64\Electron"
 
	# Check that the uninstall isn't dangerous.
	!insertmacro BadPathsCheck
 
	# Does path end with "\Electron"?
	!define CHECK_PATH "\Electron"
	StrLen $R1 "${CHECK_PATH}"
	StrCpy $R0 $INSTDIR "" -$R1
	StrCmp $R0 "${CHECK_PATH}" +3
		MessageBox MB_YESNO|MB_ICONQUESTION "$INSTDIR - Unrecognised uninstall path. Continue anyway?" IDYES +2
		Abort
 
	IfFileExists "$INSTDIR\*.*" 0 +2
	IfFileExists "$INSTDIR\electron.exe" +3
		MessageBox MB_OK|MB_ICONSTOP "Install path invalid!"
		Abort

	;--------------------------------
	; Do Uninstall

	SetOutPath $TEMP

	; Remove registry keys
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Electron"
	DeleteRegKey HKLM "Software\Electron"

	; Remove files and uninstaller
	RMDir /r "$INSTDIR"

	; Set to HKLM
	EnVar::SetHKLM

	; Remove PATH
	EnVar::Check "PATH" "$INSTDIR"
	Pop $0
	${If} $0 = 0
		EnVar::DeleteValue "PATH" "$INSTDIR"
		Pop $0
	${EndIf}

	; Set to HKCU
	EnVar::SetHKCU

	; Remove NODE_PATH
	EnVar::Check "NODE_PATH" "$INSTDIR\modules"
	Pop $0
	${If} $0 = 0
		EnVar::DeleteValue "NODE_PATH" "$INSTDIR\modules"
		Pop $0
		EnVar::Update HKCU NODE_PATH
		ReadEnvStr $0 NODE_PATH
		${If} $0 == ""
			EnVar::Delete "NODE_PATH"
			Pop $0		
		${EndIf}
	${EndIf}

SectionEnd
!endif
;--------------------------------
;Functions

; Return on top of stack the total size of the selected (installed) sections, formated as DWORD
Var GetInstalledSize.total
Function GetInstalledSize
	StrCpy $GetInstalledSize.total 0

	${if} ${SectionIsSelected} ${MainSection}
		SectionGetSize ${MainSection} $0
		IntOp $GetInstalledSize.total $GetInstalledSize.total + $0
	${endif}
 
	IntFmt $GetInstalledSize.total "0x%08X" $GetInstalledSize.total
	Push $GetInstalledSize.total
FunctionEnd
