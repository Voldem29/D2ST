if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit )
@echo off
color 70
mode con: lines=50
chcp 65001
set root=%cd%
if exist userdata goto createlist
cls
echo Wrong placement! Place the program in Steam root!
echo By default: С:/Program Files (x86)/Steam
goto end
pause

:createlist
set n=0
cd userdata
dir /a:d /o:d /t:c /b > folders.txt
for /F "tokens=*" %%i in (folders.txt) do call :arr %%i
goto menu

:arr
set /A n = %n% + 1
set /A A[%n%]=%1
set file="%root%\userdata\%1\config\localconfig.vdf"
for %%i in (%file%) do set D[%n%]=%%~ti
goto :EOF

:menu
cls
cd %root%
echo Choose function:
echo 1)Auto transfer
echo 2)Manual transfer
echo 3)Save configuration
echo 4)About
set /p func="Enter here (digit): "
if %func%==1 goto :auto
if %func%==2 goto :manual
if %func%==3 goto :save
if %func%==4 goto :about
echo No such option. Try again.
pause
goto :menu

:auto
cls
call :transfer

:manual
cls
echo List of your accounts:
call :showlist
set /p account="TO which account to transfer? (digit): "
if %account% GEQ n (
echo No such option. Try again.
goto manual
)
call :transfer

:save
cls
echo List of your accounts:
call :showlist
set /p account="FROM which account to transfer? (digit): "
if %account% GEQ n (
echo No such option. Try again.
pause
goto save
)
call :headlesssave 0
goto :eof
:headlesssave
cd %root%
if exist transfer del /f /q /s transfer
md transfer
cd transfer
md 570
cd 570
md remote
cd remote
md cfg
call xcopy "%root%\userdata\%%A[%account%]%%\570\remote\user.vcfg" "%root%\transfer\570\remote"
call xcopy "%root%\userdata\%%A[%account%]%%\570\remote\cfg\dotakeys_personal.lst" "%root%\transfer\570\remote\cfg"
echo Configuration saved!
if %1==1 goto :eof
echo Press any key to get back to menu.
pause
goto :menu

:transfer
cd %root%
if not exist transfer (
echo No saved configuration found!
echo Saving configuration from first account added to this PC...
set account=1
call :headlesssave 1
)
call :lastest
call echo Transfering to %%A[%lastest%]%%
set account=%lastest%
call xcopy /s /y "%root%\transfer" "%root%\userdata\%%A[%account%]%%"
echo Configuration transfered!
echo !!!!!!!!!
echo ATTENTION
echo !!!!!!!!!
echo If Steam asks which data to keep, choose to keep data on PC!
echo.
echo Press any key to get back to menu.
pause
goto :menu

:showlist
for /l %%x in (1, 1, %n%) do call :list %%x
goto :EOF

:list
set item=%1
call echo %item%: %%A[%item%]%%
goto :EOF

:lastest
set /A lastest=1
for /l %%i in (2, 1, %n%) do call :compare %%i
goto :eof

:compare
set current=%1
call set d1=%%D[%1]%%
call set d2=%%D[%lastest%]%%
if %d1:~6,4% gtr %d2:~6,4% goto :swap
if %d1:~6,4% lss %d2:~6,4% goto :eof
if %d1:~3,2% gtr %d2:~3,2% goto :swap
if %d1:~3,2% lss %d2:~3,2% goto :eof
if %d1:~0,2% gtr %d2:~0,2% goto :swap
if %d1:~0,2% lss %d2:~0,2% goto :eof
if %d1:~11,2% gtr %d2:~11,2% goto :swap
if %d1:~11,2% lss %d2:~11,2% goto :eof
if %d1:~14,2% gtr %d2:~14,2% goto :swap
if %d1:~14,2% lss %d2:~14,2% goto :eof
goto :EOF
:swap
set lastest=%current%
goto :EOF

:about
cls
echo Dota 2 Settings Transferer
echo 2021
echo Author: valodya beats
echo vk.com/voldemar29
echo You can tip via VK Pay if you are Russian or something...
echo.
echo This program allows to quickly and easily transfer you Dota settings 
echo TO and FROM any account you ever logged in to on this PC.
echo.
echo INITIAL SETTING (optional):
echo Initial setting is saving the settings from
echo one of your accounts.
echo If you don't do this, configuration will be saved automatically,
echo from the first account you ever logged in to.
echo To save the configuration manaully choose "3)Save configuraion",
echo then choose ID of the account FROM which you need to save the settings.
echo Accounts are listed in order they were added on the computed, so first of them is most likely your main.
echo How to get your account ID is described below, in Manual transfer paragraph.
echo.
echo HOW TO USE:
echo You can transfer settings automatically or manually.
echo 1) Auto transfer
echo   When auto transfering you don't need to do basically anything. Your saved configuration will tranfer by itself
echo   in the current account (or the last account you logged in to)
echo 2) Manual transfer
echo   When manual transfering, you will need to choose the account TO which you need to transfer settings.
echo   ID of the account can be seen in Dota, or in your Steam profile, in the address bar, 
echo   if you previously tick Steam -> Settings -> Interface -> Display web address bars when avalible.
echo   If the ID in address bar is literal and not numeric, you can get your numeric ID with help of this website:
echo   https://steamid.xyz/
echo   You need to enter you literal ID and press "Submit" (or whatever the button is called). The ID you need is in the Steam32 ID field
echo.
echo When logging in to the Steam account, or when launching Dota, Steam might find a discrepancy of data in cloud and on your PC,
echo and will ask which data to keep. Choose data on PC.
echo. 
echo.
echo Good luck using D2ST!
echo.
echo.
echo Press any key to get back to menu.
pause
goto menu

:end
pause