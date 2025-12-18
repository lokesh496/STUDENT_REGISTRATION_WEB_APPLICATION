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

@WebServlet(value={"/search"})
public class SearchServlet
extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        int totalCount;
        List<Student> students;
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            res.sendRedirect("admin.jsp");
            return;
        }
        String searchTerm = req.getParameter("q");
        String filterCourse = req.getParameter("course");
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
        if (filterCourse != null && !filterCourse.isEmpty() && !"all".equalsIgnoreCase(filterCourse)) {
            students = dao.getStudentsByCourse(filterCourse, currentPage, 10);
            totalCount = dao.countStudentsByCourse(filterCourse);
            req.setAttribute("filterCourse", (Object)filterCourse);
        } else if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            students = dao.searchStudents(searchTerm, currentPage, 10);
            totalCount = dao.countSearchResults(searchTerm);
            req.setAttribute("searchTerm", (Object)searchTerm);
        } else {
            students = dao.getAllStudents(currentPage, 10);
            totalCount = dao.getActiveStudentCount();
        }
        PaginationUtil pagination = new PaginationUtil(currentPage, totalCount, 10);
        req.setAttribute("students", students);
        req.setAttribute("pagination", (Object)pagination);
        req.setAttribute("totalStudents", (Object)totalCount);
        req.getRequestDispatcher("searchResults.jsp").forward((ServletRequest)req, (ServletResponse)res);
    }
}

