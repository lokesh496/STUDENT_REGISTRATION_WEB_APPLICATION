<%@ page import="java.sql.*" %>
<%@ page import="com.student.util.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Connection Test</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #f5f5f5; }
        .container { background: white; padding: 20px; border-radius: 8px; max-width: 800px; margin: 0 auto; }
        .success { color: green; background: #e8f5e9; padding: 10px; border-radius: 4px; margin: 10px 0; }
        .error { color: red; background: #ffebee; padding: 10px; border-radius: 4px; margin: 10px 0; }
        .info { color: blue; background: #e3f2fd; padding: 10px; border-radius: 4px; margin: 10px 0; }
    </style>
</head>
<body>
<div class="container">
    <h1>🔍 Database Connection Test</h1>
    <hr>

    <%
        try {
            Connection conn = DBConnection.getConnection();
            
            // Get database metadata
            DatabaseMetaData metaData = conn.getMetaData();
            String dbUrl = metaData.getURL();
            String dbName = metaData.getDatabaseProductName();
            String dbVersion = metaData.getDatabaseProductVersion();
            
    %>
            <div class="success">✅ Database connection successful!</div>
            <div class="info"><strong>Database URL:</strong> <%= dbUrl %></div>
            <div class="info"><strong>Database Type:</strong> <%= dbName %></div>
            <div class="info"><strong>Database Version:</strong> <%= dbVersion %></div>
    <%
            
            // Check if we're connected to Neon (Postgres)
            if (dbUrl.contains("neon.tech")) {
    %>
                <div class="success">🎉 Connected to NEON database!</div>
    <%
            } else if (dbUrl.contains("localhost") || dbUrl.contains("127.0.0.1")) {
    %>
                <div class="error">⚠️ Connected to LOCAL database, not Neon!</div>
    <%
            } else {
    %>
                <div class="info">📍 Connected to: <%= dbUrl %></div>
    <%
            }
            
            // Test query to see actual data
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM students WHERE deleted_at IS NULL");
            if (rs.next()) {
                int count = rs.getInt("count");
    %>
                <div class="info"><strong>Active Students Count:</strong> <%= count %></div>
    <%
            }
            
            // Show recent students
            rs = stmt.executeQuery("SELECT name, email FROM students WHERE deleted_at IS NULL ORDER BY created_at DESC LIMIT 3");
    %>
            <h3>Recent Students:</h3>
            <ul>
    <%
            while (rs.next()) {
    %>
                <li><%= rs.getString("name") %> - <%= rs.getString("email") %></li>
    <%
            }
    %>
            </ul>
    <%
            
            conn.close();
        } catch (Exception e) {
    %>
            <div class="error">❌ Connection failed: <%= e.getMessage() %></div>
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
    <p><a href="admin.jsp">← Back to Admin</a></p>
</div>
</body>
</html>