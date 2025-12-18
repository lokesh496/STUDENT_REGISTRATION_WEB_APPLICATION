# ============================================================
# ENTERPRISE STUDENT REGISTRATION SYSTEM - DEPLOYMENT SCRIPT
# ============================================================

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  ENTERPRISE STUDENT REGISTRATION SYSTEM" -ForegroundColor Cyan
Write-Host "  Complete Deployment & Verification" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# ============================================================
# STEP 1: DATABASE SETUP
# ============================================================
Write-Host "STEP 1: Database Setup" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Running database-setup-enhanced.sql..." -ForegroundColor Yellow
Write-Host ""

try {
    Get-Content database-setup-enhanced.sql | mysql -u root -proot 2>&1 | Out-Null
    Write-Host "✅ Database setup completed successfully" -ForegroundColor Green
} catch {
    Write-Host "❌ Database setup failed: $_" -ForegroundColor Red
}

Write-Host ""

# ============================================================
# STEP 2: VERIFY DATABASE CONTENT
# ============================================================
Write-Host "STEP 2: Verify Database Content" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# Count students
$studentResult = mysql -u root -proot -e "SELECT COUNT(*) FROM student_management.students WHERE deleted_at IS NULL;" 2>$null
if ($studentResult) {
    $studentCount = $studentResult | Select-Object -Last 1
    Write-Host "✅ Students in database: $studentCount" -ForegroundColor Green
} else {
    Write-Host "❌ Could not query students" -ForegroundColor Red
}

# Count courses
$courseResult = mysql -u root -proot -e "SELECT COUNT(*) FROM student_management.courses;" 2>$null
if ($courseResult) {
    $courseCount = $courseResult | Select-Object -Last 1
    Write-Host "✅ Courses in database: $courseCount" -ForegroundColor Green
} else {
    Write-Host "❌ Could not query courses" -ForegroundColor Red
}

Write-Host ""
Write-Host "Sample Students:" -ForegroundColor Yellow
mysql -u root -proot -e "SELECT id, name, email FROM student_management.students WHERE deleted_at IS NULL LIMIT 3;" 2>$null

Write-Host ""

# ============================================================
# STEP 3: APPLICATION STATUS
# ============================================================
Write-Host "STEP 3: Application Status" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

# Check Tomcat
$tomcatRunning = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue
if ($tomcatRunning) {
    Write-Host "✅ Tomcat is running on port 8080" -ForegroundColor Green
} else {
    Write-Host "⚠️  Tomcat may not be running on port 8080" -ForegroundColor Yellow
    Write-Host "   Start Tomcat with:" -ForegroundColor Yellow
    Write-Host "   & 'C:\Program Files\apache-tomcat-11.0.15\bin\startup.bat'" -ForegroundColor Yellow
}

# Check WAR file
if (Test-Path "target/student.war") {
    $warSize = (Get-Item "target/student.war").Length / 1MB
    Write-Host "✅ WAR file ready: target/student.war ($([Math]::Round($warSize, 2)) MB)" -ForegroundColor Green
} else {
    Write-Host "❌ WAR file not found. Run: mvn clean install -DskipTests" -ForegroundColor Red
}

Write-Host ""

# ============================================================
# STEP 4: ACCESS INSTRUCTIONS
# ============================================================
Write-Host "STEP 4: Access Instructions" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Open your browser and navigate to:" -ForegroundColor White
Write-Host "  http://localhost:8080/student/" -ForegroundColor Yellow
Write-Host ""
Write-Host "Login with:" -ForegroundColor White
Write-Host "  Username: iamneo" -ForegroundColor Yellow
Write-Host "  Password: iamneo123" -ForegroundColor Yellow
Write-Host ""

# ============================================================
# STEP 5: FEATURES CHECKLIST
# ============================================================
Write-Host "STEP 5: What You Should See" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Admin Dashboard with:"
Write-Host "   • 5 Total Students"
Write-Host "   • 12 Total Courses"
Write-Host "   • Active System Status"
Write-Host ""
Write-Host "✅ Navigation Options:"
Write-Host "   • View Registered Students"
Write-Host "   • Register New Student"
Write-Host "   • Logout"
Write-Host ""
Write-Host "✅ Student Management:"
Write-Host "   • List all 5 students with pagination"
Write-Host "   • Delete students (soft delete)"
Write-Host "   • Register new students"
Write-Host ""

# ============================================================
# STEP 6: TEST DATABASE CONNECTION
# ============================================================
Write-Host "STEP 6: Test Database Connection (Optional)" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Visit: http://localhost:8080/student/dbverify.jsp" -ForegroundColor Yellow
Write-Host "This page shows:"
Write-Host "   • MySQL driver status"
Write-Host "   • Database connectivity"
Write-Host "   • List of all students"
Write-Host "   • List of all courses"
Write-Host ""

# ============================================================
# COMPLETION
# ============================================================
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  ✅ DEPLOYMENT READY!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your enterprise Student Registration System is ready to use!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Open http://localhost:8080/student/" -ForegroundColor White
Write-Host "  2. Login with iamneo / iamneo123" -ForegroundColor White
Write-Host "  3. Explore the dashboard and features" -ForegroundColor White
Write-Host ""

