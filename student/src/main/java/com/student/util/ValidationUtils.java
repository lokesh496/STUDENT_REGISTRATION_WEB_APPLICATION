/*
 * Decompiled with CFR 0.152.
 */
package com.student.util;

import java.util.regex.Pattern;

public class ValidationUtils {
    private static final Pattern NAME_PATTERN = Pattern.compile("^[a-zA-Z ]{3,100}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$");
    private static final Pattern COURSE_PATTERN = Pattern.compile("^[A-Za-z0-9 ._+#-]{2,100}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9+\\- ]{7,20}$");

    public static boolean isValidName(String name) {
        return name != null && NAME_PATTERN.matcher(name).matches();
    }

    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email).matches();
    }

    public static boolean isValidCourse(String course) {
        return course != null && COURSE_PATTERN.matcher(course).matches();
    }

    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return true;
        }
        return PHONE_PATTERN.matcher(phone).matches();
    }

    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    public static boolean isValidInteger(String value) {
        try {
            Integer.parseInt(value);
            return true;
        }
        catch (NumberFormatException e) {
            return false;
        }
    }
}

