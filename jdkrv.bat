@echo off
setlocal enabledelayedexpansion

:: 配置文件路径
set "CONF_FILE=%~dp0conf.jdkrv"
set "DEFAULT_JDK_DIR=%~dp0jdk"
set "LINKS_FILE=%~dp0jdkLinks.jdkrv"
set "LIST_FILE=%~dp0lists.jdkrv"
set "TEMP=%~dp0temp"

:: 读取配置文件
if exist "%CONF_FILE%" (
    for /f "usebackq tokens=1* delims==" %%A in ("%CONF_FILE%") do (
        if "%%A"=="JDK_DIR" set "JDK_DIR=%%B"
    )
) else (
    set "JDK_DIR=%DEFAULT_JDK_DIR%"
)

:: **去掉多余的引号和空格**
set "JDK_DIR=%JDK_DIR:"=%"
set "JDK_DIR=%JDK_DIR: =%"

:: 初始化环境
if "%1"=="init" (
    if not exist "%JDK_DIR%" mkdir "%JDK_DIR%"
    echo JDK storage directory: "%JDK_DIR%"
    if not exist "%TEMP%" mkdir "%TEMP%"
    echo TEMP storage directory: "%TEMP%"
    echo JDK_DIR=%JDK_DIR% > "%CONF_FILE%"
    echo Configuration saved to "%CONF_FILE%".
    echo # jdk storage path > "%LIST_FILE%"
    echo Created successfully "%CONF_FILE%".
    :: 创建 jdkLinks.jdkrv 文件并写入 JDK 下载链接
    echo corretto-1.8.0_432 https://corretto.aws/downloads/resources/8.432.06.1/amazon-corretto-8.432.06.1-windows-x64-jdk.zip > "%LINKS_FILE%"
    echo jdk-11.0.2 https://repo.huaweicloud.com/java/jdk/11.0.2+7/jdk-11.0.2_windows-x64_bin.zip >> "%LINKS_FILE%"
    echo jdk-11.0.0.2 https://download.java.net/openjdk/jdk11.0.0.2/ri/openjdk-11.0.0.2_windows-x64.zip >> "%LINKS_FILE%"
    echo jdk-12 https://download.java.net/openjdk/jdk12/ri/openjdk-12+32_windows-x64_bin.zip >> "%LINKS_FILE%"
    echo jdk-13 https://download.java.net/openjdk/jdk13/ri/openjdk-13+33_windows-x64_bin.zip >> "%LINKS_FILE%"
    echo jdk-14 https://download.java.net/openjdk/jdk14/ri/openjdk-14+36_windows-x64_bin.zip >> "%LINKS_FILE%"
    echo jdk-15 https://download.java.net/openjdk/jdk15/ri/openjdk-15+36_windows-x64_bin.zip >> "%LINKS_FILE%"
    echo jdk-16 https://download.java.net/openjdk/jdk16/ri/openjdk-16+36_windows-x64_bin.zip >> "%LINKS_FILE%"
    echo jdk-17.0.13+11 https://mirrors.tuna.tsinghua.edu.cn/Adoptium/17/jdk/x64/windows/OpenJDK17U-jdk_x64_windows_hotspot_17.0.13_11.zip >> "%LINKS_FILE%"
    echo corretto-17.0.13_11 https://corretto.aws/downloads/resources/17.0.13.11.1/amazon-corretto-17.0.13.11.1-windows-x64-jdk.zip >> "%LINKS_FILE%"
    echo jdk-17.0.0.1 https://download.java.net/openjdk/jdk17.0.0.1/ri/openjdk-17.0.0.1+2_windows-x64_bin.zip >> "%LINKS_FILE%"
    echo jdk-18 https://download.java.net/openjdk/jdk18/ri/openjdk-18+36_windows-x64_bin.zip >> "%LINKS_FILE%"
    echo jdk-19+36 https://download.java.net/openjdk/jdk19/ri/openjdk-19+36_windows-x64_bin.zip >> "%LINKS_FILE%"
    echo jdk-20+36 https://download.java.net/openjdk/jdk20/ri/openjdk-20+36_windows-x64_bin.zip >> "%LINKS_FILE%"
    echo jdk-21+35 https://download.java.net/openjdk/jdk21/ri/openjdk-21+35_windows-x64_bin.zip >> "%LINKS_FILE%"
    echo jdk-22+36 https://download.java.net/openjdk/jdk22/ri/openjdk-22+36_windows-x64_bin.zip >> "%LINKS_FILE%"
    echo jdk-23.0.1 https://download.java.net/java/GA/jdk23.0.1/c28985cbf10d4e648e4004050f8781aa/11/GPL/openjdk-23.0.1_windows-x64_bin.zip >> "%LINKS_FILE%"
    echo jdk-24-ea+30 https://download.java.net/java/early_access/jdk24/30/GPL/openjdk-24-ea+30_windows-x64_bin.zip >> "%LINKS_FILE%"
    echo jdk-25-ea+4 https://download.java.net/java/early_access/jdk25/4/GPL/openjdk-25-ea+4_windows-x64_bin.zip >> "%LINKS_FILE%"

    echo Created successfully "%LINKS_FILE%"
    exit /b 0
)

