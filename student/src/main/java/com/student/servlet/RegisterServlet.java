/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  jakarta.servlet.ServletException
 *  jakarta.servlet.annotation.WebServlet
 *  jakarta.servlet.http.HttpServlet
 *  jakarta.servlet.http.HttpServletRequest
 *  jakarta.servlet.http.HttpServletResponse
 */
package com.student.servlet;

import com.student.dao.StudentDao;
import com.student.model.Student;
import com.student.util.ValidationUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(value={"/register"})
public class RegisterServlet
extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("=== REGISTER SERVLET HIT ===");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String course = request.getParameter("course");
        String phone = request.getParameter("phone");
        System.out.println("DATA: " + name + " | " + email + " | " + course + " | " + phone);
        if (!ValidationUtils.isValidName(name)) {
            response.sendRedirect("index.jsp?error=invalid_name");
            return;
        }
        if (!ValidationUtils.isValidEmail(email)) {
            response.sendRedirect("index.jsp?error=invalid_email");
            return;
        }
        if (!ValidationUtils.isValidCourse(course)) {
            response.sendRedirect("index.jsp?error=invalid_course");
            return;
        }
        if (!ValidationUtils.isValidPhone(phone)) {
            response.sendRedirect("index.jsp?error=invalid_phone");
            return;
        }
        Student student = new Student(name, email, course);
        student.setPhone(phone);
        StudentDao dao = new StudentDao();
        if (dao.addStudent(student)) {
            System.out.println("\u2705 INSERT QUERY EXECUTED");
            String xReq = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(xReq)) {
                int total = dao.getActiveStudentCount();
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"success\",\"message\":\"registered\",\"total\":" + total + "}");
                return;
            }
            if (request.getSession(false) != null && Boolean.TRUE.equals(request.getSession(false).getAttribute("admin"))) {
                response.sendRedirect("adminHome?msg=registered");
            } else {
                response.sendRedirect("index.jsp?success=true");
            }
        } else {
            System.out.println("\u274c INSERT FAILED - Possible duplicate email");
            String xReq = request.getHeader("X-Requested-With");
            if ("XMLHttpRequest".equals(xReq)) {
                response.setContentType("application/json");
                response.getWriter().write("{\"status\":\"error\",\"reason\":\"duplicate_email\"}");
                return;
            }
            if (request.getSession(false) != null && Boolean.TRUE.equals(request.getSession(false).getAttribute("admin"))) {
                response.sendRedirect("adminHome?error=duplicate_email");
            } else {
                response.sendRedirect("index.jsp?error=duplicate_email");
            }
        }
    }
}

