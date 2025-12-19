@echo off
echo Testing Neon database connection directly...

cd /d "%~dp0"
javac -cp "target\student\WEB-INF\lib\*" src\main\java\com\student\util\DBConnection.java -d target\classes
java -cp "target\student\WEB-INF\lib\*;target\classes" com.student.util.DatabaseTestUtil

pause