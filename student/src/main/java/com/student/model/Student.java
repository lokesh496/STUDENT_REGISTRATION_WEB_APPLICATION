/*
 * Decompiled with CFR 0.152.
 */
package com.student.model;

import java.time.LocalDateTime;

public class Student {
    private int id;
    private String name;
    private String email;
    private String course;
    private String phone;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String notes;
    private int courseId;

    public Student() {
        this.status = "ACTIVE";
    }

    public Student(String name, String email, String course) {
        this.name = name;
        this.email = email;
        this.course = course;
        this.status = "ACTIVE";
    }

    public Student(int id, String name, String email, String course) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.course = course;
        this.status = "ACTIVE";
    }

    public Student(int id, String name, String email, int courseId, String course, String phone, String status, LocalDateTime createdAt, LocalDateTime updatedAt, String notes) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.courseId = courseId;
        this.course = course;
        this.phone = phone;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.notes = notes;
    }

    public int getId() {
        return this.id;
    }

    public String getName() {
        return this.name;
    }

    public String getEmail() {
        return this.email;
    }

    public String getCourse() {
        return this.course;
    }

    public String getPhone() {
        return this.phone;
    }

    public String getStatus() {
        return this.status;
    }

    public LocalDateTime getCreatedAt() {
        return this.createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return this.updatedAt;
    }

    public String getNotes() {
        return this.notes;
    }

    public int getCourseId() {
        return this.courseId;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setCourse(String course) {
        this.course = course;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String toString() {
        return "Student{id=" + this.id + ", name='" + this.name + "', email='" + this.email + "', course='" + this.course + "', status='" + this.status + "'}";
    }
}

