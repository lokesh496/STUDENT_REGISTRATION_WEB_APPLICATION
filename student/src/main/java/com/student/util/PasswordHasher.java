/*
 * Decompiled with CFR 0.152.
 */
package com.student.util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordHasher {
    private static final int SALT_LENGTH = 16;
    private static final String ALGORITHM = "SHA-256";

    public static String hashPassword(String password) {
        try {
            byte[] salt = new byte[16];
            new SecureRandom().nextBytes(salt);
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes());
            byte[] saltAndHash = new byte[salt.length + hashedPassword.length];
            System.arraycopy(salt, 0, saltAndHash, 0, salt.length);
            System.arraycopy(hashedPassword, 0, saltAndHash, salt.length, hashedPassword.length);
            return Base64.getEncoder().encodeToString(saltAndHash);
        }
        catch (Exception e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        try {
            byte[] decoded = Base64.getDecoder().decode(hashedPassword);
            byte[] salt = new byte[16];
            System.arraycopy(decoded, 0, salt, 0, 16);
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            byte[] hashedInput = md.digest(plainPassword.getBytes());
            byte[] storedHash = new byte[decoded.length - 16];
            System.arraycopy(decoded, 16, storedHash, 0, storedHash.length);
            return MessageDigest.isEqual(hashedInput, storedHash);
        }
        catch (Exception e) {
            return false;
        }
    }
}

