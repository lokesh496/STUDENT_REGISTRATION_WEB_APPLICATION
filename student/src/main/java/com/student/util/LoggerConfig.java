/*
 * Decompiled with CFR 0.152.
 */
package com.student.util;

import java.io.IOException;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

public class LoggerConfig {
    private static final Logger logger = Logger.getLogger(LoggerConfig.class.getName());
    private static boolean initialized = false;

    public static synchronized void initializeLogging() {
        if (initialized) {
            return;
        }
        try {
            FileHandler fileHandler = new FileHandler("logs/student_app.log", true);
            fileHandler.setFormatter(new SimpleFormatter());
            Logger rootLogger = Logger.getLogger("");
            rootLogger.addHandler(fileHandler);
            rootLogger.setLevel(Level.INFO);
            logger.log(Level.INFO, "\u2705 Logging initialized successfully");
            initialized = true;
        }
        catch (IOException e) {
            logger.log(Level.WARNING, "\u26a0\ufe0f Could not initialize file logging", e);
        }
    }

    public static Logger getLogger(Class<?> clazz) {
        return Logger.getLogger(clazz.getName());
    }
}

