-- =====================================================
-- STUDENT MANAGEMENT SYSTEM - ENHANCED DATABASE SCHEMA
-- =====================================================

-- Create Database
DROP DATABASE IF EXISTS student_management;
CREATE DATABASE student_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE student_management;

-- =====================================================
-- ADMIN TABLE (for secure authentication)
-- =====================================================
CREATE TABLE IF NOT EXISTS admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE,
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- COURSES TABLE (normalize course data)
-- =====================================================
CREATE TABLE IF NOT EXISTS courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_course_name (course_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- STUDENTS TABLE (enhanced with soft delete and metadata)
-- =====================================================
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    course_id INT NOT NULL,
    phone VARCHAR(15),
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    notes TEXT,
    
    -- Indexes for better query performance
    INDEX idx_email (email),
    INDEX idx_name (name),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    INDEX idx_course_id (course_id),
    INDEX idx_deleted_at (deleted_at),
    
    -- Foreign key constraint
    CONSTRAINT fk_course FOREIGN KEY (course_id) REFERENCES courses(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- AUDIT LOG TABLE (track all actions)
-- =====================================================
CREATE TABLE IF NOT EXISTS audit_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id INT,
    details JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_admin_id (admin_id),
    INDEX idx_action (action),
    INDEX idx_created_at (created_at),
    
    CONSTRAINT fk_admin FOREIGN KEY (admin_id) REFERENCES admin(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
-- VERIFY TABLES CREATED
-- =====================================================
SHOW TABLES;
DESCRIBE students;
DESCRIBE admin;
DESCRIBE courses;
DESCRIBE audit_log;
