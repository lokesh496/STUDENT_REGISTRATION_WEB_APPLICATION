@echo off
REM =======================================================
REM STUDENT MANAGEMENT SYSTEM - SETUP VERIFICATION
REM =======================================================

echo.
echo ============================================================
echo  ENTERPRISE STUDENT REGISTRATION SYSTEM
echo  Setup Verification & Quick Start
echo ============================================================
echo.

echo 1. Checking Database Connection...
mysql -u root -proot -e "SELECT 'OK' FROM student_management.students LIMIT 1;" 2>nul
if %errorlevel% equ 0 (
    echo    ✅ Database is accessible
) else (
    echo    ❌ Database connection failed
    echo    Make sure MySQL is running
    pause
    exit /b 1
)

echo.
echo 2. Counting Students in Database...
for /f %%A in ('mysql -u root -proot -e "SELECT COUNT(*) FROM student_management.students WHERE deleted_at IS NULL;" 2^>nul ^| findstr /R "[0-9]"') do (
    echo    ✅ Found %%A students in database
)

echo.
echo 3. Counting Courses in Database...
for /f %%A in ('mysql -u root -proot -e "SELECT COUNT(*) FROM student_management.courses;" 2^>nul ^| findstr /R "[0-9]"') do (
    echo    ✅ Found %%A courses in database
)

echo.
echo 4. Checking Tomcat Status...
netstat -ano | findstr ":8080" >nul
if %errorlevel% equ 0 (
    echo    ✅ Tomcat is running on port 8080
) else (
    echo    ⚠️  Tomcat may not be running
)

echo.
echo ============================================================
echo  NEXT STEPS:
echo ============================================================
echo.
echo 1. Open browser: http://localhost:8080/student/
echo.
echo 2. Login with:
echo    - Username: iamneo
echo    - Password: iamneo123
echo.
echo 3. Click "View Registered Students"
echo.
echo 4. You should see 5 sample students!
echo.
echo ============================================================
echo.
pause
