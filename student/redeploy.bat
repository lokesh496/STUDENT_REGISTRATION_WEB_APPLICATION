@echo off
echo =====================================================
echo REDEPLOYING WITH NEW DATABASE CONFIGURATION
echo =====================================================

echo Step 1: Building project...
call mvn clean package

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Build failed
    pause
    exit /b 1
)

echo.
echo Step 2: Please manually:
echo 1. Stop Tomcat server
echo 2. Delete webapps\student folder and student.war
echo 3. Copy target\student.war to webapps\
echo 4. Start Tomcat server
echo.
echo Then test connection at:
echo http://localhost:8080/student/test-connection.jsp
echo.

pause