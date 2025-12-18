/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  jakarta.servlet.ServletException
 *  jakarta.servlet.ServletRequest
 *  jakarta.servlet.ServletResponse
 *  jakarta.servlet.annotation.WebServlet
 *  jakarta.servlet.http.HttpServlet
 *  jakarta.servlet.http.HttpServletRequest
 *  jakarta.servlet.http.HttpServletResponse
 *  jakarta.servlet.http.HttpSession
 */
package com.student.servlet;

import com.student.dao.StudentDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet(value={"/adminHome"})
public class AdminDashboardServlet
extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            res.sendRedirect("admin.jsp");
            return;
        }
        StudentDao dao = new StudentDao();
        int totalStudents = dao.getActiveStudentCount();
        Map<String, Integer> courseDistribution = dao.getCourseDistribution();
        req.setAttribute("totalStudents", (Object)totalStudents);
        req.setAttribute("totalCourses", (Object)12);
        req.setAttribute("systemStatus", (Object)"Active");
        req.setAttribute("recentStudents", dao.getRecentStudents(5));
        req.setAttribute("courseDistribution", courseDistribution);
        req.getRequestDispatcher("adminHome.jsp").forward((ServletRequest)req, (ServletResponse)res);
    }
}