:: 安装 JDK
if "%1"=="install" (
    if "%2"=="" (
        echo Usage: jdkrv install ^<version^>
        exit /b 1
    )
    :: 确保 JDK_DIR 变量正确
    set "JDK_DIR=%JDK_DIR:"=%"
    set "JDK_DIR=%JDK_DIR: =%"
    set "JDK_PATH=!JDK_DIR!\%2"

    :: **检查 JDK 是否已安装**
    if exist "!JDK_PATH!\bin\java.exe" (
        echo JDK version %2 already installed at !JDK_PATH!.
        exit /b 0
    )
    
    if exist "!JDK_PATH!" (
        echo JDK version %2 already installed.
        exit /b 0
    )
    
    :: 从 jdkLinks.jdkrv 中查找对应的下载链接
    set "DOWNLOAD_URL="
    for /f "tokens=1,2" %%A in (%LINKS_FILE%) do (
        if "%%A"=="%2" (
            set "DOWNLOAD_URL=%%B"
        )
    )
    
    if "!DOWNLOAD_URL!"=="" (
        echo No download link found for version %2.
        exit /b 1
    )
    
    echo Downloading JDK %2 from !DOWNLOAD_URL!...
    
    :: 设置临时压缩包路径（使用 %TEMP% 环境变量）
    set "TEMP_ZIP=!TEMP!\%2.zip"
    
    :: 使用 PowerShell 下载文件
    powershell -Command "Invoke-WebRequest -Uri '!DOWNLOAD_URL!' -OutFile '!TEMP_ZIP!'"
    
    if not exist "!TEMP_ZIP!" (
        echo download failed.
        exit /b 1
    )
    
    echo Downloaded to !TEMP_ZIP!.
    echo Extracting...

    :: 使用 PowerShell 解压压缩包到目标安装目录
    powershell -Command "Expand-Archive -Path '!TEMP_ZIP!' -DestinationPath '!JDK_DIR!' -Force"
    
    if errorlevel 1 (
        echo Decompression failure.
        exit /b 1
    )
    
    :: 删除临时压缩包
    del /f /q "!TEMP_ZIP!"
    
    echo JDK %2 installed at "!JDK_PATH!".

    exit /b 0
)


:: 列出已安装的 JDK
if "%1"=="list" (
    echo Installed JDKs in "%JDK_DIR%":
    dir /b "%JDK_DIR%"
    exit /b 0
)

:: 切换 JDK
if "%1"=="use" (
    if "%2"=="" (
        echo Usage: javarv use ^<version^>
        exit /b 1
    )
    set JDK_PATH=%JDK_DIR%\%2
    if not exist "!JDK_PATH!" (
        echo JDK version %2 not found. Please install it first.
        exit /b 1
    )
    setx JAVA_HOME "!JDK_PATH!" /M >nul
    setx PATH "%PATH%;%%JAVA_HOME%%\bin" /M
    echo Switched to JDK %2.
    exit /b 0
)

:: 处理 links 命令
if "%1"=="links" (
    if "%2"=="all" (
        for /f "tokens=1,2" %%A in (%LINKS_FILE%) do echo %%A %%B
    ) else (
        for /f "tokens=1" %%A in (%LINKS_FILE%) do echo %%A
        exit /b 1
    )
    exit /b 0
)

if "%1"=="bind" (
    if "%2"=="" (
        echo Usage: jdkrv bind ^<name^> ^<path^>
        exit /b 1
    )
    if "%3"=="" (
        echo Usage: jdkrv bind ^<name^> ^<path^>
        exit /b 1
    )

    set "BIND_NAME=%2"
    set "BIND_PATH=%3"

    if not exist "!BIND_PATH!\bin\java.exe" (
        echo Error: No JDK found at "%BIND_PATH%".
        exit /b 1
    )

    echo !BIND_NAME!=!BIND_PATH! >> "!LIST_FILE!"
    echo JDK "!BIND_NAME!" bound to "!BIND_PATH!".
    exit /b 0
)

:: 显示 jdkrv 版本信息
if "%1"=="version" (
    echo javarv version 1.2.0
    echo Author: jRan
    echo Repository: https://github.com/userjiangran/jdkrv.git,https://gitee.com/jiang-ran456/jdk-version-control-tool.git
    exit /b 0
)

:: 帮助信息
if "%1"=="" (
    echo Usage: javarv ^<command^> [options]
    echo Commands:
    echo   init                Initialize jdkrv environment and create conf.jdkrv
    echo   install ^<version^>   Install a specific JDK version
    echo   use ^<version^>       Switch to a specific JDK version
    echo   list                List all installed JDK versions
    echo   links               Lists all downloadable JDKS
    echo   links all           Lists all downloadable JDKS and download links
    echo   installation path: %~dp0
    exit /b 0
)
