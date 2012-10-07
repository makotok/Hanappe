cd /d %~dp0

:: setting
set MOAI_HOME=D:\Program\moai-sdk
set MOAI_BIN=%MOAI_HOME%\bin\win32\moai.exe
set DEST_DIR=dest
set CONFIG_LUA=%MOAI_HOME%\samples\config\config.lua
set MAIN_LAU=main.lua

:: build
call ant build

:: run
cd %DEST_DIR%
%MOAI_BIN% %CONFIG_LUA% %MAIN_LAU%
