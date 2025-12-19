@echo off
echo =====================================================
echo STARTING TOMCAT SERVER
echo =====================================================

echo Looking for Tomcat installation...

REM Common Tomcat installation paths
set TOMCAT_PATHS[0]="C:\Program Files\Apache Software Foundation\Tomcat 11.0"
set TOMCAT_PATHS[1]="C:\Program Files\Apache Software Foundation\Tomcat 10.1"
set TOMCAT_PATHS[2]="C:\apache-tomcat-11.0.15"
set TOMCAT_PATHS[3]="C:\tomcat"
set TOMCAT_PATHS[4]="D:\tomcat"

for %%i in (0,1,2,3,4) do (
    if exist !TOMCAT_PATHS[%%i]!\bin\startup.bat (
        echo Found Tomcat at: !TOMCAT_PATHS[%%i]!
        set CATALINA_HOME=!TOMCAT_PATHS[%%i]!
        goto :start_tomcat
    )
)

echo ❌ Tomcat not found in common locations
echo Please manually start Tomcat or update the paths in this script
pause
exit /b 1

:start_tomcat
echo Starting Tomcat from: %CATALINA_HOME%
cd /d "%CATALINA_HOME%\bin"
call startup.bat

echo.
echo ✅ Tomcat startup initiated
echo Wait 10-15 seconds, then test: http://localhost:8080/student/test-db
echo.
pause