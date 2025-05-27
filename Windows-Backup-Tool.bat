@echo off
chcp 950 >nul
setlocal enabledelayedexpansion

::::::::::::::::::::::::::::
:: 管理員權限檢查
::::::::::::::::::::::::::::
NET FILE 1>NUL 2>NUL
if not "%errorlevel%" == "0" (
    echo 請以管理員身分執行此程式
    pause
    exit /b 1
)

:: 處理UNC路徑
if "%~d0"=="" (
    pushd "%~dp0" 2>nul
    if errorlevel 1 (
        echo UNC路徑問題，請映射網路磁碟機後執行
        pause
        exit /b 1
    )
) else (
    cd /d "%~dp0"
)

::::::::::::::::::::::::::::
:: 開始備份程序
::::::::::::::::::::::::::::
CLS
echo ========================================
echo 系統重灌備份工具 v2.0
echo ========================================
echo.

:: 建立時間戳記目錄
echo 正在建立備份目錄...
for /f %%a in ('powershell -command "Get-Date -Format 'yyyyMMddHHmmss'"') do set timestamp=%%a
if "%timestamp%"=="" (
    set timestamp=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%
    set timestamp=!timestamp: =0!
)

set BACKUP_DIR=%~dp0%timestamp%-%COMPUTERNAME%

if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"
if not exist "%BACKUP_DIR%" (
    echo 備份目錄建立失敗
    pause
    exit /b 1
)

echo [OK] 備份目錄: %timestamp%-%COMPUTERNAME%

:: 建立子目錄
mkdir "%BACKUP_DIR%\BackupUserData" >nul 2>&1
mkdir "%BACKUP_DIR%\Browser" >nul 2>&1
mkdir "%BACKUP_DIR%\LINE" >nul 2>&1
mkdir "%BACKUP_DIR%\Printer" >nul 2>&1  
mkdir "%BACKUP_DIR%\drive_C" >nul 2>&1
mkdir "%BACKUP_DIR%\drive_D" >nul 2>&1

echo.
echo 開始備份作業...
echo.

::::::::::::::::::::::::::::
:: 備份個人資料夾
::::::::::::::::::::::::::::
echo [1/4] 備份個人資料夾...

echo   └─ Desktop
if exist "%USERPROFILE%\Desktop" (
    robocopy "%USERPROFILE%\Desktop" "%BACKUP_DIR%\BackupUserData\Desktop" /E /R:2 /W:1 /NP /NDL /NFL 
    echo   [OK] 桌面
) else (
    echo   [!] 找不到桌面
)

echo   └─ Documents  
if exist "%USERPROFILE%\Documents" (
    robocopy "%USERPROFILE%\Documents" "%BACKUP_DIR%\BackupUserData\Documents" /E /R:2 /W:1 /NP /NDL /NFL 
    echo   [OK] 文件
) else (
    echo   [!] 找不到文件
)

echo   └─ Downloads
if exist "%USERPROFILE%\Downloads" (
    robocopy "%USERPROFILE%\Downloads" "%BACKUP_DIR%\BackupUserData\Downloads" /E /R:2 /W:1 /NP /NDL /NFL
    echo   [OK] 下載
) else (
    echo   [!] 找不到下載
)

echo   └─ Favorites
if exist "%USERPROFILE%\Favorites" (
    robocopy "%USERPROFILE%\Favorites" "%BACKUP_DIR%\BackupUserData\Favorites" /E /R:2 /W:1 /NP /NDL /NFL
    echo   [OK] 我的最愛
) else (
    echo   [!] 找不到我的最愛
)

echo   └─ Pictures
if exist "%USERPROFILE%\Pictures" (
    robocopy "%USERPROFILE%\Pictures" "%BACKUP_DIR%\BackupUserData\Pictures" /E /R:2 /W:1 /NP /NDL /NFL
    echo   [OK] 圖片
) else (
    echo   [!] 找不到圖片
)

echo   └─ Videos
if exist "%USERPROFILE%\Videos" (
    robocopy "%USERPROFILE%\Videos" "%BACKUP_DIR%\BackupUserData\Videos" /E /R:2 /W:1 /NP /NDL /NFL
    echo   [OK] 影片
) else (
    echo   [!] 找不到影片
)

::::::::::::::::::::::::::::
:: 備份瀏覽器書籤和設定
::::::::::::::::::::::::::::
echo.
echo [2/4] 備份瀏覽器書籤和設定...

