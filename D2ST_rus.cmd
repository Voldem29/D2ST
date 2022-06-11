if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit )
@echo off
color 70
mode con: lines=50
chcp 65001
set root=%cd%
if exist userdata goto createlist
cls
echo Неверное расположение! Переместите программу в корень Steam!
echo По умолчанию: С:/Program Files (x86)/Steam
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
echo Выберите вариант:
echo 1)Автоматический перенос
echo 2)Ручной перенос
echo 3)Сохранить конфигурацию
echo 4)О программе
set /p func="Вводить тут: "
if %func%==1 goto :auto
if %func%==2 goto :manual
if %func%==3 goto :save
if %func%==4 goto :about
echo Такого варианта нет. Попробуй еще раз.
pause
goto :menu

:auto
cls
call :transfer

:manual
cls
echo Список ваших аккаунтов:
call :showlist
set /p account="В какой аккаунт переносить конфигурацию? (цифрой): "
if %account% GEQ n (
echo Такого варианта нет. Попробуй еще раз.
goto manual
)
call :transfer

:save
cls
echo Список ваших аккаунтов:
call :showlist
set /p account="С какого аккаунта сохранить конфигурацию? (цифрой): "
if %account% GEQ n (
echo Такого варианта нет. Попробуй еще раз.
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
echo Конфигурация сохранена!
if %1==1 goto :eof
echo Нажмите любую кнопку (кроме ENTER) чтобы вернуться в меню.
pause
goto :menu

:transfer
cd %root%
if not exist transfer (
echo Сохраненная конфигурация не найдена!
echo Сохраняем конфигурацию с первого добавленного аккаунта...
set account=1
call :headlesssave 1
)
call :lastest
call echo Перенос в %%A[%lastest%]%%
set account=%lastest%
call xcopy /s /y "%root%\transfer" "%root%\userdata\%%A[%account%]%%"
echo Данные перенесены!
echo !!!!!!!!
echo ВНИМАНИЕ Если Steam спросит, сохранить данные из облака или из ПК, выбирайте данные из ПК
echo !!!!!!!!
echo.
echo Нажмите любую кнопку (кроме ENTER) чтобы вернуться в меню.
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
echo Автор: valodya beats
echo vk.com/voldemar29
echo Типать можно через VK Pay
echo.
echo Эта программа позволяет удобно переносить ваши настройки из доты в любой аккаунт, 
echo в который вы когда-либо заходили на этом компьютере.
echo.
echo НАЧАЛЬНАЯ НАСТРОЙКА (необязательно):
echo Начальная настройка заключается в сохранении определенной конфигурации
echo с одного из аккаунтов в который вы заходили.
echo Если вы этого не сделаете, конфигурация будет сохранена автоматически,
echo с первого аккаунта на который вы когда либо заходили.
echo Чтобы сохранить конфигурацию вручную выберите пункт "3)Сохранить конфигурацию",
echo затем выберите ID аккаунта, конфигурацию с которого нужно сохранить конфигурацию.
echo Аккаунты расположены в порядке добавления на компьютер, так что, скорее всего, первый - ваш основной
echo О том как узнать ID аккаунта написано ниже.
echo.
echo КАК ИСПОЛЬЗОВАТЬ:
echo Настройки можно переносить автоматически или вручную.
echo 1) Автоматический перенос
echo   При автоматическом переносе не нужно делать вообще ничего. Ваша сохраненная конфигурация сама перенесется
echo   в текущий аккаунт (или в последний аккаунт в который вы заходили)
echo 2) Ручной перенос
echo   При ручном переносе придется выбрать аккаунт, в который нужно переносить конфигурацию.
echo   ID нужного аккаунта можно посмотреть в профиле в доте, или в профиле в стиме, в адресной строке, 
echo   предварительно включив галочку в стиме Настройки -> Интерфейс -> По возможности отображать адресные строки.
echo   Если в адресной строке не цифровой, а буквенный ID, то цифровой можно найти при помощи специального сервиса:
echo   https://steamid.xyz/
echo   Нужно вставить туда буквенный ID и нажать "Отправить". Нужный ID аккаунта будет в поле Steam32 ID
echo.
echo При заходе в аккаунт стима, или при заходе в доту, стим может найти несоответствие данных в облаке и на компьютере,
echo и предложит выбрать, какие данные надо сохранить. Выбирайте данные на ПК.
echo. 
echo.
echo Удачи в использовании D2ST!
echo.
echo.
echo Нажмите любую кнопку (кроме ENTER) чтобы вернуться в меню.
pause
goto menu

:end
pause