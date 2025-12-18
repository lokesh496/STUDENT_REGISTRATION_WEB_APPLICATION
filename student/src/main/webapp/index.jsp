<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Registration</title>
    <link rel="preconnect" href="https://cdnjs.cloudflare.com">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <style>
        .page-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg,#2c3e50 0%, #3498db 100%);
            padding: 40px 20px;
        }

        .bottom-actions {
            text-align: center;
            margin-top: 18px;
        }

        .admin-btn {
            display: inline-block;
            background: linear-gradient(135deg,#667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 18px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 700;
            box-shadow: 0 6px 18px rgba(0,0,0,0.12);
        }
    </style>
</head>
<%@ page import="com.student.dao.StudentDao" %>
<%
    StudentDao _dao = new StudentDao();
    int _totalStudents = _dao.getActiveStudentCount();
%>
<body>

<div class="page-wrapper">
    <div>
        <div class="form-container">
            <h1>Student Registration</h1>
            <div id="inline-msg" style="text-align:center; margin-bottom:8px;"></div>

    <!-- SUCCESS MESSAGE -->
    <%
        String success = request.getParameter("success");
        if ("true".equals(success)) {
    %>
        <p class="success">✔ Registered Successfully</p>
    <%
        }
    %>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
        <script>
            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');
            const success = urlParams.get('success');
            if (error) {
                let text = 'An error occurred';
                if (error === 'name' || error === 'invalid_name') text = '❌ Name should contain only alphabets';
                else if (error === 'email' || error === 'invalid_email') text = '❌ Please enter a valid email address';
                else if (error === 'course' || error === 'invalid_course') text = '❌ Please select a valid course';
                else if (error === 'duplicate' || error === 'duplicate_email') text = '❌ This email is already registered for this course';
                else if (error === 'invalid_phone' || error === 'phone') text = '❌ Please enter a valid phone number';
                toastr.error(text, 'Error', { positionClass: 'toast-top-right', timeOut: 4000, progressBar: true });
            }
            if (success === 'true') {
                toastr.success('✅ Registered successfully', 'Success', { positionClass: 'toast-top-right', timeOut: 3500 });
            }
        </script>

        <script>
            (function(){
                const form = document.querySelector('form[action="register"]');
                if (!form) return;

                form.setAttribute('id','registerForm');

                form.addEventListener('submit', function(evt){
                    evt.preventDefault();
                    const fd = new FormData(form);

                    fetch('register', {
                        method: 'POST',
                        body: fd,
                        headers: { 'X-Requested-With': 'XMLHttpRequest' }
                    }).then(r => r.json())
                      .then(j => {
                          if (j && j.status === 'success') {
                              toastr.success('✅ Registered successfully', 'Success', { positionClass: 'toast-top-right', timeOut: 2500 });
                              // Server-side total updated; response may include new total in `j.total`
                              try { if (j && j.total) console.debug('New total:', j.total); } catch(e){}
                              // show inline success message as well
                              try {
                                  const inline = document.getElementById('inline-msg');
                                  if (inline) {
                                      inline.innerHTML = '<p class="success">✔ Registered Successfully</p>';
                                      setTimeout(() => { inline.innerHTML = ''; }, 3500);
                                  }
                              } catch(e){}
                              form.reset();
                          } else {
                              const reason = j && j.reason ? j.reason : 'Registration failed';
                              toastr.error(reason, 'Error', { positionClass: 'toast-top-right', timeOut: 3500 });
                          }
                      }).catch(err => {
                          console.error('AJAX register failed', err);
                          form.removeEventListener('submit', arguments.callee);
                          form.submit();
                      });
                });
            })();
        </script>
    <!-- ERROR MESSAGES -->
    <%
        String error = request.getParameter("error");
        if ("name".equals(error)) {
    %>
        <p class="error">❌ Name should contain only alphabets</p>
    <%
        } else if ("email".equals(error)) {
    %>
        <p class="error">❌ Please enter a valid email address</p>
    <%
        } else if ("course".equals(error)) {
    %>
        <p class="error">❌ Please select a valid course</p>
    <%
        } else if ("duplicate".equals(error)) {
    %>
        <p class="error">❌ This email is already registered for this course</p>
    <%
        } else if ("invalid_phone".equals(error) || "phone".equals(error)) {
    %>
        <p class="error">❌ Please enter a valid phone number</p>
    <%
        }
    %>

    <!-- ✅ FORM STARTS HERE -->
    <form action="register" method="post">

        <label for="name">Name</label>
        <input type="text"
               id="name"
               name="name"
               placeholder="Enter full name (Alphabets only)"
               required
               pattern="[A-Za-z ]+">

        <label for="email">Email</label>
        <input type="email"
               id="email"
               name="email"
               placeholder="Enter valid email address"
               required
               pattern="[A-Za-z][A-Za-z0-9._%+-]*@[A-Za-z0-9.-]+\.[A-Za-z]{2,}"
               title="Email must start with a letter">

        <label for="course">Course</label>
        <select id="course" name="course" required>
            <option value="" disabled selected>-- Select Course --</option>
            <option>Java</option>
            <option>Python</option>
            <option>C</option>
            <option>C++</option>
            <option>DSA</option>
            <option>HTML</option>
            <option>CSS</option>
            <option>JavaScript</option>
            <option>SQL</option>
            <option>React</option>
            <option>Node.js</option>
            <option>Data Science</option>
        </select>

        <label for="phone">Phone</label>
        <input type="tel"
               id="phone"
               name="phone"
               placeholder="Enter phone number (optional)"
               pattern="[0-9+\- ]{7,20}">

        <button type="submit">Register Student</button>
    </form>
    <!-- ✅ FORM ENDS HERE -->

            <div class="bottom-actions">
                <a href="admin.jsp" class="admin-btn">Admin Login</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>