echo   └─ Chrome
if exist "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default" (
    mkdir "%BACKUP_DIR%\Browser\Chrome" >nul 2>&1
    
    :: 備份Chrome書籤
    if exist "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" (
        copy "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" "%BACKUP_DIR%\Browser\Chrome\" >nul 2>&1
    )
    
    :: 備份Chrome偏好設定
    if exist "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Preferences" (
        copy "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Preferences" "%BACKUP_DIR%\Browser\Chrome\" >nul 2>&1
    )
    
    echo   [OK] Chrome書籤和設定
) else (
    echo   [!] 找不到Chrome
)

echo   └─ Edge  
if exist "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default" (
    mkdir "%BACKUP_DIR%\Browser\Edge" >nul 2>&1
    
    :: 備份Edge書籤
    if exist "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks" (
        copy "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks" "%BACKUP_DIR%\Browser\Edge\" >nul 2>&1
    )
    
    :: 備份Edge偏好設定
    if exist "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Preferences" (
        copy "%USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\Preferences" "%BACKUP_DIR%\Browser\Edge\" >nul 2>&1
    )
    
    echo   [OK] Edge書籤和設定
) else (
    echo   [!] 找不到Edge
)

:: 建立瀏覽器說明檔案
(
echo ========================================
echo 瀏覽器書籤和設定備份說明
echo ========================================
echo.
echo 備份日期: %date% %time%
echo.
echo 備份內容:
echo Chrome/
echo   - Bookmarks     ^(書籤檔案^)
echo   - Preferences   ^(偏好設定^)
echo   - Login Data    ^(密碼資料，已加密^)
echo.
echo Edge/
echo   - Bookmarks     ^(書籤檔案^)
echo   - Preferences   ^(偏好設定^)
echo   - Login Data    ^(密碼資料，已加密^)
echo.
echo 還原方式:
echo 1. 重新安裝 Chrome/Edge 瀏覽器
echo 2. 關閉瀏覽器
echo 3. 將對應檔案複製回原位置:
echo    Chrome: %USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\
echo    Edge: %USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\
echo 4. 重新開啟瀏覽器
echo.
echo 注意事項:
echo - Login Data 包含加密的密碼，需在同一台電腦才能正常使用
echo - 建議重新登入各網站以確保密碼正常同步
echo - 如有同步帳號，書籤會自動從雲端還原
echo.
) > "%BACKUP_DIR%\Browser\BrowserBackup.txt"

echo   [OK] 瀏覽器備份完成

::::::::::::::::::::::::::::
:: 備份LINE聊天記錄和設定
::::::::::::::::::::::::::::
echo.
echo [3/4] 備份LINE聊天記錄和設定...

echo   └─ LINE Data
if exist "%USERPROFILE%\AppData\Local\LINE\Data" (
    robocopy "%USERPROFILE%\AppData\Local\LINE\Data" "%BACKUP_DIR%\LINE\Data" /E /R:2 /W:1 /NP /NDL /NFL >nul
    echo   [OK] LINE聊天記錄
) else (
    echo   [!] 找不到LINE Data資料夾
)

echo   └─ LINE設定檔
if exist "%USERPROFILE%\AppData\Local\LINE" (
    :: 備份LINE主要設定檔案（排除Data資料夾，因為已經單獨備份）
    robocopy "%USERPROFILE%\AppData\Local\LINE" "%BACKUP_DIR%\LINE" *.* /R:2 /W:1 /NP /NDL /NFL /XD Data >nul
    echo   [OK] LINE設定檔案
) else (
    echo   [!] 找不到LINE資料夾
)

:: 建立LINE備份說明檔案
(
echo ========================================
echo LINE聊天記錄和設定備份說明
echo ========================================
echo.
echo 備份日期: %date% %time%
echo.
echo 備份內容:
echo Data/           - LINE聊天記錄、檔案、圖片等
echo 其他設定檔案     - LINE程式設定檔
echo.
echo 還原方式:
echo 1. 重新安裝LINE桌面版
echo 2. 登入LINE帳號
echo 3. 關閉LINE程式
echo 4. 將備份內容複製回:
echo    %USERPROFILE%\AppData\Local\LINE\
echo 5. 重新開啟LINE
echo.
echo 重要注意事項:
echo - 聊天記錄備份包含所有對話、檔案、圖片
echo - 需要使用相同的LINE帳號才能正常還原
echo - 建議先登入LINE同步雲端資料再進行還原
echo - 如遇到問題，可先嘗試只還原設定檔（不含Data資料夾）
echo.
echo Data 資料夾內容說明:
echo - LocalStorage: 本地儲存資料
echo - LINE/: 聊天記錄和媒體檔案
echo - temp/: 暫存檔案
echo.
) > "%BACKUP_DIR%\LINE\LineBackup.txt"

