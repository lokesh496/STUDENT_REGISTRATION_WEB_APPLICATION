@echo off
echo =====================================================
echo INSERTING TEST DATA TO NEON DATABASE
echo =====================================================

set DB_HOST=ep-curly-art-a456yhbk-pooler.us-east-1.aws.neon.tech
set DB_NAME=neondb
set DB_USER=neondb_owner
set DB_PASSWORD=npg_KpDh4oXLFAG8

echo Connecting to Neon and inserting test data...
psql "postgresql://%DB_USER%:%DB_PASSWORD%@%DB_HOST%/%DB_NAME%?sslmode=require" -f quick-test-insert.sql

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ Test data inserted successfully!
    echo.
    echo You can verify by visiting: http://localhost:8080/student/dbverify.jsp
) else (
    echo.
    echo ❌ Failed to insert test data
    echo Make sure PostgreSQL client is installed and Neon database is accessible
)

pause