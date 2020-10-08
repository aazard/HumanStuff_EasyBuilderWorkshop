ECHO OFF
Setlocal EnableDelayedExpansion

::Variables
SET @FORMAT=BC7_UNORM
SET @InputFolder=%~dp0Input_IMG_TO_BC7\
SET @OutputFolder=%~dp0Output_DXT10_BC7_NO_MIPMAPS\
SET @TEXCONVEXE=%~dp0texconv.exe
SET @TEXCONVEXE02=%~dp0texconv.exe
:: Check for texconv.exe
IF EXIST "%@TEXCONVEXE%" SET @TEXCONVEXE=1
IF "%@TEXCONVEXE%"=="1" GOTO EXESTATE_1

:EXESTATE_0
TITLE - ERROR! texconv.exe not found!!!
COLOR 04
ECHO: && ECHO: && ECHO:
ECHO                 === ERROR! texconv.exe not found!===
ECHO:
ECHO     Install Path: "%~dp0texconv.exe"
ECHO:
ECHO    The script needs texconv.exe in order to work properly.
ECHO:
ECHO    Please make sure texconv.exe is in: "%~dp0"

ECHO: && ECHO:

GOTO CONT01


:EXESTATE_1
TITLE - Texconv.exe found!!!
COLOR 0A

ECHO: && ECHO: && ECHO:
ECHO                 [ texconv.exe Is Installed! ]
ECHO:
ECHO     "%~dp0texconv.exe"
ECHO:
GOTO CONT00
:CONT01
ECHO: && ECHO:
ECHO        Please copy/move the missing texconv.exe executable to where the script needs it to be and refresh this window.
ECHO:
:CONT00
IF "%@TEXCONVEXE%"=="1" GOTO START
ECHO: && ECHO: && ECHO     [Press any key to refresh the window] && PAUSE>NUL
GOTO SetTexConvPath

:START

:: Customize CMD Window
TITLE HumanStuff TexConv Batch Directory Script v1.0.2
PROMPT $G
COLOR 04
CLS

:: Make The Folders
IF NOT EXIST "%@InputFolder%" MKDIR "%@InputFolder%"
IF NOT EXIST "%@OutputFolder%" MKDIR "%@OutputFolder%"

::Run TexConv.exe
::-srgb was added because PNG images were getting high contrast colors
::Sorry about the messy code but this was harder to do than it sounds

FOR /R "%@InputFolder%" %%i IN (*.*) DO (
set word=%@OutputFolder%
set str=%%~dpi
CALL :REPLACESTRING
SET @IFOL=!@OSTRING!
CALL :MKFOL
SET @ISTRING=%%i
CALL :TexConv01
)

PAUSE
GOTO SCRIPTEND

:MKFOL
IF NOT EXIST "%@IFOL%" (
	MKDIR "%@IFOL%"
)
GOTO SCRIPTEND

:TexConv01
IF NOT "%@LOGO%"=="" SET @LOGO=-nologo
"%@TEXCONVEXE02%" %@LOGO% -srgb -nogpu -pow2 -m 1 -vflip -if triangle -f %@FORMAT% "%@ISTRING%" -o "%@OSTRING%" -y
ECHO:
SET @LOGO= 
GOTO SCRIPTEND

:REPLACESTRING
call set str=%%str:%@InputFolder%=%word%%%
set @OSTRING=!str:~0,-1!
GOTO SCRIPTEND

:SCRIPTEND