@echo off
set "targetDir=G:\BackupSaves"

REM Check if the target directory exists
if not exist "%targetDir%" (
    echo Error: The directory "%targetDir%" does not exist.
    exit /b 1
)

REM Delete files older than 1 day
forfiles /p "%targetDir%" /s /m *.* /d -1 /c "cmd /c del @path" 2>nul

REM Delete empty directories older than 1 day
for /f "delims=" %%d in ('dir /ad /b /s "%targetDir%" 2^>nul') do (
    pushd "%%d" >nul
    REM Check if the directory is empty
    set "nonempty="
    for /f "delims=" %%e in ('dir /b /a-d 2^>nul') do set "nonempty=1"
    REM If directory is empty, delete it
    if not defined nonempty rd "%%d" 2>nul
    popd >nul
)

REM Clean up any remaining empty directories
for /f "delims=" %%d in ('dir /ad /b /s "%targetDir%" 2^>nul') do rd "%%d" 2>nul

echo Files and empty directories older than 1 day have been deleted.
