@echo off
echo Testing database connection without Tomcat...

cd /d "%~dp0"

echo Compiling test class...
javac -cp "target\student\WEB-INF\lib\postgresql-42.5.1.jar" src\main\java\com\student\util\DBConnection.java -d .

echo Testing connection...
java -cp ".;target\student\WEB-INF\lib\postgresql-42.5.1.jar" -Djava.util.logging.config.file=logging.properties com.student.util.DBConnection

pause