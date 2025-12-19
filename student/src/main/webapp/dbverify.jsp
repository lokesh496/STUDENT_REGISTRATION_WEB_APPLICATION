<%@ page import="java.sql.*" %>
<%@ page import="com.student.util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Verification</title>
    <style>
        body { font-family: Arial; background: #f5f5f5; padding: 20px; }
        .container { background: white; max-width: 800px; margin: 0 auto; padding: 20px; border-radius: 8px; }
        .success { color: green; background: #e8f5e9; padding: 10px; border-radius: 4px; margin: 10px 0; }
        .error { color: red; background: #ffebee; padding: 10px; border-radius: 4px; margin: 10px 0; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #f0f0f0; }
        h2 { color: #333; }
    </style>
</head>
<body>
<div class="container">
    <h1>🔍 Database Verification Tool</h1>
    <hr>

    <%
        try (Connection conn = DBConnection.getConnection()) {
            DatabaseMetaData meta = conn.getMetaData();
            String url = meta.getURL();
            String product = meta.getDatabaseProductName();
            String version = meta.getDatabaseProductVersion();
    %>
            <div class="success">✅ Connected to database successfully</div>
            <div class="success"><strong>URL:</strong> <%= url %></div>
            <div class="success"><strong>Product:</strong> <%= product %> (<%= version %>)</div>

    <%
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as total FROM students WHERE deleted_at IS NULL");
            int studentCount = 0;
            if (rs.next()) studentCount = rs.getInt("total");
    %>
            <div class="success">✅ Total Active Students in Database: <strong><%= studentCount %></strong></div>

    <%
            rs = stmt.executeQuery("SELECT COUNT(*) as total FROM courses");
            int courseCount = 0;
            if (rs.next()) courseCount = rs.getInt("total");
    %>
            <div class="success">✅ Total Courses in Database: <strong><%= courseCount %></strong></div>

    <%
            rs = stmt.executeQuery(
                "SELECT s.id, s.name, s.email, c.course_name, s.status FROM students s " +
                "JOIN courses c ON s.course_id = c.id " +
                "WHERE s.deleted_at IS NULL " +
                "ORDER BY s.id"
            );
    %>
            <h2>Students with Courses:</h2>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Course</th>
                    <th>Status</th>
                </tr>
    <%
            while (rs.next()) {
    %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("course_name") %></td>
                    <td><%= rs.getString("status") %></td>
                </tr>
    <%
            }
        } catch (Exception e) {
    %>
            <div class="error">❌ Error: <%= e.getMessage() %></div>
            <div class="error">
                <strong>Stack Trace:</strong><br>
                <%
                    java.io.StringWriter sw = new java.io.StringWriter();
                    e.printStackTrace(new java.io.PrintWriter(sw));
                    out.println(sw.toString().replace("\n", "<br>"));
                %>
            </div>
    <%
        }
    %>
    
    <hr>
    <p style="color: #666; font-size: 12px;">
        If you see students and courses above, the database is working correctly.
    </p>
    <p><a href="admin.jsp">← Back to Login</a></p>
</div>
</body>
</html>
