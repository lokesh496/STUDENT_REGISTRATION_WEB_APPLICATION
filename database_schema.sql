-- Student Registration Web Application Database Schema
-- PostgreSQL Database Tables - COMPLETE SCHEMA

-- 1. COURSES Table (Must be created first for foreign key)
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) UNIQUE NOT NULL,
    course_code VARCHAR(20) UNIQUE,
    description TEXT,
    duration VARCHAR(50),
    fee DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. STUDENTS Table (Main table - references courses)
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    course_id INTEGER REFERENCES courses(id),
    phone VARCHAR(15),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    notes TEXT
);

-- 3. ADMIN Table (For admin authentication)
CREATE TABLE admin (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(150),
    full_name VARCHAR(100),
    role VARCHAR(20) DEFAULT 'ADMIN',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- Insert sample courses
INSERT INTO courses (course_name, course_code, description, duration, fee) VALUES
('Java Full Stack Development', 'JAVA-FS', 'Complete Java development with Spring Boot and React', '6 months', 25000.00),
('Python Data Science', 'PY-DS', 'Python programming with data analysis and machine learning', '4 months', 20000.00),
('Web Development', 'WEB-DEV', 'HTML, CSS, JavaScript and modern frameworks', '3 months', 15000.00),
('Mobile App Development', 'MOBILE', 'Android and iOS app development', '5 months', 22000.00),
('DevOps Engineering', 'DEVOPS', 'CI/CD, Docker, Kubernetes and cloud technologies', '4 months', 28000.00),
('Data Analytics', 'DATA-AN', 'Business intelligence and data visualization', '3 months', 18000.00),
('Cybersecurity', 'CYBER', 'Information security and ethical hacking', '5 months', 30000.00),
('Cloud Computing', 'CLOUD', 'AWS, Azure, and Google Cloud Platform', '4 months', 26000.00);

-- Insert default admin user (password: iamneo123)
INSERT INTO admin (username, password_hash, email, full_name) 
VALUES ('iamneo', '$2a$10$N9qo8uLOickgx2ZMRZoMye', 'admin@student.com', 'System Administrator');

-- Create indexes for better performance
CREATE INDEX idx_students_email ON students(email);
CREATE INDEX idx_students_status ON students(status);
CREATE INDEX idx_students_course_id ON students(course_id);
CREATE INDEX idx_students_created_at ON students(created_at);
CREATE INDEX idx_students_deleted_at ON students(deleted_at);
CREATE INDEX idx_courses_name ON courses(course_name);
CREATE INDEX idx_admin_username ON admin(username);

-- Create triggers for updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_students_updated_at BEFORE UPDATE ON students
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();