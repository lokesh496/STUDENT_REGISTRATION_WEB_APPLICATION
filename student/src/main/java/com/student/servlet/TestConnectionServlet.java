package com.student.servlet;

import com.student.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.Statement;

@WebServlet("/test-db")
public class TestConnectionServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>DB Test</title></head><body>");
        out.println("<h1>Database Connection Test</h1>");
        
        try {
            Connection conn = DBConnection.getConnection();
            DatabaseMetaData metaData = conn.getMetaData();
            String dbUrl = metaData.getURL();
            
            out.println("<p><strong>Status:</strong> ✅ Connected</p>");
            out.println("<p><strong>URL:</strong> " + dbUrl + "</p>");
            
            if (dbUrl.contains("neon.tech")) {
                out.println("<p style='color:green'>🎉 Connected to NEON database!</p>");
            } else {
                out.println("<p style='color:red'>⚠️ NOT connected to Neon!</p>");
            }
            
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM students");
            if (rs.next()) {
                out.println("<p><strong>Students:</strong> " + rs.getInt("count") + "</p>");
            }
            
            conn.close();
            
        } catch (Exception e) {
            out.println("<p style='color:red'>❌ Error: " + e.getMessage() + "</p>");
        }
        
        out.println("</body></html>");
    }
}