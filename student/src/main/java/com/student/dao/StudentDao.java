/*
 * Decompiled with CFR 0.152.
 */
package com.student.dao;

import com.student.model.Student;
import com.student.util.DBConnection;
import com.student.util.LoggerConfig;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class StudentDao {
    private static final Logger logger = LoggerConfig.getLogger(StudentDao.class);

    /*
     * Enabled aggressive block sorting
     * Enabled unnecessary exception pruning
     * Enabled aggressive exception aggregation
     */
    public boolean addStudent(Student student) {
        String sql = "INSERT INTO students(name, email, course_id, phone, status, created_at) SELECT ?, ?, id, ?, ?, NOW() FROM courses WHERE course_name = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);){
            PreparedStatement ps2;
            block39: {
                ps.setString(1, student.getName());
                ps.setString(2, student.getEmail());
                ps.setString(3, student.getPhone() != null ? student.getPhone() : "");
                ps.setString(4, "ACTIVE");
                ps.setString(5, student.getCourse());
                int result = ps.executeUpdate();
                if (result > 0) {
                    logger.log(Level.INFO, "\u2705 Student registered: " + student.getEmail());
                    boolean bl = true;
                    return bl;
                }
                logger.log(Level.INFO, "No rows inserted - checking if course exists or needs creation");
                try (PreparedStatement createCourse = con.prepareStatement("INSERT INTO courses(course_name) VALUES(?)");){
                    createCourse.setString(1, student.getCourse());
                    try {
                        createCourse.executeUpdate();
                        logger.log(Level.INFO, "Created missing course: " + student.getCourse());
                    }
                    catch (SQLException ce) {
                        logger.log(Level.FINE, "Course insert may have failed (already exists): " + ce.getMessage());
                    }
                }
                catch (Exception e) {
                    logger.log(Level.WARNING, "Could not create missing course: " + student.getCourse(), e);
                }
                try {
                    boolean bl;
                    ps2 = con.prepareStatement(sql);
                    try {
                        ps2.setString(1, student.getName());
                        ps2.setString(2, student.getEmail());
                        ps2.setString(3, student.getPhone() != null ? student.getPhone() : "");
                        ps2.setString(4, "ACTIVE");
                        ps2.setString(5, student.getCourse());
                        int retry = ps2.executeUpdate();
                        if (retry <= 0) break block39;
                        logger.log(Level.INFO, "\u2705 Student registered on retry: " + student.getEmail());
                        bl = true;
                        if (ps2 == null) return bl;
                    }
                    catch (Throwable throwable) {
                        if (ps2 == null) throw throwable;
                        try {
                            ps2.close();
                            throw throwable;
                        }
                        catch (Throwable throwable2) {
                            throwable.addSuppressed(throwable2);
                        }
                        throw throwable;
                    }
                    ps2.close();
                    return bl;
                }
                catch (Exception e) {
                    logger.log(Level.SEVERE, "\u274c Retry inserting student failed", e);
                    return false;
                }
            }
            if (ps2 == null) return false;
            ps2.close();
            return false;
        }
        catch (SQLException e) {
            if (e.getErrorCode() == 1062) {
                logger.log(Level.WARNING, "\u26a0\ufe0f Duplicate email: " + student.getEmail());
                return false;
            }
            logger.log(Level.SEVERE, "\u274c Error adding student", e);
            return false;
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Database error", e);
        }
        return false;
    }

    public List<Student> getAllStudents(int page, int recordsPerPage) {
        ArrayList<Student> list = new ArrayList<Student>();
        String sql = "SELECT s.id, s.name, s.email, s.course_id, c.course_name, s.phone, s.status, s.created_at, s.updated_at, s.notes FROM students s JOIN courses c ON s.course_id = c.id WHERE s.deleted_at IS NULL AND s.status = ? ORDER BY s.created_at DESC LIMIT ? OFFSET ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);){
            ps.setString(1, "ACTIVE");
            ps.setInt(2, recordsPerPage);
            ps.setInt(3, (page - 1) * recordsPerPage);
            try (ResultSet rs = ps.executeQuery();){
                while (rs.next()) {
                    Student student = this.mapResultSetToStudent(rs);
                    list.add(student);
                }
                logger.log(Level.INFO, "\ud83d\udcdd Fetched " + list.size() + " students (page " + page + ")");
            }
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Error fetching students", e);
        }
        return list;
    }

    /*
     * Enabled aggressive block sorting
     * Enabled unnecessary exception pruning
     * Enabled aggressive exception aggregation
     */
    public int getActiveStudentCount() {
        String sql = "SELECT COUNT(*) FROM students WHERE deleted_at IS NULL AND status = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);){
            ps.setString(1, "ACTIVE");
            try (ResultSet rs = ps.executeQuery();){
                if (!rs.next()) return 0;
                int n = rs.getInt(1);
                return n;
            }
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Error getting student count", e);
        }
        return 0;
    }

    public List<Student> getStudentsByCourse(String courseName, int page, int recordsPerPage) {
        ArrayList<Student> list = new ArrayList<Student>();
        String sql = "SELECT s.id, s.name, s.email, s.course_id, c.course_name, s.phone, s.status, s.created_at, s.updated_at, s.notes FROM students s JOIN courses c ON s.course_id = c.id WHERE c.course_name = ? AND s.deleted_at IS NULL AND s.status = ? ORDER BY s.name ASC LIMIT ? OFFSET ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);){
            ps.setString(1, courseName);
            ps.setString(2, "ACTIVE");
            ps.setInt(3, recordsPerPage);
            ps.setInt(4, (page - 1) * recordsPerPage);
            try (ResultSet rs = ps.executeQuery();){
                while (rs.next()) {
                    list.add(this.mapResultSetToStudent(rs));
                }
            }
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Error fetching students by course", e);
        }
        return list;
    }

    public List<Student> searchStudents(String searchTerm, int page, int recordsPerPage) {
        ArrayList<Student> list = new ArrayList<Student>();
        String sql = "SELECT s.id, s.name, s.email, s.course_id, c.course_name, s.phone, s.status, s.created_at, s.updated_at, s.notes FROM students s JOIN courses c ON s.course_id = c.id WHERE s.deleted_at IS NULL AND s.status = ? AND (s.name LIKE ? OR s.email LIKE ? OR c.course_name LIKE ?) ORDER BY s.name ASC LIMIT ? OFFSET ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);){
            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, "ACTIVE");
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ps.setInt(5, recordsPerPage);
            ps.setInt(6, (page - 1) * recordsPerPage);
            try (ResultSet rs = ps.executeQuery();){
                while (rs.next()) {
                    list.add(this.mapResultSetToStudent(rs));
                }
                logger.log(Level.INFO, "\ud83d\udd0d Search results: " + list.size() + " students found");
            }
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Error searching students", e);
        }
        return list;
    }

    /*
     * Enabled aggressive block sorting
     * Enabled unnecessary exception pruning
     * Enabled aggressive exception aggregation
     */
    public Student getStudentById(int id) {
        String sql = "SELECT s.id, s.name, s.email, s.course_id, c.course_name, s.phone, s.status, s.created_at, s.updated_at, s.notes FROM students s JOIN courses c ON s.course_id = c.id WHERE s.id = ? AND s.deleted_at IS NULL";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);){
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery();){
                if (!rs.next()) return null;
                Student student = this.mapResultSetToStudent(rs);
                return student;
            }
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Error fetching student by ID", e);
        }
        return null;
    }

    /*
     * Enabled aggressive block sorting
     * Enabled unnecessary exception pruning
     * Enabled aggressive exception aggregation
     */
    public boolean updateStudent(Student student) {
        String sql = "UPDATE students SET name = ?, email = ?, phone = ?, notes = ? WHERE id = ? AND deleted_at IS NULL";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);){
            ps.setString(1, student.getName());
            ps.setString(2, student.getEmail());
            ps.setString(3, student.getPhone() != null ? student.getPhone() : "");
            ps.setString(4, student.getNotes() != null ? student.getNotes() : "");
            ps.setInt(5, student.getId());
            int result = ps.executeUpdate();
            if (result <= 0) return false;
            logger.log(Level.INFO, "\u2705 Student updated: " + student.getName());
            boolean bl = true;
            return bl;
        }
        catch (SQLException e) {
            if (e.getErrorCode() == 1062) {
                logger.log(Level.WARNING, "\u26a0\ufe0f Duplicate email: " + student.getEmail());
                return false;
            }
            logger.log(Level.SEVERE, "\u274c Error updating student", e);
            return false;
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Database error", e);
        }
        return false;
    }

    /*
     * Enabled aggressive block sorting
     * Enabled unnecessary exception pruning
     * Enabled aggressive exception aggregation
     */
    public boolean deleteStudent(int id) {
        String sql = "UPDATE students SET deleted_at = NOW(), status = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);){
            ps.setString(1, "INACTIVE");
            ps.setInt(2, id);
            int result = ps.executeUpdate();
            if (result <= 0) return false;
            logger.log(Level.INFO, "\u2705 Student soft deleted (ID: " + id + ")");
            boolean bl = true;
            return bl;
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Error deleting student", e);
        }
        return false;
    }

    public List<Student> getRecentStudents(int limit) {
        ArrayList<Student> list = new ArrayList<Student>();
        String sql = "SELECT s.id, s.name, s.email, s.course_id, c.course_name, s.phone, s.status, s.created_at, s.updated_at, s.notes FROM students s JOIN courses c ON s.course_id = c.id WHERE s.deleted_at IS NULL AND s.status = ? ORDER BY s.created_at DESC LIMIT ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);){
            ps.setString(1, "ACTIVE");
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery();){
                while (rs.next()) {
                    list.add(this.mapResultSetToStudent(rs));
                }
            }
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Error fetching recent students", e);
        }
        return list;
    }

    public List<String[]> getStudentsPerCourse() {
        ArrayList<String[]> data = new ArrayList<String[]>();
        String sql = "SELECT c.course_name, COUNT(s.id) as count FROM courses c LEFT JOIN students s ON c.id = s.course_id AND s.deleted_at IS NULL GROUP BY c.id, c.course_name ORDER BY count DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery();){
            while (rs.next()) {
                data.add(new String[]{rs.getString("course_name"), rs.getString("count")});
            }
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Error getting students per course", e);
        }
        return data;
    }

    private Student mapResultSetToStudent(ResultSet rs) throws SQLException {
        Timestamp updatedAt;
        Student student = new Student();
        student.setId(rs.getInt("id"));
        student.setName(rs.getString("name"));
        student.setEmail(rs.getString("email"));
        student.setCourseId(rs.getInt("course_id"));
        student.setCourse(rs.getString("course_name"));
        student.setPhone(rs.getString("phone"));
        student.setStatus(rs.getString("status"));
        student.setNotes(rs.getString("notes"));
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            student.setCreatedAt(createdAt.toLocalDateTime());
        }
        if ((updatedAt = rs.getTimestamp("updated_at")) != null) {
            student.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        return student;
    }

    /*
     * Enabled aggressive block sorting
     * Enabled unnecessary exception pruning
     * Enabled aggressive exception aggregation
     */
    public int countSearchResults(String searchTerm) {
        String sql = "SELECT COUNT(*) FROM students s JOIN courses c ON s.course_id = c.id WHERE s.deleted_at IS NULL AND (s.name LIKE ? OR s.email LIKE ? OR c.course_name LIKE ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);){
            String searchPattern = "%" + searchTerm + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            try (ResultSet rs = ps.executeQuery();){
                if (!rs.next()) return 0;
                int n = rs.getInt(1);
                return n;
            }
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Error counting search results", e);
        }
        return 0;
    }

    /*
     * Enabled aggressive block sorting
     * Enabled unnecessary exception pruning
     * Enabled aggressive exception aggregation
     */
    public int countStudentsByCourse(String course) {
        String sql = "SELECT COUNT(*) FROM students s JOIN courses c ON s.course_id = c.id WHERE s.deleted_at IS NULL AND c.course_name = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);){
            ps.setString(1, course);
            try (ResultSet rs = ps.executeQuery();){
                if (!rs.next()) return 0;
                int n = rs.getInt(1);
                return n;
            }
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Error counting students by course", e);
        }
        return 0;
    }

    /*
     * Enabled aggressive block sorting
     * Enabled unnecessary exception pruning
     * Enabled aggressive exception aggregation
     */
    public int getTotalStudentCount() {
        String sql = "SELECT COUNT(*) FROM students";
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql);){
            if (!rs.next()) return 0;
            int n = rs.getInt(1);
            return n;
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Error getting total student count", e);
        }
        return 0;
    }

    /*
     * Enabled aggressive block sorting
     * Enabled unnecessary exception pruning
     * Enabled aggressive exception aggregation
     */
    public int getDeletedStudentCount() {
        String sql = "SELECT COUNT(*) FROM students WHERE deleted_at IS NOT NULL";
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql);){
            if (!rs.next()) return 0;
            int n = rs.getInt(1);
            return n;
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Error getting deleted student count", e);
        }
        return 0;
    }

    public Map<String, Integer> getCourseDistribution() {
        LinkedHashMap<String, Integer> distribution = new LinkedHashMap<String, Integer>();
        String sql = "SELECT c.course_name, COUNT(s.id) as count FROM courses c LEFT JOIN students s ON c.id = s.course_id AND s.deleted_at IS NULL GROUP BY c.id, c.course_name ORDER BY count DESC";
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(sql);){
            while (rs.next()) {
                distribution.put(rs.getString("course_name"), rs.getInt("count"));
            }
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Error getting course distribution", e);
        }
        return distribution;
    }

    public List<Student> getAllStudentsForExport() {
        ArrayList<Student> list = new ArrayList<Student>();
        String sql = "SELECT s.id, s.name, s.email, s.course_id, c.course_name, s.phone, s.status, s.created_at, s.updated_at, s.notes FROM students s JOIN courses c ON s.course_id = c.id WHERE s.deleted_at IS NULL ORDER BY s.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery();){
            while (rs.next()) {
                list.add(this.mapResultSetToStudent(rs));
            }
            logger.log(Level.INFO, "\ud83d\udce5 Exported " + list.size() + " students");
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Error exporting students", e);
        }
        return list;
    }
}

