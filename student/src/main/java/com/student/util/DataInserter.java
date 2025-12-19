package com.student.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DataInserter {
    
    public static void insertTestData() {
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("✅ Connected to Neon database");
            
            // Insert test courses
            String courseSql = "INSERT INTO courses (course_name, description) VALUES (?, ?) ON CONFLICT (course_name) DO NOTHING";
            try (PreparedStatement ps = conn.prepareStatement(courseSql)) {
                ps.setString(1, "Test Course");
                ps.setString(2, "Test course for verification");
                ps.executeUpdate();
                System.out.println("✅ Test course inserted");
            }
            
            // Get course ID
            int courseId = 1;
            try (PreparedStatement ps = conn.prepareStatement("SELECT id FROM courses WHERE course_name = ?")) {
                ps.setString(1, "Test Course");
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    courseId = rs.getInt("id");
                }
            }
            
            // Insert test student
            String studentSql = "INSERT INTO students (name, email, course_id, phone, status) VALUES (?, ?, ?, ?, ?) ON CONFLICT (email) DO NOTHING";
            try (PreparedStatement ps = conn.prepareStatement(studentSql)) {
                ps.setString(1, "Test Student");
                ps.setString(2, "test@example.com");
                ps.setInt(3, courseId);
                ps.setString(4, "1234567890");
                ps.setString(5, "ACTIVE");
                ps.executeUpdate();
                System.out.println("✅ Test student inserted");
            }
            
            // Verify data
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM students")) {
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    System.out.println("📊 Total students: " + rs.getInt(1));
                }
            }
            
            System.out.println("🎉 Test data insertion completed!");
            
        } catch (Exception e) {
            System.err.println("❌ Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    public static void main(String[] args) {
        insertTestData();
    }
}