@echo off
chcp 950 >nul
setlocal enabledelayedexpansion

::::::::::::::::::::::::::::
:: �޲z���v���ˬd
::::::::::::::::::::::::::::
NET FILE 1>NUL 2>NUL
if not "%errorlevel%" == "0" (
    echo �ХH�޲z���������榹�{��
    pause
    exit /b 1
)

:: �B�zUNC���|
if "%~d0"=="" (
    pushd "%~dp0" 2>nul
    if errorlevel 1 (
        echo UNC���|���D�A�ЬM�g�����Ϻо������
        pause
        exit /b 1
    )
) else (
    cd /d "%~dp0"
)

::::::::::::::::::::::::::::
:: �}�l�ƥ��{��
::::::::::::::::::::::::::::
CLS
echo ========================================
echo �t�έ���ƥ��u�� v2.0
echo ========================================
echo.

:: �إ߮ɶ��W�O�ؿ�
echo ���b�إ߳ƥ��ؿ�...
for /f %%a in ('powershell -command "Get-Date -Format 'yyyyMMddHHmmss'"') do set timestamp=%%a
if "%timestamp%"=="" (
    set timestamp=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
    set timestamp=!timestamp: =0!
)

set BACKUP_DIR=%~dp0%timestamp%-%COMPUTERNAME%

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
if not exist "%BACKUP_DIR%" (
    echo �ƥ��ؿ��إߥ���
    pause
    exit /b 1
)

echo [OK] �ƥ��ؿ�: %timestamp%-%COMPUTERNAME%

:: �إߤl�ؿ�
mkdir "%BACKUP_DIR%\BackupUserData" >nul 2>&1
mkdir "%BACKUP_DIR%\Browser" >nul 2>&1
mkdir "%BACKUP_DIR%\LINE" >nul 2>&1
mkdir "%BACKUP_DIR%\Printer" >nul 2>&1  
mkdir "%BACKUP_DIR%\drive_C" >nul 2>&1
mkdir "%BACKUP_DIR%\drive_D" >nul 2>&1

echo.
echo �}�l�ƥ��@�~...
echo.

::::::::::::::::::::::::::::
:: �ƥ��ӤH��Ƨ�
::::::::::::::::::::::::::::
echo [1/4] �ƥ��ӤH��Ƨ�...

echo   �|�w Desktop
if exist "%USERPROFILE%\Desktop" (
    robocopy "%USERPROFILE%\Desktop" "%BACKUP_DIR%\BackupUserData\Desktop" /E /R:2 /W:1 /NP /NDL /NFL 
    echo   [OK] �ୱ
) else (
    echo   [!] �䤣��ୱ
)

echo   �|�w Documents  
if exist "%USERPROFILE%\Documents" (
    robocopy "%USERPROFILE%\Documents" "%BACKUP_DIR%\BackupUserData\Documents" /E /R:2 /W:1 /NP /NDL /NFL 
    echo   [OK] ���
) else (
    echo   [!] �䤣����
)

echo   �|�w Downloads
if exist "%USERPROFILE%\Downloads" (
    robocopy "%USERPROFILE%\Downloads" "%BACKUP_DIR%\BackupUserData\Downloads" /E /R:2 /W:1 /NP /NDL /NFL
    echo   [OK] �U��
) else (
    echo   [!] �䤣��U��
)

echo   �|�w Favorites
if exist "%USERPROFILE%\Favorites" (
    robocopy "%USERPROFILE%\Favorites" "%BACKUP_DIR%\BackupUserData\Favorites" /E /R:2 /W:1 /NP /NDL /NFL
    echo   [OK] �ڪ��̷R
) else (
    echo   [!] �䤣��ڪ��̷R
)

echo   �|�w Pictures
if exist "%USERPROFILE%\Pictures" (
    robocopy "%USERPROFILE%\Pictures" "%BACKUP_DIR%\BackupUserData\Pictures" /E /R:2 /W:1 /NP /NDL /NFL
    echo   [OK] �Ϥ�
) else (
    echo   [!] �䤣��Ϥ�
)

echo   �|�w Videos
if exist "%USERPROFILE%\Videos" (
    robocopy "%USERPROFILE%\Videos" "%BACKUP_DIR%\BackupUserData\Videos" /E /R:2 /W:1 /NP /NDL /NFL
    echo   [OK] �v��
) else (
    echo   [!] �䤣��v��
)

::::::::::::::::::::::::::::
:: �ƥ��s�������ҩM�]�w
::::::::::::::::::::::::::::
echo.
echo [2/4] �ƥ��s�������ҩM�]�w...

