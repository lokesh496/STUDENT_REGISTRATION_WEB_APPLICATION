/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  jakarta.servlet.ServletException
 *  jakarta.servlet.annotation.WebServlet
 *  jakarta.servlet.http.HttpServlet
 *  jakarta.servlet.http.HttpServletRequest
 *  jakarta.servlet.http.HttpServletResponse
 *  jakarta.servlet.http.HttpSession
 */
package com.student.servlet;

import com.student.dao.StudentDao;
import com.student.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@WebServlet(value={"/export"})
public class ExportServlet
extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            res.sendRedirect("admin.jsp");
            return;
        }
        String format = req.getParameter("format");
        if (format == null) {
            format = "csv";
        }
        if ("csv".equalsIgnoreCase(format)) {
            this.exportToCSV(req, res);
        } else if ("json".equalsIgnoreCase(format)) {
            this.exportToJSON(req, res);
        } else {
            res.sendRedirect("adminHome");
        }
    }

    private void exportToCSV(HttpServletRequest req, HttpServletResponse res) throws IOException {
        StudentDao dao = new StudentDao();
        List<Student> students = dao.getAllStudentsForExport();
        res.setContentType("text/csv");
        res.setHeader("Content-Disposition", "attachment;filename=students_export.csv");
        PrintWriter writer = res.getWriter();
        writer.println("ID,Name,Email,Course,Phone,Status,Registered Date");
        DateTimeFormatter df = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        for (Student s : students) {
            String created = "";
            try {
                if (s.getCreatedAt() != null) {
                    created = s.getCreatedAt().format(df);
                }
            }
            catch (Exception e) {
                created = "";
            }
            String csv = String.format("%d,\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"", s.getId(), this.escapeCSV(s.getName()), this.escapeCSV(s.getEmail()), this.escapeCSV(s.getCourse()), s.getPhone() != null ? this.escapeCSV(s.getPhone()) : "", s.getStatus(), this.escapeCSV(created));
            writer.println(csv);
        }
        writer.close();
    }

    private void exportToJSON(HttpServletRequest req, HttpServletResponse res) throws IOException {
        StudentDao dao = new StudentDao();
        List<Student> students = dao.getAllStudentsForExport();
        Map<String, Integer> distribution = dao.getCourseDistribution();
        res.setContentType("application/json");
        res.setHeader("Content-Disposition", "attachment;filename=students_export.json");
        PrintWriter writer = res.getWriter();
        StringBuilder json = new StringBuilder();
        json.append("{\n");
        json.append("  \"exported_at\": \"").append(LocalDateTime.now()).append("\",\n");
        json.append("  \"total_students\": ").append(students.size()).append(",\n");
        json.append("  \"students\": [\n");
        for (int i = 0; i < students.size(); ++i) {
            Student s = students.get(i);
            json.append("    {\n");
            json.append("      \"id\": ").append(s.getId()).append(",\n");
            json.append("      \"name\": \"").append(this.escapeJSON(s.getName())).append("\",\n");
            json.append("      \"email\": \"").append(this.escapeJSON(s.getEmail())).append("\",\n");
            json.append("      \"course\": \"").append(this.escapeJSON(s.getCourse())).append("\",\n");
            json.append("      \"phone\": \"").append(s.getPhone() != null ? this.escapeJSON(s.getPhone()) : "").append("\",\n");
            json.append("      \"status\": \"").append(s.getStatus()).append("\",\n");
            String reg = "";
            try {
                if (s.getCreatedAt() != null) {
                    reg = s.getCreatedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
                }
            }
            catch (Exception e) {
                reg = "";
            }
            json.append("      \"registered_at\": \"").append(reg).append("\"\n");
            json.append("    }");
            if (i < students.size() - 1) {
                json.append(",");
            }
            json.append("\n");
        }
        json.append("  ],\n");
        json.append("  \"course_distribution\": {\n");
        int courseCount = 0;
        for (Map.Entry<String, Integer> entry : distribution.entrySet()) {
            json.append("    \"").append(entry.getKey()).append("\": ").append(entry.getValue());
            if (courseCount++ < distribution.size() - 1) {
                json.append(",");
            }
            json.append("\n");
        }
        json.append("  }\n");
        json.append("}\n");
        writer.write(json.toString());
        writer.close();
    }

    private String escapeCSV(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\"", "\"\"");
    }

    private String escapeJSON(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
}

