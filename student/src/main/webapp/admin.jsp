<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body.login-page {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-card {
            background: rgba(255,255,255,0.95);
            padding: 32px;
            border-radius: 12px;
            box-shadow: 0 12px 40px rgba(0,0,0,0.25);
            width: 100%;
            max-width: 420px;
        }

        .login-card h1 {
            margin-bottom: 8px;
            font-size: 24px;
            color: #333;
            display:flex;
            align-items:center;
            gap:10px;
        }

        .login-note {
            color: #666;
            font-size: 13px;
            margin-bottom: 18px;
        }

        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px;
            border-radius: 8px;
            width: 100%;
            cursor: pointer;
            font-size: 16px;
            font-weight: 700;
        }

        .back-row {
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-top:12px;
        }
    </style>
</head>

<body class="login-page">
<!-- topbar with Create Student button -->
<div style="width:100%; background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%); padding:10px 0; box-shadow:0 4px 10px rgba(0,0,0,0.12); position:fixed; top:0; left:0; z-index:1000;">
    <div style="max-width:1200px; margin:0 auto; display:flex; justify-content:space-between; align-items:center; padding:0 20px; color:white;">
        <div style="display:flex; align-items:center; gap:12px; font-weight:700;">
            <i class="fas fa-graduation-cap" style="font-size:18px; color:#67a0ff"></i>
            Student Management
        </div>
        <div></div>
    </div>
</div>

<div style="height:72px"></div>

<div class="login-card">

    <h1><i class="fas fa-user-shield"></i> Admin Login</h1>
    <div class="login-note">Enter your administrator credentials to access the dashboard.</div>

    <!-- ================= ERROR MESSAGE ================= -->
    <%
        String error = request.getParameter("error");
        if (error != null) {
    %>
        <p class="error">Invalid username or password</p>
    <%
        }
    %>

    <!-- ================= LOGIN FORM ================= -->
    <!-- IMPORTANT: action must match servlet mapping -->
    <form action="adminLogin" method="post">

        <label for="username">Username</label>
        <input type="text"
               id="username"
               name="username"
               placeholder="Enter username"
               required>

        <label for="password">Password</label>
        <input type="password"
               id="password"
               name="password"
               placeholder="Enter password"
               required>

            <button type="submit" class="btn-login">Login <i class="fas fa-arrow-right" style="margin-left:8px"></i></button>
    </form>

        <div class="back-row">
            <a href="index.jsp" class="btn-link">&larr; Go Back</a>
        </div>

    </div>

</body>
</html>
