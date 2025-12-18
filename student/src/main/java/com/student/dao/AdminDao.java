/*
 * Decompiled with CFR 0.152.
 */
package com.student.dao;

import com.student.util.DBConnection;
import com.student.util.LoggerConfig;
import com.student.util.PasswordHasher;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AdminDao {
    private static final Logger logger = LoggerConfig.getLogger(AdminDao.class);

    /*
     * Enabled aggressive block sorting
     * Enabled unnecessary exception pruning
     * Enabled aggressive exception aggregation
     */
    public boolean authenticate(String username, String password) {
        String sql = "SELECT password_hash FROM admin WHERE username = ? AND is_active = TRUE";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);){
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery();){
                if (!rs.next()) return false;
                String storedHash = rs.getString("password_hash");
                boolean isValid = PasswordHasher.verifyPassword(password, storedHash);
                if (isValid) {
                    this.updateLastLogin(username);
                    logger.log(Level.INFO, "\u2705 Admin login successful: " + username);
                } else {
                    logger.log(Level.WARNING, "\u26a0\ufe0f Failed login attempt for: " + username);
                }
                boolean bl = isValid;
                return bl;
            }
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Authentication error", e);
        }
        return false;
    }

    /*
     * Enabled aggressive block sorting
     * Enabled unnecessary exception pruning
     * Enabled aggressive exception aggregation
     */
    public String getAdminEmail(String username) {
        String sql = "SELECT email FROM admin WHERE username = ? AND is_active = TRUE";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);){
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery();){
                if (!rs.next()) return null;
                String string = rs.getString("email");
                return string;
            }
        }
        catch (Exception e) {
            logger.log(Level.SEVERE, "\u274c Error getting admin email", e);
        }
        return null;
    }

    private void updateLastLogin(String username) {
        String sql = "UPDATE admin SET last_login = NOW() WHERE username = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);){
            ps.setString(1, username);
            ps.executeUpdate();
        }
        catch (Exception e) {
            logger.log(Level.WARNING, "\u26a0\ufe0f Could not update last login", e);
        }
    }

    /*
     * Exception decompiling
     */
    public boolean adminExists(String username) {
        /*
         * This method has failed to decompile.  When submitting a bug report, please provide this stack trace, and (if you hold appropriate legal rights) the relevant class file.
         * 
         * org.benf.cfr.reader.util.ConfusedCFRException: Started 2 blocks at once
         *     at org.benf.cfr.reader.bytecode.analysis.opgraph.Op04StructuredStatement.getStartingBlocks(Op04StructuredStatement.java:412)
         *     at org.benf.cfr.reader.bytecode.analysis.opgraph.Op04StructuredStatement.buildNestedBlocks(Op04StructuredStatement.java:487)
         *     at org.benf.cfr.reader.bytecode.analysis.opgraph.Op03SimpleStatement.createInitialStructuredBlock(Op03SimpleStatement.java:736)
         *     at org.benf.cfr.reader.bytecode.CodeAnalyser.getAnalysisInner(CodeAnalyser.java:850)
         *     at org.benf.cfr.reader.bytecode.CodeAnalyser.getAnalysisOrWrapFail(CodeAnalyser.java:278)
         *     at org.benf.cfr.reader.bytecode.CodeAnalyser.getAnalysis(CodeAnalyser.java:201)
         *     at org.benf.cfr.reader.entities.attributes.AttributeCode.analyse(AttributeCode.java:94)
         *     at org.benf.cfr.reader.entities.Method.analyse(Method.java:531)
         *     at org.benf.cfr.reader.entities.ClassFile.analyseMid(ClassFile.java:1055)
         *     at org.benf.cfr.reader.entities.ClassFile.analyseTop(ClassFile.java:942)
         *     at org.benf.cfr.reader.Driver.doJarVersionTypes(Driver.java:257)
         *     at org.benf.cfr.reader.Driver.doJar(Driver.java:139)
         *     at org.benf.cfr.reader.CfrDriverImpl.analyse(CfrDriverImpl.java:76)
         *     at org.benf.cfr.reader.Main.main(Main.java:54)
         */
        throw new IllegalStateException("Decompilation failed");
    }
}

