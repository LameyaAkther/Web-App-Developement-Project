<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Add Faculty - PrepTrack</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f4f6f9;
        }

        .navbar {
            height: 65px;
            background: #1e293b;
            color: white;

            display: flex;
            align-items: center;
            justify-content: space-between;

            padding: 0 35px;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
        }

        .back {
            text-decoration: none;
            color: white;
            background: #2563eb;
            padding: 9px 16px;
            border-radius: 6px;
        }

        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 0 20px;
        }

        .form-card {
            background: white;
            padding: 35px;
            border-radius: 10px;

            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
        }

        h1 {
            color: #1e293b;
            margin-bottom: 8px;
        }

        .subtitle {
            color: #64748b;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            color: #334155;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 12px;

            border: 1px solid #cbd5e1;
            border-radius: 6px;

            font-size: 15px;
        }

        input:focus {
            outline: none;
            border-color: #2563eb;
        }

        .department {
            background: #f1f5f9;
            color: #475569;
        }

        button {
            width: 100%;
            padding: 12px;

            border: none;
            border-radius: 6px;

            background: #16a34a;
            color: white;

            font-size: 16px;
            font-weight: bold;

            cursor: pointer;
        }

        button:hover {
            background: #15803d;
        }

        .note {
            margin-top: 15px;
            padding: 12px;

            background: #eff6ff;
            color: #1e40af;

            border-radius: 6px;

            font-size: 14px;
        }

    </style>

</head>

<body>

    <div class="navbar">

        <div class="logo">
            PrepTrack
        </div>

        <a class="back"
           href="<%= request.getContextPath() %>/admin/faculty">
            ← Faculty List
        </a>

    </div>


    <div class="container">

        <div class="form-card">

            <h1>👨‍🏫 Add Faculty</h1>

            <p class="subtitle">
                Create a new ICT faculty account.
            </p>


            <form
                action="<%= request.getContextPath() %>/admin/faculty/add"
                method="post">


                <div class="form-group">

                    <label for="name">
                        Faculty Name
                    </label>

                    <input
                        type="text"
                        id="name"
                        name="name"
                        placeholder="Enter faculty name"
                        required>

                </div>


                <div class="form-group">

                    <label for="email">
                        Email
                    </label>

                    <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="Enter faculty email"
                        required>

                </div>


                <div class="form-group">

                    <label for="department">
                        Department
                    </label>

                    <input
                        type="text"
                        class="department"
                        value="ICT"
                        readonly>

                </div>


                <div class="form-group">

                    <label for="password">
                        Temporary Password
                    </label>

                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Minimum 6 characters"
                        minlength="6"
                        required>

                </div>


                <button type="submit">
                    Create Faculty Account
                </button>

            </form>


            <div class="note">

                💡 The faculty member can use this
                email and password to log in to PrepTrack.

            </div>

        </div>

    </div>

</body>

</html>