echo   �|�w Chrome
if exist "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default" (
    mkdir "%BACKUP_DIR%\Browser\Chrome" >nul 2>&1
    
    :: �ƥ�Chrome����
    if exist "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" (
        copy "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" "%BACKUP_DIR%\Browser\Chrome\" >nul 2>&1
    )
    
    :: �ƥ�Chrome���n�]�w
    if exist "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Preferences" (
        copy "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Preferences" "%BACKUP_DIR%\Browser\Chrome\" >nul 2>&1
    )
    
    echo   [OK] Chrome���ҩM�]�w
) else (
    echo   [!] �䤣��Chrome
)

echo   �|�w Edge  
if exist "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default" (
    mkdir "%BACKUP_DIR%\Browser\Edge" >nul 2>&1
    
    :: �ƥ�Edge����
    if exist "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks" (
        copy "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks" "%BACKUP_DIR%\Browser\Edge\" >nul 2>&1
    )
    
    :: �ƥ�Edge���n�]�w
    if exist "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Preferences" (
        copy "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Preferences" "%BACKUP_DIR%\Browser\Edge\" >nul 2>&1
    )
    
    echo   [OK] Edge���ҩM�]�w
) else (
    echo   [!] �䤣��Edge
)

:: �إ��s���������ɮ�
(
echo ========================================
echo �s�������ҩM�]�w�ƥ�����
echo ========================================
echo.
echo �ƥ����: %date% %time%
echo.
echo �ƥ����e:
echo Chrome/
echo   - Bookmarks     ^(�����ɮ�^)
echo   - Preferences   ^(���n�]�w^)
echo   - Login Data    ^(�K�X��ơA�w�[�K^)
echo.
echo Edge/
echo   - Bookmarks     ^(�����ɮ�^)
echo   - Preferences   ^(���n�]�w^)
echo   - Login Data    ^(�K�X��ơA�w�[�K^)
echo.
echo �٭�覡:
echo 1. ���s�w�� Chrome/Edge �s����
echo 2. �����s����
echo 3. �N�����ɮ׽ƻs�^���m:
echo    Chrome: %USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\
echo    Edge: %USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\
echo 4. ���s�}���s����
echo.
echo �`�N�ƶ�:
echo - Login Data �]�t�[�K���K�X�A�ݦb�P�@�x�q���~�ॿ�`�ϥ�
echo - ��ĳ���s�n�J�U�����H�T�O�K�X���`�P�B
echo - �p���P�B�b���A���ҷ|�۰ʱq�����٭�
echo.
) > "%BACKUP_DIR%\Browser\BrowserBackup.txt"

echo   [OK] �s�����ƥ�����

::::::::::::::::::::::::::::
:: �ƥ�LINE��ѰO���M�]�w
::::::::::::::::::::::::::::
echo.
echo [3/4] �ƥ�LINE��ѰO���M�]�w...

echo   �|�w LINE Data
if exist "%USERPROFILE%\AppData\Local\LINE\Data" (
    robocopy "%USERPROFILE%\AppData\Local\LINE\Data" "%BACKUP_DIR%\LINE\Data" /E /R:2 /W:1 /NP /NDL /NFL >nul
    echo   [OK] LINE��ѰO��
) else (
    echo   [!] �䤣��LINE Data��Ƨ�
)

echo   �|�w LINE�]�w��
if exist "%USERPROFILE%\AppData\Local\LINE" (
    :: �ƥ�LINE�D�n�]�w�ɮס]�ư�Data��Ƨ��A�]���w�g��W�ƥ��^
    robocopy "%USERPROFILE%\AppData\Local\LINE" "%BACKUP_DIR%\LINE" *.* /R:2 /W:1 /NP /NDL /NFL /XD Data >nul
    echo   [OK] LINE�]�w�ɮ�
) else (
    echo   [!] �䤣��LINE��Ƨ�
)

:: �إ�LINE�ƥ������ɮ�
(
echo ========================================
echo LINE��ѰO���M�]�w�ƥ�����
echo ========================================
echo.
echo �ƥ����: %date% %time%
echo.
echo �ƥ����e:
echo Data/           - LINE��ѰO���B�ɮסB�Ϥ���
echo ��L�]�w�ɮ�     - LINE�{���]�w��
echo.
echo �٭�覡:
echo 1. ���s�w��LINE�ୱ��
echo 2. �n�JLINE�b��
echo 3. ����LINE�{��
echo 4. �N�ƥ����e�ƻs�^:
echo    %USERPROFILE%\AppData\Local\LINE\
echo 5. ���s�}��LINE
echo.
echo ���n�`�N�ƶ�:
echo - ��ѰO���ƥ��]�t�Ҧ���ܡB�ɮסB�Ϥ�
echo - �ݭn�ϥάۦP��LINE�b���~�ॿ�`�٭�
echo - ��ĳ���n�JLINE�P�B���ݸ�ƦA�i���٭�
echo - �p�J����D�A�i�����եu�٭�]�w�ɡ]���tData��Ƨ��^
echo.
echo Data ��Ƨ����e����:
echo - LocalStorage: ���a�x�s���
echo - LINE/: ��ѰO���M�C���ɮ�
echo - temp/: �Ȧs�ɮ�
echo.
) > "%BACKUP_DIR%\LINE\LineBackup.txt"

echo   [OK] LINE�ƥ�����

::::::::::::::::::::::::::::
:: �ƥ��L����]�w�P�X�ʵ{��
::::::::::::::::::::::::::::
echo.
echo [4/4] �ƥ��L����]�w�PDriver�{��...

echo   �|�w �ץX�L����]�w
reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print" "%BACKUP_DIR%\Printer\PrintSettings.reg" /y >nul 2>&1
reg export "HKEY_CURRENT_USER\Printers" "%BACKUP_DIR%\Printer\UserPrinters.reg" /y >nul 2>&1

echo   �|�w �ץXDriver�{�� (DISM)
mkdir "%BACKUP_DIR%\Printer\Drivers" >nul 2>&1
Dism /online /Export-Driver /Destination:"%BACKUP_DIR%\Printer\Drivers" >nul 2>&1

echo   �|�w �ץXDriver�{�� (PnPUtil)
pnputil /export-pnpstate "%BACKUP_DIR%\Printer\PrinterDrivers.pnp" >nul 2>&1

echo   �|�w �إߦL����M��
(
echo ========================================
echo �L����M��P�]�w����  
echo ========================================
echo.
echo �ƥ����: %date% %time%
echo �q���W��: %COMPUTERNAME%
echo �ϥΪ̦W��: %USERNAME%
echo.
echo ���s�]�w�B�J:
echo 1. �w�˹������L����X�ʵ{��
echo 2. �}�� �]�w ^> �L����M���y��
echo 3. �I�� �s�W�L����α��y��
echo 4. �̷ӤU�C�M��]�w�L���
echo.
echo ========================================
echo �L����ԲӲM��:
echo ========================================
echo.
) > "%BACKUP_DIR%\Printer\PrinterList.txt"

powershell -command "Get-WmiObject -Class Win32_Printer | Select-Object Name,DriverName,PortName,Default | Format-Table -AutoSize" >> "%BACKUP_DIR%\Printer\PrinterList.txt" 2>nul

(
echo.
echo ========================================
echo �٭컡��:
echo ========================================
echo 1. �k���I�� PrintSettings.reg ��ܦX��
echo 2. �k���I�� UserPrinters.reg ��ܦX��
echo 3. ���s�Ұʹq��
echo 4. �̷ӤW��M�歫�s�]�w�L���
echo.
echo �X�ʵ{���٭�:
echo - �覡�@: �˸m�޲z�����V Drivers ��Ƨ�
echo - �覡�G: �޲z������ pnputil /import-pnpstate PrinterDrivers.pnp
echo.
) >> "%BACKUP_DIR%\Printer\PrinterList.txt"

echo   [OK] �L����ƥ�����

::::::::::::::::::::::::::::
:: �إ߳ƥ��O��
::::::::::::::::::::::::::::
echo.
echo �إ߳ƥ��O��...

(
echo ========================================
echo �t�έ���ƥ��O��
echo ========================================
echo.
echo �ƥ����: %date% %time%
echo �q���W��: %COMPUTERNAME%
echo �ϥΪ̦W��: %USERNAME%
echo �ƥ��ؿ�: %timestamp%-%COMPUTERNAME%
echo.
echo �ƥ����e����:
echo.
echo BackupUserData - �ӤH��Ƨ��ƥ�
echo   Desktop     - �ୱ�ɮ�
echo   Documents   - �ڪ����
echo   Downloads   - �U���ɮ�  
echo   Favorites   - �s�����ڪ��̷R
echo   Pictures    - �Ϥ��ɮ�
echo   Videos      - �v���ɮ�
echo.
echo Browser - �s�������ҩM�]�w
echo   Chrome/Bookmarks      - Chrome����
echo   Chrome/Preferences    - Chrome�]�w
echo   Edge/Bookmarks        - Edge����  
echo   Edge/Preferences      - Edge�]�w
echo   BrowserBackup.txt     - �s�����٭컡��
echo.
echo LINE - LINE��ѰO���M�]�w
echo   Data/                 - LINE��ѰO���B�ɮסB�Ϥ�
echo   ��L�]�w�ɮ�           - LINE�{���]�w
echo   LineBackup.txt        - LINE�٭컡��
echo.
echo Printer - �L����]�w�PDriver�{��
echo   PrintSettings.reg   - �L����t�γ]�w
echo   UserPrinters.reg    - �ϥΪ̦L����]�w
echo   Drivers/            - DISM�ץX��Driver�{��
echo   PrinterDrivers.pnp  - PnPUtil�Y���Y�Ϊ��A
echo   PrinterList.txt     - �L����M��M�Բӻ���
echo.
echo drive_C - C���B�~�ƥ��Ŷ�
echo drive_D - D���B�~�ƥ��Ŷ�
echo.
) > "%BACKUP_DIR%\BackupRecord.txt"

(
echo ========================================
echo �٭�B�J:
echo ========================================
echo.
echo 1. �ӤH����٭�:
echo    �N BackupUserData ���U��Ƨ��ƻs�^:
echo    - Desktop �� %USERPROFILE%\Desktop
echo    - Documents �� %USERPROFILE%\Documents
echo    - Downloads �� %USERPROFILE%\Downloads
echo    - Favorites �� %USERPROFILE%\Favorites
echo    - Pictures �� %USERPROFILE%\Pictures
echo    - Videos �� %USERPROFILE%\Videos
echo.
echo 2. �s�����]�w�٭�:
echo    - ���s�w�� Chrome/Edge �s����
echo    - �����s�����{��
echo    - �N Browser ��Ƨ����ɮ׽ƻs�^������m
echo    - Chrome: %USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\
echo    - Edge: %USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\
echo    - �Ѧ� BrowserBackup.txt �F�ѸԲӻ���
echo.
echo 3. LINE��ѰO���٭�:
echo    - ���s�w��LINE�ୱ���õn�J�b��
echo    - ����LINE�{��
echo    - �N LINE ��Ƨ����e�ƻs�^ %USERPROFILE%\AppData\Local\LINE\
echo    - �Ѧ� LineBackup.txt �F�ѸԲӻ���
echo.
echo 4. �L����]�w�٭�:
echo    - �k�� PrintSettings.reg ��ܦX��
echo    - �k�� UserPrinters.reg ��ܦX��
echo    - ���s�Ұʹq��
echo    - �Ѧ� PrinterList.txt ���s�]�w�L���
echo.
echo 4. �X�ʵ{���٭�:
echo    - �覡�@: �˸m�޲z�����V Drivers ��Ƨ�
echo    - �覡�G: �޲z������ pnputil /import-pnpstate PrinterDrivers.pnp
echo.
echo 5. ��L�ɮ�:
echo    - drive_C �M drive_D ���B�~�ƥ��Ŷ�
echo    - �i��ʩ�m��L���n�ɮ�
echo.
echo �`�N�ƶ�:
echo - ��ĳ�N��ӳƥ���Ƨ��ƻs��~���x�s�˸m
echo - �T�O�Ҧ��ƥ��ɮק���ʫ�A�i��t�έ���
echo - ���n�n��ݭ��s�w�˨í��s�]�w
echo.
) >> "%BACKUP_DIR%\BackupRecord.txt"

