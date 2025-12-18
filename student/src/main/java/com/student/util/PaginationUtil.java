/*
 * Decompiled with CFR 0.152.
 */
package com.student.util;

public class PaginationUtil {
    private int currentPage;
    private int totalRecords;
    private int recordsPerPage;
    private int totalPages;

    public PaginationUtil(int currentPage, int totalRecords, int recordsPerPage) {
        this.currentPage = currentPage > 0 ? currentPage : 1;
        this.totalRecords = totalRecords > 0 ? totalRecords : 0;
        this.recordsPerPage = recordsPerPage > 0 ? recordsPerPage : 10;
        this.totalPages = (int)Math.ceil((double)totalRecords / (double)recordsPerPage);
    }

    public int getCurrentPage() {
        return this.currentPage;
    }

    public int getTotalPages() {
        return this.totalPages > 0 ? this.totalPages : 1;
    }

    public int getTotalRecords() {
        return this.totalRecords;
    }

    public int getRecordsPerPage() {
        return this.recordsPerPage;
    }

    public int getOffset() {
        return (this.currentPage - 1) * this.recordsPerPage;
    }

    public boolean hasNextPage() {
        return this.currentPage < this.totalPages;
    }

    public boolean hasPreviousPage() {
        return this.currentPage > 1;
    }

    public int getNextPage() {
        return this.hasNextPage() ? this.currentPage + 1 : this.currentPage;
    }

    public int getPreviousPage() {
        return this.hasPreviousPage() ? this.currentPage - 1 : 1;
    }
}

