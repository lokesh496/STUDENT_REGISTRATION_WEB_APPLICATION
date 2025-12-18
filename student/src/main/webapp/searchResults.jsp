<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.student.model.Student, com.student.util.PaginationUtil" %>

<!DOCTYPE html>
<html>
<head>
    <title>Search Students - Admin Panel</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            padding: 20px;
        }

        .search-container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 30px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .header h1 {
            color: #333;
            margin: 0;
            font-size: 28px;
        }

        .header-actions {
            display: flex;
            gap: 15px;
        }

        .back-btn {
            background: #6c757d;
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .search-box {
            display: grid;
            grid-template-columns: 1fr 200px 150px auto;
            gap: 15px;
            margin-bottom: 25px;
            align-items: end;
        }

        .search-input {
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .filter-select {
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            background: white;
            font-size: 14px;
            cursor: pointer;
        }

        .search-btn {
            background: #667eea;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .search-btn:hover {
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        .results-info {
            background: #f8f9fa;
            padding: 15px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
            color: #555;
            font-size: 14px;
        }

        .results-info strong {
            color: #333;
        }

        .export-btn {
            background: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            margin-left: 10px;
            transition: all 0.3s ease;
        }

        .export-btn:hover {
            background: #218838;
            transform: translateY(-2px);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 16px;
            text-align: left;
            font-weight: 600;
            border-radius: 6px 6px 0 0;
        }

        td {
            padding: 14px 16px;
            border-bottom: 1px solid #e0e0e0;
            font-size: 14px;
        }

        tr:hover {
            background-color: #f8f9fa;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .delete-btn {
            background: #dc3545;
            color: white;
            padding: 8px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s ease;
        }

        .delete-btn:hover {
            background: #c82333;
            transform: scale(1.05);
        }

        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #f0f0f0;
        }

        .pagination a, .pagination span {
            padding: 10px 15px;
            border-radius: 6px;
            text-decoration: none;
            color: #333;
            background: #f0f0f0;
            transition: all 0.3s ease;
        }

        .pagination a:hover {
            background: #667eea;
            color: white;
        }

        .pagination .active {
            background: #667eea;
            color: white;
            font-weight: 600;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-state-icon {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        .empty-state p {
            margin: 10px 0;
            font-size: 14px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
            margin: 10px 0;
        }

        .stat-label {
            font-size: 12px;
            opacity: 0.9;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        @media (max-width: 768px) {
            .search-box {
                grid-template-columns: 1fr;
            }

            .header {
                flex-direction: column;
                gap: 15px;
            }

            table {
                font-size: 12px;
            }

            td, th {
                padding: 10px 8px;
            }
        }
    </style>
</head>

<body>

<div class="search-container">
    <!-- Header -->
    <div class="header">
        <h1>🔍 Search Students</h1>
        <div class="header-actions">
            <a href="adminHome" class="back-btn">← Back to Dashboard</a>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-label">Total Results</div>
            <div class="stat-value"><%= request.getAttribute("totalStudents") != null ? request.getAttribute("totalStudents") : "0" %></div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Page Size</div>
            <div class="stat-value">10</div>
        </div>
        <div class="stat-card">
            <div class="stat-label">Status</div>
            <div class="stat-value">Active</div>
        </div>
    </div>

    <!-- Search Form -->
    <form method="GET" action="search" class="search-form">
        <div class="search-box">
            <input type="text" name="q" class="search-input" placeholder="Search by name, email, or course..." 
                   value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>">
            
            <select name="course" class="filter-select">
                <option value="all">All Courses</option>
                <option value="Java">Java</option>
                <option value="Python">Python</option>
                <option value="C">C</option>
                <option value="C++">C++</option>
                <option value="DSA">DSA</option>
                <option value="HTML">HTML</option>
                <option value="CSS">CSS</option>
                <option value="JavaScript">JavaScript</option>
                <option value="React">React</option>
                <option value="Spring Boot">Spring Boot</option>
                <option value="Node.js">Node.js</option>
                <option value="SQL">SQL</option>
            </select>

            <button type="submit" class="search-btn">Search</button>
        </div>
    </form>

    <%
        String searchTerm = (String) request.getAttribute("searchTerm");
        String filterCourse = (String) request.getAttribute("filterCourse");
        Integer totalStudents = (Integer) request.getAttribute("totalStudents");
    %>

    <!-- Results Info -->
    <div class="results-info">
        <% if (searchTerm != null) { %>
            <strong>Search Results for "<%= searchTerm %>"</strong> - Found <%= totalStudents %> student(s)
        <% } else if (filterCourse != null) { %>
            <strong>Students in <%= filterCourse %></strong> - <%= totalStudents %> student(s)
        <% } else { %>
            <strong>All Students</strong> - <%= totalStudents %> student(s)
        <% } %>
    </div>

    <!-- Results Table -->
    <%
        List<Student> students = (List<Student>) request.getAttribute("students");
        if (students != null && !students.isEmpty()) {
    %>

    <table>
        <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Course</th>
            <th>Phone</th>
            <th>Status</th>
            <th>Registered</th>
            <th>Actions</th>
        </tr>

        <%
            for (Student s : students) {
        %>
        <tr>
            <td><strong><%= s.getName() %></strong></td>
            <td><%= s.getEmail() %></td>
            <td><%= s.getCourse() %></td>
            <td><%= s.getPhone() != null ? s.getPhone() : "-" %></td>
            <td>
                <span class="status-badge <%= s.getStatus() != null && s.getStatus().equals("ACTIVE") ? "status-active" : "status-inactive" %>">
                    <%= s.getStatus() %>
                </span>
            </td>
            <td><%= s.getCreatedAt() != null ? s.getCreatedAt().toLocalDate() : "-" %></td>
            <td>
                <div class="action-buttons">
                    <button class="delete-btn" onclick="deleteStudent('<%= s.getId() %>')">Delete</button>
                </div>
            </td>
        </tr>
        <%
            }
        %>
    </table>

    <!-- Pagination -->
    <%
        PaginationUtil pagination = (PaginationUtil) request.getAttribute("pagination");
        if (pagination != null && pagination.getTotalPages() > 1) {
    %>
    <div class="pagination">
        <% if (pagination.hasPreviousPage()) { %>
            <a href="search?q=<%= searchTerm != null ? searchTerm : "" %>&page=<%= pagination.getPreviousPage() %>">← Previous</a>
        <% } %>

        <% for (int i = 1; i <= pagination.getTotalPages(); i++) { %>
            <% if (i == pagination.getCurrentPage()) { %>
                <span class="active"><%= i %></span>
            <% } else { %>
                <a href="search?q=<%= searchTerm != null ? searchTerm : "" %>&page=<%= i %>"><%= i %></a>
            <% } %>
        <% } %>

        <% if (pagination.hasNextPage()) { %>
            <a href="search?q=<%= searchTerm != null ? searchTerm : "" %>&page=<%= pagination.getNextPage() %>">Next →</a>
        <% } %>
    </div>
    <%
        }
    %>

    <%
        } else {
    %>

    <!-- Empty State -->
    <div class="empty-state">
        <div class="empty-state-icon">🔍</div>
        <p><strong>No students found</strong></p>
        <p>Try adjusting your search criteria or filters</p>
        <a href="search" style="text-decoration: none;">← View all students</a>
    </div>

    <%
        }
    %>

</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
<script>
    function deleteStudent(studentId) {
        if (confirm('Are you sure you want to delete this student?')) {
            window.location.href = 'deleteStudent?id=' + studentId;
        }
    }

    // Show success message if available
    var successMsg = '<%= request.getParameter("success") != null ? request.getParameter("success") : "" %>';
    if (successMsg === 'true') {
        toastr.success('Student deleted successfully!', 'Success', {
            positionClass: "toast-top-right",
            timeOut: 3000,
            progressBar: true
        });
    }
</script>

</body>
</html>
