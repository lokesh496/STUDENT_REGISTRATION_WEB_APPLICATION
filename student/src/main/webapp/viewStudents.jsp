<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.student.model.Student" %>

<!DOCTYPE html>
<html>
<head>
    <title>Registered Students</title>
    <link rel="stylesheet" href="style.css">

    <style>
        body {
            background: linear-gradient(135deg, #1e3c72, #2a5298);
            font-family: Arial, sans-serif;
        }

        .box {
            width: 900px;
            margin: 80px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        th {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 18px 16px;
            text-align: left;
            font-weight: 600;
            letter-spacing: 0.5px;
            border-bottom: 3px solid #1a252f;
            font-size: 15px;
        }

        td {
            padding: 15px 16px;
            border-bottom: 1px solid #ecf0f1;
            font-size: 14px;
            color: #2c3e50;
        }

        tr:hover {
            background-color: #f8f9fa;
            transition: background-color 0.2s ease;
        }

        tr:nth-child(even) {
            background-color: #f5f6fa;
        }

        .delete-btn {
            background: #e74c3c;
            color: white;
            padding: 10px 18px;
            border-radius: 4px;
            text-decoration: none;
            border: none;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            font-size: 13px;
        }

        .delete-btn:hover {
            background: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(231, 76, 60, 0.3);
        }

        .back-btn {
            margin-top: 25px;
            display: inline-block;
            background: #27ae60;
            color: white;
            padding: 12px 28px;
            border-radius: 6px;
            text-decoration: none;
        }

        .back-btn:hover {
            background: #1e8449;
        }
    </style>
</head>

<body>

<div class="box">
    <h1>Registered Students</h1>

    <table>
        <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Course</th>
            <th>Actions</th>
        </tr>

        <%
            List<Student> students =
                (List<Student>) request.getAttribute("students");

            if (students == null || students.isEmpty()) {
        %>
            <tr>
                <td colspan="4" style="color:red; font-weight:bold;">
                    No students registered
                </td>
            </tr>
        <%
            } else {
                for (Student s : students) {
        %>
            <tr>
                <td><%= s.getName() %></td>
                <td><%= s.getEmail() %></td>
                <td><%= s.getCourse() %></td>
                <td>
                    <!-- 🔴 FIXED DELETE URL -->
                    <a class="delete-btn"
                       href="deleteStudent?id=<%= s.getId() %>"
                       onclick="return confirm('Are you sure you want to delete this student?');">
                       Delete
                    </a>
                </td>
            </tr>
        <%
                }
            }
        %>
    </table>

    <a href="adminHome" class="back-btn">← Go Back</a>
</div>

</body>
</html>
