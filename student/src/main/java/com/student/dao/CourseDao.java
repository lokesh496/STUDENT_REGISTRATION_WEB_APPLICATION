/*
 * Decompiled with CFR 0.152.
 */
package com.student.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CourseDao {
    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/student_management", "root", "root");
    }

    public int getCourseCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM courses";
        try (Connection con = this.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery();){
            if (rs.next()) {
                count = rs.getInt(1);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
}

