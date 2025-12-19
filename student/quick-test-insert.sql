-- Quick test data insertion for Neon database verification

-- Insert test courses (ignore if already exists)
INSERT INTO courses (course_name, description) VALUES 
('Test Java', 'Test Java course for verification'),
('Test Python', 'Test Python course for verification')
ON CONFLICT (course_name) DO NOTHING;

-- Insert test students (ignore if already exists)
INSERT INTO students (name, email, course_id, phone, status, notes) VALUES 
('Alice Johnson', 'alice.test@example.com', 1, '9999999991', 'ACTIVE', 'Test student 1'),
('Bob Smith', 'bob.test@example.com', 2, '9999999992', 'ACTIVE', 'Test student 2'),
('Carol Davis', 'carol.test@example.com', 1, '9999999993', 'ACTIVE', 'Test student 3')
ON CONFLICT (email) DO NOTHING;

-- Verify insertion
SELECT 'Data insertion completed' as status;
SELECT COUNT(*) as total_courses FROM courses;
SELECT COUNT(*) as total_students FROM students WHERE deleted_at IS NULL;

-- Show recent test data
SELECT s.name, s.email, c.course_name, s.status 
FROM students s 
JOIN courses c ON s.course_id = c.id 
WHERE s.email LIKE '%.test@%' 
ORDER BY s.created_at DESC;