/*
 * Decompiled with CFR 0.152.
 */
package com.student.dao;

import com.student.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CourseDao {
    public int getCourseCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM courses";
        try (Connection con = DBConnection.getConnection();
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

