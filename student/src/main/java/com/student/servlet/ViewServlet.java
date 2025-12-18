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
import com.student.model.Student;
import com.student.util.PaginationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(value={"/view"})
public class ViewServlet
extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            res.sendRedirect("admin.jsp");
            return;
        }
        int currentPage = 1;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
            }
            catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        StudentDao dao = new StudentDao();
        int totalStudents = dao.getActiveStudentCount();
        List<Student> students = dao.getAllStudents(currentPage, 10);
        PaginationUtil pagination = new PaginationUtil(currentPage, totalStudents, 10);
        req.setAttribute("students", students);
        req.setAttribute("pagination", (Object)pagination);
        req.setAttribute("totalStudents", (Object)totalStudents);
        req.getRequestDispatcher("viewStudents.jsp").forward((ServletRequest)req, (ServletResponse)res);
    }
}

