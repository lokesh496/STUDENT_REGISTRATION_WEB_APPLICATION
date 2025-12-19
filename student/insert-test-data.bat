@echo off
echo =====================================================
echo INSERTING TEST DATA TO NEON DATABASE
echo =====================================================

cd /d "%~dp0"

echo Compiling DataInserter...
javac -cp "target\student\WEB-INF\lib\*;target\classes" src\main\java\com\student\util\DataInserter.java -d target\classes

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Compilation failed
    pause
    exit /b 1
)

echo Running DataInserter...
java -cp "target\student\WEB-INF\lib\*;target\classes" com.student.util.DataInserter

pause