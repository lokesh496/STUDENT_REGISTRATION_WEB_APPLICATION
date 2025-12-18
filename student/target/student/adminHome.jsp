<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>

<%
    Boolean admin = (Boolean) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("admin.jsp");
        return;
    }

    Integer totalStudents = (Integer) request.getAttribute("totalStudents");
    Integer totalCourses = (Integer) request.getAttribute("totalCourses");
    String systemStatus = (String) request.getAttribute("systemStatus");
    Map<String, Integer> courseDistribution = (Map<String, Integer>) request.getAttribute("courseDistribution");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Student Management System</title>
    <link rel="preconnect" href="https://cdnjs.cloudflare.com">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        :root {
            --content-max-width: 1200px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
            width: 100%;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* NAVBAR STYLING */
        .navbar {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            padding: 0;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            position: sticky;
            top: 0;
            z-index: 1000;
            flex-shrink: 0;
        }

        .navbar-container {
            max-width: var(--content-max-width);
            margin: 0 auto;
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
        }

        .navbar-brand {
            color: white;
            font-size: 24px;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 10px;
            white-space: nowrap;
        }

        .navbar-brand i {
            font-size: 28px;
            color: #667eea;
        }

        .navbar-menu {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .navbar-menu a {
            color: white;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s ease;
            padding: 8px 15px;
            border-radius: 6px;
            white-space: nowrap;
        }

        .navbar-menu a:hover {
            background: rgba(102, 126, 234, 0.3);
            color: #667eea;
        }

        .logout-btn {
            background: #e74c3c;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: bold;
            text-decoration: none;
            display: inline-block;
            white-space: nowrap;
        }

        .logout-btn:hover {
            background: #c0392b;
            transform: scale(1.05);
        }

        /* MAIN CONTENT */
        .dashboard-wrapper {
            flex: 1;
            padding: 30px 30px;
            max-width: var(--content-max-width);
            margin: 0 auto;
            width: 100%;
        }

        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: var(--content-max-width);
            margin: 0 auto 30px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            color: white;
            backdrop-filter: blur(10px);
        }

        .admin-title h1 {
            font-size: 32px;
            margin-bottom: 5px;
        }

        .admin-title p {
            font-size: 14px;
            opacity: 0.9;
        }

        .logout-btn {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 10px 20px;
            border: 1px solid white;
            border-radius: 6px;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            background: rgba(255, 0, 0, 0.3);
            transform: scale(1.05);
        }

        .dashboard-container {
            max-width: var(--content-max-width);
            margin: 0 auto;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }

        .stat-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

        .stat-icon {
            font-size: 40px;
            margin-bottom: 10px;
            color: #667eea;
        }

        .stat-value {
            font-size: 36px;
            font-weight: 700;
            color: #333;
            margin: 10px 0;
        }

        .stat-label {
            font-size: 13px;
            color: #999;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .stat-change {
            font-size: 12px;
            margin-top: 10px;
            padding: 5px 10px;
            background: #e8f5e9;
            color: #4caf50;
            border-radius: 4px;
            display: inline-block;
        }

        .actions-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background: white;
            border-radius: 12px;
            text-decoration: none;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
            gap: 10px;
            font-size: 16px;
        }

        .btn-view {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .btn-register {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .btn-search {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .btn-export {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }

        .action-btn:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        .action-btn i {
            font-size: 24px;
        }

        .content-section {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .section-title {
            font-size: 20px;
            font-weight: 700;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #667eea;
            font-size: 24px;
        }

        .course-chart {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
        }

        .course-item {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }

        .course-count {
            font-size: 28px;
            font-weight: 700;
            margin: 10px 0;
        }

        .course-name {
            font-size: 12px;
            opacity: 0.9;
        }

        .quick-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .info-box {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }

        .info-label {
            font-size: 12px;
            color: #999;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 18px;
            font-weight: 700;
            color: #333;
        }

        .footer {
            text-align: center;
            color: white;
            padding: 20px;
            margin-top: 30px;
            opacity: 0.9;
            max-width: var(--content-max-width);
            margin-left: auto;
            margin-right: auto;
        }

        @media (max-width: 768px) {
            .admin-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .action-btn {
                flex-direction: column;
            }
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar">
    <div class="navbar-container">
        <div class="navbar-brand">
            <i class="fas fa-graduation-cap"></i>
            Student Management
        </div>
        <div class="navbar-menu">
            <a href="view"><i class="fas fa-list"></i> View Students</a>
            <a href="search"><i class="fas fa-search"></i> Search</a>
            <a href="index.jsp"><i class="fas fa-user-plus"></i> Register</a>
            <a href="logout" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>
</nav>

<!-- MAIN CONTENT -->
<div class="dashboard-wrapper">
    <div style="color: white; font-size: 28px; margin-bottom: 30px; font-weight: bold;">
        <i class="fas fa-chart-line"></i> Admin Dashboard
    </div>

<!-- Main Dashboard -->
<div class="dashboard-container">

    <!-- Statistics Cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon">👥</div>
            <div class="stat-value"><%= totalStudents != null ? totalStudents : 0 %></div>
            <div class="stat-label">Total Students</div>
            <div class="stat-change">✅ Active & Registered</div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">📚</div>
            <div class="stat-value"><%= totalCourses != null ? totalCourses : 0 %></div>
            <div class="stat-label">Total Courses</div>
            <div class="stat-change">📖 Available for Selection</div>
        </div>

        <div class="stat-card">
            <div class="stat-icon">⚡</div>
            <div class="stat-value">
                <% if ("Active".equals(systemStatus)) { %>
                    ✅
                <% } else { %>
                    ⚠️
                <% } %>
            </div>
            <div class="stat-label">System Status</div>
            <div class="stat-change" style="background: #e8f5e9; color: #4caf50;">
                <%= systemStatus != null ? systemStatus : "Active" %>
            </div>
        </div>
    </div>

    <!-- Action Buttons -->
    <div class="actions-section">
        <a href="view" class="action-btn btn-view">
            <i class="fas fa-list"></i>
            View Students
        </a>
        <!-- Register Student removed per request -->
        <a href="search" class="action-btn btn-search">
            <i class="fas fa-search"></i>
            Search Students
        </a>
        <a href="export" class="action-btn btn-export">
            <i class="fas fa-download"></i>
            Export Data
        </a>
    </div>

    <!-- Course Distribution -->
    <div class="content-section">
        <div class="section-title">
            <i class="fas fa-chart-bar"></i>
            Course Distribution
        </div>
        <div class="course-chart">
            <%
                if (courseDistribution != null && !courseDistribution.isEmpty()) {
                    for (Map.Entry<String, Integer> entry : courseDistribution.entrySet()) {
            %>
                <div class="course-item">
                    <div class="course-count"><%= entry.getValue() %></div>
                    <div class="course-name"><%= entry.getKey() %></div>
                </div>
            <%
                    }
                }
            %>
        </div>
    </div>

    <!-- Register functionality removed -->

    <!-- Footer -->
    <div class="footer">
        <p>🚀 Enterprise Student Registration System v2.0 | All systems operational</p>
    </div>

</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
<script>
    // Show success message if provided
    var msg = '<%= request.getParameter("msg") != null ? request.getParameter("msg") : "" %>';
    if (msg === 'registered') {
        toastr.success('✅ Student registered successfully!', 'Success', {
            positionClass: "toast-top-right",
            timeOut: 4000,
            progressBar: true
        });
    } else if (msg === 'deleted') {
        toastr.info('🗑️ Student deleted successfully!', 'Info', {
            positionClass: "toast-top-right",
            timeOut: 4000,
            progressBar: true
        });
    }

    // Smooth animations
    document.querySelectorAll('.stat-card').forEach((card, index) => {
        card.style.animation = `slideUp 0.6s ease ${index * 0.1}s forwards`;
        card.style.opacity = '0';
    });

    const style = document.createElement('style');
    style.textContent = `
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    `;
    document.head.appendChild(style);

    // Quick-create removed
</script>

</body>
</html>
