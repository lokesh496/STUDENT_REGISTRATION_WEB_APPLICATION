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

    // Read database configuration from environment variables with Neon defaults
    private static final String DB_URL = System.getenv().getOrDefault("DB_URL", "jdbc:postgresql://ep-curly-art-a456yhbk-pooler.us-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require");
    private static final String DB_USER = System.getenv().getOrDefault("DB_USER", "neondb_owner");
    private static final String DB_PASSWORD = System.getenv().getOrDefault("DB_PASSWORD", "npg_KpDh4oXLFAG8");
    private static final String DB_DRIVER = System.getenv().getOrDefault("DB_DRIVER", "org.postgresql.Driver");

    public static Connection getConnection() throws Exception {
        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            logger.log(Level.FINE, "\uD83D\uDCCC Database connection established");
            return conn;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "\u274C Database connection failed: " + e.getMessage(), e);
            throw new Exception("Failed to establish database connection", e);
        }
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                logger.log(Level.FINE, "\uD83D\uDCCC Database connection closed");
            } catch (Exception e) {
                logger.log(Level.WARNING, "\u26A0\uFE0F Error closing database connection", e);
            }
        }
    }

    static {
        try {
            Class.forName(DB_DRIVER);
            logger.log(Level.INFO, "\u2705 JDBC Driver loaded successfully: " + DB_DRIVER);
        } catch (ClassNotFoundException e) {
            logger.log(Level.SEVERE, "\u274C Failed to load JDBC Driver: " + DB_DRIVER, e);
            throw new RuntimeException("JDBC Driver not found: " + DB_DRIVER, e);
        }
    }
}

