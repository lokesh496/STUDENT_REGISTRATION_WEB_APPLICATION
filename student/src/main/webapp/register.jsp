<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register Student - Admin Panel</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .form-container {
            background: white;
            padding: 36px;
            border-radius: 10px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
            width: 100%;
            max-width: 520px;
            animation: slideUp 0.45s ease;
        }

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

        .form-header {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .form-header h1 {
            font-size: 28px;
            color: #333;
            margin-bottom: 5px;
        }

        .form-header p {
            color: #999;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            color: #667eea;
            font-size: 18px;
            pointer-events: none;
        }

        input, select {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        select {
            padding-left: 45px;
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23667eea' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 15px center;
            padding-right: 40px;
        }

        .input-hint {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        button, .btn {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 14px;
            text-decoration: none;
            text-align: center;
            display: inline-block;
        }

        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }

        .btn-cancel {
            background: #f0f0f0;
            color: #333;
            border: 2px solid #e0e0e0;
        }

        .btn-cancel:hover {
            background: #e0e0e0;
            transform: translateY(-2px);
        }

        .loading-spinner {
            display: none;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255,255,255,0.3);
            border-top: 2px solid white;
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            margin-right: 8px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            border-left: 4px solid #c62828;
            display: none;
            font-size: 14px;
        }

        .success-message {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            border-left: 4px solid #2e7d32;
            display: none;
            font-size: 14px;
        }

        .form-features {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #f0f0f0;
        }

        .feature {
            text-align: center;
            font-size: 12px;
            color: #999;
        }

        .feature i {
            font-size: 20px;
            color: #667eea;
            margin-bottom: 5px;
            display: block;
        }

        @media (max-width: 600px) {
            .form-container {
                padding: 25px;
            }

            .form-header h1 {
                font-size: 24px;
            }

            .form-actions {
                flex-direction: column;
            }

            .form-features {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<!-- simple top bar -->
<div style="width:100%; background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%); padding:10px 0; box-shadow:0 4px 10px rgba(0,0,0,0.15);">
    <div style="max-width:1200px; margin:0 auto; display:flex; justify-content:space-between; align-items:center; padding:0 20px; color:white;">
        <div style="display:flex; align-items:center; gap:12px; font-weight:700;">
            <i class="fas fa-graduation-cap" style="font-size:20px; color:#67a0ff"></i>
            Student Management
        </div>
        <a href="adminHome" style="color:white; text-decoration:none; font-weight:600;">Dashboard</a>
    </div>
</div>

<div class="form-container">
    <!-- Header -->
    <div class="form-header">
        <h1>👤 Register New Student</h1>
        <p>Add a new student to the system</p>
    </div>

    <!-- Error/Success Messages -->
    <div class="error-message" id="errorMsg"></div>
    <div class="success-message" id="successMsg"></div>

    <!-- Registration Form -->
    <form id="registerForm" method="POST" action="register" onsubmit="return validateForm()">
        
        <!-- Full Name -->
        <div class="form-group">
            <label for="name">👤 Full Name</label>
            <div class="input-wrapper">
                <i class="fas fa-user input-icon"></i>
                <input type="text" id="name" name="name" placeholder="Enter student's full name" 
                       required minlength="3" maxlength="100">
            </div>
            <div class="input-hint">Minimum 3 characters, maximum 100</div>
        </div>

        <!-- Email -->
        <div class="form-group">
            <label for="email">📧 Email Address</label>
            <div class="input-wrapper">
                <i class="fas fa-envelope input-icon"></i>
                <input type="email" id="email" name="email" placeholder="Enter email address" 
                       required>
            </div>
            <div class="input-hint">Must be a valid email address</div>
        </div>

        <!-- Course Selection -->
        <div class="form-group">
            <label for="course">📚 Course</label>
            <div class="input-wrapper">
                <i class="fas fa-book input-icon"></i>
                <select id="course" name="course" required>
                    <option value="">-- Select a Course --</option>
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
            </div>
        </div>

        <!-- Phone Number (Optional) -->
        <div class="form-group">
            <label for="phone">📱 Phone Number (Optional)</label>
            <div class="input-wrapper">
                <i class="fas fa-phone input-icon"></i>
                <input type="tel" id="phone" name="phone" placeholder="Enter phone number" 
                       pattern="[0-9]{10}" maxlength="15">
            </div>
            <div class="input-hint">10-15 digits (optional)</div>
        </div>

        <!-- Form Actions -->
        <div class="form-actions">
            <button type="submit" class="btn btn-submit">
                <span class="loading-spinner" id="spinner"></span>
                <span id="btnText">✅ Register Student</span>
            </button>
            <a href="adminHome" class="btn btn-cancel">← Cancel</a>
        </div>
    </form>

    <!-- Features -->
    <div class="form-features">
        <div class="feature">
            <i class="fas fa-shield-alt"></i>
            <strong>Secure</strong>
        </div>
        <div class="feature">
            <i class="fas fa-bolt"></i>
            <strong>Fast</strong>
        </div>
        <div class="feature">
            <i class="fas fa-check-circle"></i>
            <strong>Validated</strong>
        </div>
        <div class="feature">
            <i class="fas fa-database"></i>
            <strong>Saved</strong>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
<script>
    // Handle URL parameters for errors
    const urlParams = new URLSearchParams(window.location.search);
    const error = urlParams.get('error');

    if (error) {
        let errorText = '';
        switch(error) {
            case 'invalid_name':
                errorText = '❌ Invalid name! Must be 3-100 characters, letters and spaces only.';
                break;
            case 'invalid_email':
                errorText = '❌ Invalid email address! Please enter a valid email.';
                break;
            case 'invalid_course':
                errorText = '❌ Invalid course selected!';
                break;
            case 'duplicate_email':
                errorText = '❌ This email is already registered! Use a different email.';
                break;
            default:
                errorText = '❌ An error occurred. Please try again.';
        }
        
        document.getElementById('errorMsg').textContent = errorText;
        document.getElementById('errorMsg').style.display = 'block';
        
        toastr.error(errorText, 'Registration Failed', {
            positionClass: "toast-top-right",
            timeOut: 5000,
            progressBar: true
        });
    }

    function validateForm() {
        const name = document.getElementById('name').value.trim();
        const email = document.getElementById('email').value.trim();
        const course = document.getElementById('course').value;

        // Basic validation
        if (name.length < 3) {
            showError('Name must be at least 3 characters long');
            return false;
        }

        if (!email.includes('@')) {
            showError('Please enter a valid email address');
            return false;
        }

        if (!course) {
            showError('Please select a course');
            return false;
        }

        // Show loading state
        const spinner = document.getElementById('spinner');
        const btnText = document.getElementById('btnText');
        spinner.style.display = 'inline-block';
        btnText.textContent = ' Registering...';
        
        return true;
    }

    function showError(message) {
        toastr.error(message, 'Validation Error', {
            positionClass: "toast-top-right",
            timeOut: 4000,
            progressBar: true
        });
    }

    // Add focus effects
    document.querySelectorAll('input, select').forEach(field => {
        field.addEventListener('focus', function() {
            this.parentElement.style.transform = 'scale(1.02)';
        });

        field.addEventListener('blur', function() {
            this.parentElement.style.transform = 'scale(1)';
        });
    });

    // Show success toast if registered
    var msg = '<%= request.getParameter("msg") != null ? request.getParameter("msg") : "" %>';
    if (msg === 'registered') {
        toastr.success('✅ Student registered successfully!', 'Success', {
            positionClass: "toast-top-right",
            timeOut: 4000,
            progressBar: true
        });
    }
</script>

</body>
</html>
