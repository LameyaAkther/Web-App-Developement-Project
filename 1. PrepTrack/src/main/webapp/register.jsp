<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Student Registration | PrepTrack</title>

    <link rel="stylesheet" href="css/style.css">

   <style>
    * {
        box-sizing: border-box;
    }

    body {
        margin: 0;
        min-height: 100vh;
        padding: 28px 16px;
        font-family: "Segoe UI", Arial, sans-serif;
        background: #f1f5f9;
        color: #1e293b;
    }

    .register-container {
        width: min(560px, 100%);
        margin: 20px auto;
    }

    .card {
        background: #ffffff;
        padding: 36px;
        border: 1px solid #e2e8f0;
        border-radius: 16px;
        box-shadow: 0 10px 35px rgba(15, 23, 42, 0.08);
    }

    .register-header {
        text-align: center;
        margin-bottom: 28px;
    }

    .badge {
        display: inline-block;
        padding: 7px 13px;
        background: #dbeafe;
        color: #1e40af;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 800;
        letter-spacing: 1px;
        margin-bottom: 16px;
    }

    .register-header h1 {
        margin: 0 0 10px;
        color: #1e3a8a;
        font-size: 27px;
        letter-spacing: -0.5px;
    }

    .register-header p {
        color: #64748b;
        font-size: 14px;
        line-height: 1.6;
    }

    .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
    }

    .form-group {
        margin-bottom: 17px;
        min-width: 0;
    }

    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-size: 14px;
        font-weight: 650;
        color: #334155;
    }

    .required {
        color: #dc2626;
    }

    .form-group input,
    .form-group select {
        display: block;
        width: 100%;
        min-height: 45px;
        padding: 11px 12px;
        border: 1px solid #cbd5e1;
        border-radius: 9px;
        background: #ffffff;
        color: #1e293b;
        font-family: inherit;
        font-size: 14px;
        outline: none;
        transition: border-color 0.2s, box-shadow 0.2s;
    }

    .form-group input::placeholder {
        color: #94a3b8;
    }

    .form-group input:focus,
    .form-group select:focus {
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
    }

    .error-message {
        background: #fef2f2;
        color: #b91c1c;
        border: 1px solid #fecaca;
        padding: 13px 15px;
        border-radius: 9px;
        margin-bottom: 20px;
        font-size: 14px;
        line-height: 1.5;
    }

    .success-message {
        background: #dcfce7;
        color: #166534;
        border: 1px solid #bbf7d0;
        padding: 13px 15px;
        border-radius: 9px;
        margin-bottom: 20px;
        font-size: 14px;
    }

    .password-hint {
        font-size: 12px;
        color: #64748b;
        margin-top: 6px;
    }

    .register-btn {
        display: block;
        width: 100%;
        margin-top: 10px;
        padding: 13px 16px;
        background: #1e3a8a;
        color: #ffffff;
        border: none;
        border-radius: 9px;
        cursor: pointer;
        font-family: inherit;
        font-size: 15px;
        font-weight: 700;
        transition: background 0.2s, transform 0.2s;
    }

    .register-btn:hover {
        background: #2563eb;
        transform: translateY(-1px);
    }

    .login-link {
        text-align: center;
        margin-top: 24px;
        color: #64748b;
        font-size: 14px;
    }

    .login-link a {
        color: #2563eb;
        text-decoration: none;
        font-weight: 700;
    }

    .login-link a:hover {
        text-decoration: underline;
    }

    @media (max-width: 600px) {
        body {
            padding: 14px 10px;
        }

        .register-container {
            margin: 10px auto;
        }

        .card {
            padding: 25px 20px;
            border-radius: 12px;
        }

        .register-header h1 {
            font-size: 23px;
        }

        .form-row {
            grid-template-columns: 1fr;
            gap: 0;
        }
    }
</style>

</head>


<body>