if exist "%BACKUP_DIR%\BackupRecord.txt" (
    echo [OK] �ƥ��O���إߧ���
) else (
    echo [!] �ƥ��O���إߥ���
)

::::::::::::::::::::::::::::
:: ����
::::::::::::::::::::::::::::
echo.
echo ========================================
echo [OK] �ƥ������I
echo ========================================
echo �ƥ��ؿ�: %timestamp%-%COMPUTERNAME%
echo �ƥ��ɶ�: %date% %time%
echo.
echo �ƥ����e:
echo �u�w BackupUserData (6���ӤH��Ƨ�)
echo �u�w Browser (Chrome/Edge���ҩM�]�w)
echo �u�w LINE (��ѰO���M�]�w)
echo �u�w Printer (�L����]�w�PDriver�{��)  
echo �u�w drive_C (�B�~�ƥ��Ŷ�)
echo �u�w drive_D (�B�~�ƥ��Ŷ�)
echo �|�w BackupRecord.txt (�ƥ��O��)
echo.
echo ���n����:
echo [OK] �нT�{�ƥ��ɮק����
echo [OK] ��ĳ�ƻs��~���x�s�˸m  
echo [OK] �d�� BackupRecord.txt �F���٭�B�J
echo [OK] �Ѧ� Browser/BrowserBackup.txt �٭��s����
echo [OK] �Ѧ� LINE/LineBackup.txt �٭�LINE��ѰO��
echo [OK] �Ѧ� Printer/PrinterList.txt �]�w�L���
echo.

pause

:: ��_���|
if "%~d0"=="" popd
goto :eof