<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Login | PrepTrack</title>

    <link rel="stylesheet" href="css/style.css">
   <style>
    * {
        box-sizing: border-box;
    }

    body {
        margin: 0;
        min-height: 100vh;
        padding: 24px 16px;
        font-family: "Segoe UI", Arial, sans-serif;
        background: #f1f5f9;
        color: #1e293b;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .center {
        width: 100%;
        max-width: 440px;
    }

    .card {
        background: #ffffff;
        border: 1px solid #e2e8f0;
        border-radius: 16px;
        box-shadow: 0 10px 35px rgba(15, 23, 42, 0.08);
    }

    .form {
        padding: 36px;
    }

    h1 {
        margin: 0 0 10px;
        color: #1e3a8a;
        text-align: center;
        font-size: 32px;
        font-weight: 800;
        letter-spacing: -0.7px;
    }

    .muted {
        margin: 0 0 28px;
        color: #64748b;
        text-align: center;
        font-size: 14px;
        line-height: 1.6;
    }

    label {
        display: block;
        margin-bottom: 19px;
        color: #334155;
        font-size: 14px;
        font-weight: 650;
    }

    input {
        display: block;
        width: 100%;
        min-height: 46px;
        margin-top: 8px;
        padding: 12px 13px;
        border: 1px solid #cbd5e1;
        border-radius: 9px;
        background: #ffffff;
        color: #1e293b;
        font-family: inherit;
        font-size: 14px;
        outline: none;
        transition: border-color 0.2s, box-shadow 0.2s;
    }

    input::placeholder {
        color: #94a3b8;
    }

    input:focus {
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
    }

    .btn {
        display: block;
        width: 100%;
        margin-top: 8px;
        padding: 13px 16px;
        border: none;
        border-radius: 9px;
        background: #1e3a8a;
        color: #ffffff;
        font-family: inherit;
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
        transition: background 0.2s, transform 0.2s;
    }

    .btn:hover {
        background: #2563eb;
        transform: translateY(-1px);
    }

    .error {
        margin-bottom: 20px;
        padding: 13px 15px;
        border: 1px solid #fecaca;
        border-radius: 9px;
        background: #fef2f2;
        color: #b91c1c;
        font-size: 14px;
        line-height: 1.5;
    }

    .register-link {
        margin-top: 22px;
        text-align: center;
        color: #64748b;
        font-size: 14px;
        line-height: 1.8;
    }

    .register-link a {
        color: #2563eb;
        font-weight: 700;
        text-decoration: none;
    }

    .register-link a:hover {
        text-decoration: underline;
    }

    @media (max-width: 480px) {
        .form {
            padding: 28px 22px;
        }

        h1 {
            font-size: 28px;
        }
    }
</style>

</head>

<body>

<div class="center">

    <form class="card form"
          method="post"
          action="login">

        <h1>PrepTrack</h1>

        <p class="muted">
            Examination Management System
        </p>

        <% if (request.getAttribute("error") != null) { %>

            <div class="error">
                <%= request.getAttribute("error") %>
            </div>

        <% } %>

        <label>
            Email

            <input
                type="email"
                name="email"
                placeholder="Enter your email"
                required>
        </label>

        <label>
            Password

            <input
                type="password"
                name="password"
                placeholder="Enter your password"
                required>
        </label>

        <button class="btn" type="submit">
            Login
        </button>

    </form>
    <div class="register-link">
    Don't have an account?
    <a href="${pageContext.request.contextPath}/register.jsp">
        Register as Student
    </a>
</div>

</div>

</body>

</html>