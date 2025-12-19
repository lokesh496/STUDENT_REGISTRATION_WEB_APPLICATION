-- =====================================================
-- STUDENT MANAGEMENT SYSTEM - NEON POSTGRESQL SCHEMA
-- =====================================================

-- Drop existing tables if they exist
DROP TABLE IF EXISTS audit_log CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS admin CASCADE;
DROP TABLE IF EXISTS courses CASCADE;

-- =====================================================
-- ADMIN TABLE (for secure authentication)
-- =====================================================
CREATE TABLE admin (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE INDEX idx_admin_username ON admin(username);
CREATE INDEX idx_admin_email ON admin(email);

-- =====================================================
-- COURSES TABLE (normalize course data)
-- =====================================================
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_course_name ON courses(course_name);

-- =====================================================
-- STUDENTS TABLE (enhanced with soft delete and metadata)
-- =====================================================
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    course_id INTEGER NOT NULL,
    phone VARCHAR(15),
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    notes TEXT,
    
    -- Foreign key constraint
    CONSTRAINT fk_course FOREIGN KEY (course_id) REFERENCES courses(id)
);

-- Indexes for better query performance
CREATE INDEX idx_students_email ON students(email);
CREATE INDEX idx_students_name ON students(name);
CREATE INDEX idx_students_status ON students(status);
CREATE INDEX idx_students_created_at ON students(created_at);
CREATE INDEX idx_students_course_id ON students(course_id);
CREATE INDEX idx_students_deleted_at ON students(deleted_at);

-- =====================================================
-- AUDIT LOG TABLE (track all actions)
-- =====================================================
CREATE TABLE audit_log (
    id SERIAL PRIMARY KEY,
    admin_id INTEGER,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id INTEGER,
    details JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_admin FOREIGN KEY (admin_id) REFERENCES admin(id)
);

CREATE INDEX idx_audit_admin_id ON audit_log(admin_id);
CREATE INDEX idx_audit_action ON audit_log(action);
CREATE INDEX idx_audit_created_at ON audit_log(created_at);

-- =====================================================
-- INSERT DEFAULT COURSES
-- =====================================================
INSERT INTO courses (course_name, description) VALUES
('Java', 'Core Java programming and advanced concepts'),
('Python', 'Python programming and data science'),
('C', 'C programming fundamentals'),
('C++', 'Object-oriented programming in C++'),
('DSA', 'Data Structures and Algorithms'),
('HTML', 'HyperText Markup Language'),
('CSS', 'Cascading Style Sheets'),
('JavaScript', 'Web development with JavaScript'),
('React', 'React.js frontend framework'),
('Spring Boot', 'Enterprise Java development'),
('Node.js', 'Backend JavaScript runtime'),
('SQL', 'Database and SQL programming');

-- =====================================================
-- INSERT DEFAULT ADMIN (password: iamneo123)
-- Password hash for: iamneo123
-- =====================================================
INSERT INTO admin (username, password_hash, email, is_active) VALUES
('iamneo', 'kVKB7E1FO5o7NqvJPXqjfPvVwPdIzs+OjYL5FuOQhyNKQc3cKRScKEpuM+p6FYpQ', 'admin@studentregistration.com', TRUE);

-- =====================================================
-- INSERT SAMPLE DATA
-- =====================================================
INSERT INTO students (name, email, course_id, phone, status, notes) VALUES
('John Doe', 'john.doe@example.com', 1, '9876543210', 'ACTIVE', 'Excellent student'),
('Jane Smith', 'jane.smith@example.com', 2, '9876543211', 'ACTIVE', 'Very attentive'),
('Robert Johnson', 'robert.j@example.com', 4, '9876543212', 'ACTIVE', 'Needs improvement'),
('Emily Davis', 'emily.davis@example.com', 3, '9876543213', 'ACTIVE', 'Good progress'),
('Michael Brown', 'michael.brown@example.com', 1, '9876543214', 'ACTIVE', 'Outstanding performance');

-- =====================================================
-- CREATE TRIGGER FOR UPDATED_AT
-- =====================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_students_updated_at 
    BEFORE UPDATE ON students 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- VERIFY SETUP
-- =====================================================
SELECT 'Tables created successfully' as status;
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
SELECT COUNT(*) as course_count FROM courses;
SELECT COUNT(*) as student_count FROM students;
SELECT COUNT(*) as admin_count FROM admin;