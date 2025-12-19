package com.student.util;

import com.student.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;

public class DBTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Connection con = DBConnection.getConnection();
            out.println("<h2 style='color:green'>✅ Database Connected Successfully!</h2>");
            con.close();
        } catch (Exception e) {
            out.println("<h2 style='color:red'>❌ Database Connection Failed</h2>");
            out.println("<pre>" + e.getMessage() + "</pre>");
            e.printStackTrace();
        }
    }
}