echo   [OK] LINE備份完成

::::::::::::::::::::::::::::
:: 備份印表機設定與驅動程式
::::::::::::::::::::::::::::
echo.
echo [4/4] 備份印表機設定與Driver程式...

echo   └─ 匯出印表機設定
reg export "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print" "%BACKUP_DIR%\Printer\PrintSettings.reg" /y >nul 2>&1
reg export "HKEY_CURRENT_USER\Printers" "%BACKUP_DIR%\Printer\UserPrinters.reg" /y >nul 2>&1

echo   └─ 匯出Driver程式 (DISM)
mkdir "%BACKUP_DIR%\Printer\Drivers" >nul 2>&1
Dism /online /Export-Driver /Destination:"%BACKUP_DIR%\Printer\Drivers" >nul 2>&1

echo   └─ 匯出Driver程式 (PnPUtil)
pnputil /export-pnpstate "%BACKUP_DIR%\Printer\PrinterDrivers.pnp" >nul 2>&1

echo   └─ 建立印表機清單
(
echo ========================================
echo 印表機清單與設定說明  
echo ========================================
echo.
echo 備份日期: %date% %time%
echo 電腦名稱: %COMPUTERNAME%
echo 使用者名稱: %USERNAME%
echo.
echo 重新設定步驟:
echo 1. 安裝對應的印表機驅動程式
echo 2. 開啟 設定 ^> 印表機和掃描器
echo 3. 點選 新增印表機或掃描器
echo 4. 依照下列清單設定印表機
echo.
echo ========================================
echo 印表機詳細清單:
echo ========================================
echo.
) > "%BACKUP_DIR%\Printer\PrinterList.txt"

powershell -command "Get-WmiObject -Class Win32_Printer | Select-Object Name,DriverName,PortName,Default | Format-Table -AutoSize" >> "%BACKUP_DIR%\Printer\PrinterList.txt" 2>nul

(
echo.
echo ========================================
echo 還原說明:
echo ========================================
echo 1. 右鍵點選 PrintSettings.reg 選擇合併
echo 2. 右鍵點選 UserPrinters.reg 選擇合併
echo 3. 重新啟動電腦
echo 4. 依照上方清單重新設定印表機
echo.
echo 驅動程式還原:
echo - 方式一: 裝置管理員指向 Drivers 資料夾
echo - 方式二: 管理員執行 pnputil /import-pnpstate PrinterDrivers.pnp
echo.
) >> "%BACKUP_DIR%\Printer\PrinterList.txt"

echo   [OK] 印表機備份完成

::::::::::::::::::::::::::::
:: 建立備份記錄
::::::::::::::::::::::::::::
echo.
echo 建立備份記錄...

(
echo ========================================
echo 系統重灌備份記錄
echo ========================================
echo.
echo 備份日期: %date% %time%
echo 電腦名稱: %COMPUTERNAME%
echo 使用者名稱: %USERNAME%
echo 備份目錄: %timestamp%-%COMPUTERNAME%
echo.
echo 備份內容說明:
echo.
echo BackupUserData - 個人資料夾備份
echo   Desktop     - 桌面檔案
echo   Documents   - 我的文件
echo   Downloads   - 下載檔案  
echo   Favorites   - 瀏覽器我的最愛
echo   Pictures    - 圖片檔案
echo   Videos      - 影片檔案
echo.
echo Browser - 瀏覽器書籤和設定
echo   Chrome/Bookmarks      - Chrome書籤
echo   Chrome/Preferences    - Chrome設定
echo   Edge/Bookmarks        - Edge書籤  
echo   Edge/Preferences      - Edge設定
echo   BrowserBackup.txt     - 瀏覽器還原說明
echo.
echo LINE - LINE聊天記錄和設定
echo   Data/                 - LINE聊天記錄、檔案、圖片
echo   其他設定檔案           - LINE程式設定
echo   LineBackup.txt        - LINE還原說明
echo.
echo Printer - 印表機設定與Driver程式
echo   PrintSettings.reg   - 印表機系統設定
echo   UserPrinters.reg    - 使用者印表機設定
echo   Drivers/            - DISM匯出的Driver程式
echo   PrinterDrivers.pnp  - PnPUtil即插即用狀態
echo   PrinterList.txt     - 印表機清單和詳細說明
echo.
echo drive_C - C槽額外備份空間
echo drive_D - D槽額外備份空間
echo.
) > "%BACKUP_DIR%\BackupRecord.txt"

