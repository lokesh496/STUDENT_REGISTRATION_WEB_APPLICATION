@echo off
echo =====================================================
echo FORCE CLEAN DEPLOYMENT TO TOMCAT
echo =====================================================

echo Step 1: Building fresh WAR file...
call mvn clean package

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Build failed
    pause
    exit /b 1
)

echo.
echo Step 2: Finding Tomcat installation...

set TOMCAT_HOME=
for %%d in ("C:\Program Files\Apache Software Foundation\Tomcat*" "C:\apache-tomcat*" "C:\tomcat*") do (
    if exist "%%d\webapps" (
        set TOMCAT_HOME=%%d
        goto :found
    )
)

echo ❌ Tomcat not found. Please set TOMCAT_HOME manually.
pause
exit /b 1

:found
echo Found Tomcat at: %TOMCAT_HOME%

echo.
echo Step 3: Stopping Tomcat (if running)...
taskkill /f /im java.exe 2>nul

echo.
echo Step 4: Cleaning old deployment...
if exist "%TOMCAT_HOME%\webapps\student" rmdir /s /q "%TOMCAT_HOME%\webapps\student"
if exist "%TOMCAT_HOME%\webapps\student.war" del "%TOMCAT_HOME%\webapps\student.war"

echo.
echo Step 5: Deploying new WAR...
copy "target\student.war" "%TOMCAT_HOME%\webapps\"

echo.
echo Step 6: Starting Tomcat...
cd /d "%TOMCAT_HOME%\bin"
start startup.bat

echo.
echo ✅ Deployment complete!
echo Wait 15 seconds, then test: http://localhost:8080/student/test-connection.jsp
echo.
timeout /t 15

echo Opening test page...
start http://localhost:8080/student/test-connection.jsp

pause