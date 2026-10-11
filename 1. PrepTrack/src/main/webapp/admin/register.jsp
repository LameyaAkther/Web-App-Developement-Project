<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Create Admin | PrepTrack</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f6f9;

            display: flex;
            justify-content: center;
            align-items: center;

            min-height: 100vh;
        }

        .card {

            width: 420px;
            max-width: 90%;

            background: white;

            padding: 35px;

            border-radius: 12px;

            box-shadow:
                0 4px 15px rgba(0,0,0,0.10);
        }

        h1 {
            margin-top: 0;
            text-align: center;
        }

        .subtitle {
            text-align: center;
            color: #6b7280;
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 11px;

            margin-top: 6px;

            border: 1px solid #d1d5db;
            border-radius: 6px;

            font-size: 15px;
        }

        button {
            width: 100%;

            margin-top: 25px;

            padding: 12px;

            border: none;
            border-radius: 6px;

            background: #2563eb;
            color: white;

            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background: #1d4ed8;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;

            padding: 10px;

            border-radius: 6px;

            margin-bottom: 15px;
        }

        .note {
            margin-top: 20px;

            font-size: 13px;

            color: #6b7280;

            text-align: center;
        }

    </style>

</head>


<body>


<div class="card">

    <h1>PrepTrack</h1>

    <div class="subtitle">
        Create Administrator Account
    </div>


    <%
        if (request.getAttribute("error") != null) {
    %>

        <div class="error">
            <%= request.getAttribute("error") %>
        </div>

    <%
        }
    %>


    <form method="post"
          action="<%= request.getContextPath() %>/admin/register">


        <label>
            Admin Name
        </label>

        <input
            type="text"
            name="name"
            placeholder="Enter admin name"
            required>


        <label>
            Email
        </label>

        <input
            type="email"
            name="email"
            placeholder="admin@example.com"
            required>


        <label>
            Password
        </label>

        <input
            type="password"
            name="password"
            placeholder="Minimum 6 characters"
            required>


        <label>
            Confirm Password
        </label>

        <input
            type="password"
            name="confirmPassword"
            placeholder="Confirm password"
            required>


        <button type="submit">
            Create Admin Account
        </button>

    </form>


    <div class="note">

        Administrator account will have
        <strong>ADMIN</strong> privileges.

    </div>

</div>


</body>

</html>