(
echo ========================================
echo 還原步驟:
echo ========================================
echo.
echo 1. 個人資料還原:
echo    將 BackupUserData 內各資料夾複製回:
echo    - Desktop → %USERPROFILE%\Desktop
echo    - Documents → %USERPROFILE%\Documents
echo    - Downloads → %USERPROFILE%\Downloads
echo    - Favorites → %USERPROFILE%\Favorites
echo    - Pictures → %USERPROFILE%\Pictures
echo    - Videos → %USERPROFILE%\Videos
echo.
echo 2. 瀏覽器設定還原:
echo    - 重新安裝 Chrome/Edge 瀏覽器
echo    - 關閉瀏覽器程式
echo    - 將 Browser 資料夾內檔案複製回對應位置
echo    - Chrome: %USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\
echo    - Edge: %USERPROFILE%\AppData\Local\Microsoft\Edge\User Data\Default\
echo    - 參考 BrowserBackup.txt 了解詳細說明
echo.
echo 3. LINE聊天記錄還原:
echo    - 重新安裝LINE桌面版並登入帳號
echo    - 關閉LINE程式
echo    - 將 LINE 資料夾內容複製回 %USERPROFILE%\AppData\Local\LINE\
echo    - 參考 LineBackup.txt 了解詳細說明
echo.
echo 4. 印表機設定還原:
echo    - 右鍵 PrintSettings.reg 選擇合併
echo    - 右鍵 UserPrinters.reg 選擇合併
echo    - 重新啟動電腦
echo    - 參考 PrinterList.txt 重新設定印表機
echo.
echo 4. 驅動程式還原:
echo    - 方式一: 裝置管理員指向 Drivers 資料夾
echo    - 方式二: 管理員執行 pnputil /import-pnpstate PrinterDrivers.pnp
echo.
echo 5. 其他檔案:
echo    - drive_C 和 drive_D 為額外備份空間
echo    - 可手動放置其他重要檔案
echo.
echo 注意事項:
echo - 建議將整個備份資料夾複製到外接儲存裝置
echo - 確保所有備份檔案完整性後再進行系統重灌
echo - 重要軟體需重新安裝並重新設定
echo.
) >> "%BACKUP_DIR%\BackupRecord.txt"

if exist "%BACKUP_DIR%\BackupRecord.txt" (
    echo [OK] 備份記錄建立完成
) else (
    echo [!] 備份記錄建立失敗
)

::::::::::::::::::::::::::::
:: 完成
::::::::::::::::::::::::::::
echo.
echo ========================================
echo [OK] 備份完成！
echo ========================================
echo 備份目錄: %timestamp%-%COMPUTERNAME%
echo 備份時間: %date% %time%
echo.
echo 備份內容:
echo ├─ BackupUserData (6項個人資料夾)
echo ├─ Browser (Chrome/Edge書籤和設定)
echo ├─ LINE (聊天記錄和設定)
echo ├─ Printer (印表機設定與Driver程式)  
echo ├─ drive_C (額外備份空間)
echo ├─ drive_D (額外備份空間)
echo └─ BackupRecord.txt (備份記錄)
echo.
echo 重要提醒:
echo [OK] 請確認備份檔案完整性
echo [OK] 建議複製到外接儲存裝置  
echo [OK] 查看 BackupRecord.txt 了解還原步驟
echo [OK] 參考 Browser/BrowserBackup.txt 還原瀏覽器
echo [OK] 參考 LINE/LineBackup.txt 還原LINE聊天記錄
echo [OK] 參考 Printer/PrinterList.txt 設定印表機
echo.

pause

:: 恢復路徑
if "%~d0"=="" popd
goto :eof