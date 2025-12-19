package com.student.util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.Statement;

public class QuickTest {
    public static void main(String[] args) {
        System.out.println("=== NEON DATABASE CONNECTION TEST ===");
        
        try {
            Connection conn = DBConnection.getConnection();
            System.out.println("✅ Connection successful!");
            
            DatabaseMetaData meta = conn.getMetaData();
            String url = meta.getURL();
            System.out.println("Database URL: " + url);
            
            if (url.contains("neon.tech")) {
                System.out.println("SUCCESS: Connected to NEON (Postgres) database!");
            } else {
                System.out.println("WARNING: NOT connected to Neon (Postgres) database!");
            }
            
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM students");
            if (rs.next()) {
                System.out.println("Students in database: " + rs.getInt(1));
            }
            
            conn.close();
            
        } catch (Exception e) {
            System.out.println("ERROR: Connection failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}