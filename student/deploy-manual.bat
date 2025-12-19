@echo off
echo =====================================================
echo MANUAL DEPLOYMENT TO TOMCAT
echo =====================================================

echo Step 1: Extract WAR file manually...
cd /d "%~dp0"

REM Create student directory in webapps
mkdir "C:\Program Files\Apache Software Foundation\Tomcat 11.0\webapps\student" 2>nul

REM Extract WAR using jar command
echo Extracting student.war...
cd "C:\Program Files\Apache Software Foundation\Tomcat 11.0\webapps\student"
jar -xf "%~dp0target\student.war"

if %ERRORLEVEL% EQU 0 (
    echo ✅ WAR extracted successfully
    echo.
    echo Now restart Tomcat and test:
    echo http://localhost:8080/student/admin.jsp
) else (
    echo ❌ Extraction failed
    echo Try copying files manually or check Tomcat path
)

pause