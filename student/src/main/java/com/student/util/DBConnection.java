/*
 * Decompiled with CFR 0.152.
 */
package com.student.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    private static final Logger logger = Logger.getLogger(DBConnection.class.getName());
    private static final String DB_URL = "jdbc:mysql://localhost:3306/student_management?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root";
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    public static Connection getConnection() throws Exception {
        try {
            Connection conn = DriverManager.getConnection(DB_URL, "root", "root");
            logger.log(Level.FINE, "\ud83d\udccc Database connection established");
            return conn;
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Database connection failed: " + e.getMessage(), e);
            throw new Exception("Failed to establish database connection", e);
        }
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                logger.log(Level.FINE, "\ud83d\udccc Database connection closed");
            }
            catch (Exception e) {
                logger.log(Level.WARNING, "\u26a0\ufe0f Error closing database connection", e);
            }
        }
    }

    static {
        try {
            Class.forName(DB_DRIVER);
            logger.log(Level.INFO, "\u2705 MySQL JDBC Driver loaded successfully");
        }
        catch (ClassNotFoundException e) {
            logger.log(Level.SEVERE, "\u274c Failed to load MySQL JDBC Driver", e);
            throw new RuntimeException("MySQL JDBC Driver not found", e);
        }
    }
}

