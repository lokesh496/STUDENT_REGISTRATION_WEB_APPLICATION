@echo off
echo =====================================================
echo NEON DATABASE SETUP SCRIPT
echo =====================================================

echo.
echo 1. Make sure you have PostgreSQL client (psql) installed
echo 2. Your Neon database should be running
echo 3. Update the connection details below if needed
echo.

set DB_HOST=ep-curly-art-a456yhbk-pooler.us-east-1.aws.neon.tech
set DB_NAME=neondb
set DB_USER=neondb_owner
set DB_PASSWORD=npg_KpDh4oXLFAG8

echo Connecting to Neon database...
echo Host: %DB_HOST%
echo Database: %DB_NAME%
echo User: %DB_USER%
echo.

echo Running PostgreSQL schema setup...
psql "postgresql://%DB_USER%:%DB_PASSWORD%@%DB_HOST%/%DB_NAME%?sslmode=require" -f neon-database-setup.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ Database setup completed successfully!
    echo.
    echo You can now test the connection by visiting:
    echo http://localhost:8080/student/dbverify.jsp
    echo.
) else (
    echo.
    echo ❌ Database setup failed!
    echo.
    echo Troubleshooting steps:
    echo 1. Check if PostgreSQL client is installed: psql --version
    echo 2. Verify your Neon database credentials
    echo 3. Check network connectivity to Neon
    echo 4. Ensure your Neon database is not suspended
    echo.
)

pause