<div class="register-container">

    <div class="card">

        <div class="register-header">

            <span class="badge">
                PREPTRACK
            </span>

            <h1>Create Student Account</h1>

            <p>
                Register to access your examination information.
            </p>

        </div>


        <!-- Error message from RegisterServlet -->

        <% if (request.getAttribute("error") != null) { %>

            <div class="error-message">

                <%= request.getAttribute("error") %>

            </div>

        <% } %>


        <!-- Registration Form -->

        <form method="post"
              action="register"
              onsubmit="return validateRegistration()">


            <!-- Name -->

            <div class="form-group">

                <label for="name">
                    Full Name
                    <span class="required">*</span>
                </label>

                <input
                    type="text"
                    id="name"
                    name="name"
                    placeholder="Enter your full name"
                    required>

            </div>


            <!-- Email -->

            <div class="form-group">

                <label for="email">
                    Email Address
                    <span class="required">*</span>
                </label>

                <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="example@email.com"
                    required>

            </div>


            <!-- Roll + Department -->

            <div class="form-row">

                <div class="form-group">

                    <label for="rollNo">
                        Roll Number
                        <span class="required">*</span>
                    </label>

                    <input
                        type="text"
                        id="rollNo"
                        name="rollNo"
                        placeholder="221-15-001"
                        required>

                </div>


                <div class="form-group">

                    <label for="department">
                        Department
                        <span class="required">*</span>
                    </label>

                    <select
                        id="department"
                        name="department"
                        required>

                        <option value="">Select Department</option>
<option value="ICT">Information and Communication Technology</option>

                    </select>

                </div>

            </div>


            <!-- Semester + Section -->

            <div class="form-row">

                <div class="form-group">

                    <label for="semester">
                        Semester
                        <span class="required">*</span>
                    </label>

                    <select
                        id="semester"
                        name="semester"
                        required>

                        <option value="">
                            Select Semester
                        </option>

                        <option value="1">1st Semester</option>
                        <option value="2">2nd Semester</option>
                        <option value="3">3rd Semester</option>
                        <option value="4">4th Semester</option>
                        <option value="5">5th Semester</option>
                        <option value="6">6th Semester</option>
                        <option value="7">7th Semester</option>
                        <option value="8">8th Semester</option>

                    </select>

                </div>


                <div class="form-group">

                    <label for="section">
                        Section
                    </label>

                    <input
                        type="text"
                        id="section"
                        name="section"
                        placeholder="Example: A">

                </div>

            </div>


            <!-- Password -->

            <div class="form-group">

                <label for="password">
                    Password
                    <span class="required">*</span>
                </label>

                <input
                    type="password"
                    id="password"
                    name="password"
                    placeholder="Create a password"
                    minlength="6"
                    required>

                <div class="password-hint">
                    Minimum 6 characters.
                </div>

            </div>


            <!-- Confirm Password -->

            <div class="form-group">

                <label for="confirmPassword">
                    Confirm Password
                    <span class="required">*</span>
                </label>

                <input
                    type="password"
                    id="confirmPassword"
                    name="confirmPassword"
                    placeholder="Enter password again"
                    minlength="6"
                    required>

            </div>


            <!-- Submit -->

            <button
                type="submit"
                class="btn register-btn">

                Create Student Account

            </button>


        </form>


        <!-- Login -->

        <div class="login-link">

            Already have an account?

            <a href="login.jsp">
                Login here
            </a>

        </div>

    </div>

</div>


<script>

function validateRegistration() {

    const password =
        document.getElementById("password").value;

    const confirmPassword =
        document.getElementById("confirmPassword").value;

    const email =
        document.getElementById("email").value.trim();

    const rollNo =
        document.getElementById("rollNo").value.trim();


    // Password length

    if (password.length < 6) {

        alert("Password must contain at least 6 characters.");

        return false;
    }


    // Password confirmation

    if (password !== confirmPassword) {

        alert("Passwords do not match.");

        return false;
    }


    // Basic email validation

    const emailPattern =
        /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!emailPattern.test(email)) {

        alert("Please enter a valid email address.");

        return false;
    }


    // Roll number validation

    if (rollNo.length < 3) {

        alert("Please enter a valid roll number.");

        return false;
    }


    return true;
}

</script>


</body>

</html>