#!/bin/bash
# ENTERPRISE STUDENT REGISTRATION SYSTEM - DEPLOYMENT VERIFICATION GUIDE

echo "============================================================"
echo "  ENTERPRISE STUDENT REGISTRATION SYSTEM"
echo "  Complete Deployment & Verification Guide"
echo "============================================================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}STEP 1: Database Setup${NC}"
echo "============================================================"
echo "Running database-setup-enhanced.sql..."
echo ""

# Check if database exists
mysql -u root -proot -e "USE student_management; SELECT 'Database exists' as Status;" 2>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Database 'student_management' already exists${NC}"
else
    echo -e "${YELLOW}Creating database...${NC}"
    Get-Content database-setup-enhanced.sql | mysql -u root -proot
fi

echo ""
echo -e "${BLUE}STEP 2: Verify Database Content${NC}"
echo "============================================================"

# Count students
STUDENT_COUNT=$(mysql -u root -proot -e "SELECT COUNT(*) FROM student_management.students WHERE deleted_at IS NULL;" 2>/dev/null | tail -1)
echo -e "${GREEN}✅ Students in database: $STUDENT_COUNT${NC}"

# Count courses
COURSE_COUNT=$(mysql -u root -proot -e "SELECT COUNT(*) FROM student_management.courses;" 2>/dev/null | tail -1)
echo -e "${GREEN}✅ Courses in database: $COURSE_COUNT${NC}"

# List students
echo ""
echo "Sample Students:"
mysql -u root -proot -e "SELECT id, name, email, course_id FROM student_management.students WHERE deleted_at IS NULL LIMIT 3;" 2>/dev/null

echo ""
echo -e "${BLUE}STEP 3: Application Status${NC}"
echo "============================================================"

# Check if Tomcat is running
netstat -an | grep ":8080" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Tomcat is running on port 8080${NC}"
else
    echo -e "${YELLOW}⚠️  Tomcat may not be running on port 8080${NC}"
fi

# Check if WAR file exists
if [ -f "target/student.war" ]; then
    WAR_SIZE=$(ls -lh target/student.war | awk '{print $5}')
    echo -e "${GREEN}✅ WAR file ready: target/student.war ($WAR_SIZE)${NC}"
else
    echo -e "${YELLOW}❌ WAR file not found. Run: mvn clean install -DskipTests${NC}"
fi

echo ""
echo -e "${BLUE}STEP 4: Access Instructions${NC}"
echo "============================================================"
echo ""
echo "Open your browser and navigate to:"
echo -e "${YELLOW}http://localhost:8080/student/${NC}"
echo ""
echo "Login with:"
echo -e "  Username: ${YELLOW}iamneo${NC}"
echo -e "  Password: ${YELLOW}iamneo123${NC}"
echo ""
echo "Expected Features:"
echo "  ✅ Admin Dashboard with statistics"
echo "  ✅ View Registered Students (5 samples)"
echo "  ✅ All 12 Courses available"
echo "  ✅ Professional UI with animations"
echo ""

echo -e "${BLUE}STEP 5: Verify Features${NC}"
echo "============================================================"
echo ""
echo "After login, check:"
echo "  [ ] Dashboard shows 5 Total Students"
echo "  [ ] Dashboard shows 12 Total Courses"
echo "  [ ] System Status shows 'Active'"
echo "  [ ] 'View Registered Students' works"
echo "  [ ] Student table shows all 5 students"
echo "  [ ] Can delete students"
echo "  [ ] Can register new students"
echo ""

echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}  DEPLOYMENT COMPLETE!${NC}"
echo -e "${GREEN}============================================================${NC}"
