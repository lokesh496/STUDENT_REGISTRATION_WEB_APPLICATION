package com.student.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    // Prefer environment variables for deployment (Render, Docker, CI).
    // Fallback to the original Neon URL if env vars are not provided.
    private static final String DEFAULT_URL =
        "jdbc:postgresql://ep-curly-art-a456yhbk-pooler.us-east-1.aws.neon.tech/neondb?sslmode=require&channelBinding=require";

    public static Connection getConnection() throws Exception {
        String url = System.getenv("DB_URL");
        if (url == null || url.isEmpty()) {
            url = DEFAULT_URL;
        }

        String user = System.getenv("DB_USER");
        String password = System.getenv("DB_PASSWORD");

        System.out.println("DEBUG: Connecting to URL: " + url);

        // If a specific driver is provided via env, try to load it; otherwise attempt PostgreSQL driver
        String driver = System.getenv("DB_DRIVER");
        if (driver == null || driver.isEmpty()) {
            driver = "org.postgresql.Driver";
        }
        System.out.println("DEBUG: Using driver: " + driver);
        Class.forName(driver);

        Connection conn;
        if (user != null && !user.isEmpty() && password != null && !password.isEmpty()) {
            conn = DriverManager.getConnection(url, user, password);
        } else {
            // Allow URLs that already contain credentials or rely on socket/auth methods
            conn = DriverManager.getConnection(url);
        }

        System.out.println("DEBUG: Connection successful to: " + conn.getMetaData().getURL());
        return conn;
    }
}
