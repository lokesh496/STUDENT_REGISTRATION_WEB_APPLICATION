/*
 * Decompiled with CFR 0.152.
 */
package com.student.util;

import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

public class CSRFTokenUtil {
    private static final ConcurrentHashMap<String, String> tokenStore = new ConcurrentHashMap();
    public static final String CSRF_TOKEN_PARAM = "_csrf_token";
    public static final String CSRF_TOKEN_HEADER = "X-CSRF-Token";

    public static String generateToken() {
        String token = UUID.randomUUID().toString();
        tokenStore.put(token, "" + System.currentTimeMillis());
        return token;
    }

    public static boolean validateToken(String token) {
        return token != null && tokenStore.containsKey(token);
    }

    public static void removeToken(String token) {
        if (token != null) {
            tokenStore.remove(token);
        }
    }
}

