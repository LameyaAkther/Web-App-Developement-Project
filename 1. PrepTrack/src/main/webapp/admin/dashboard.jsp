<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.preptrack.model.User" %>

<%
    User admin = (User) request.getAttribute("admin");

    if (admin == null) {
        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>Admin Dashboard - PrepTrack</title>

 <style>
    :root {
        --primary: #1e3a8a;
        --primary-light: #2563eb;
        --background: #f1f5f9;
        --surface: #ffffff;
        --text: #1e293b;
        --muted: #64748b;
        --border: #e2e8f0;
        --shadow: 0 4px 18px rgba(15, 23, 42, 0.06);
    }

    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }

    body {
        font-family: "Segoe UI", Arial, sans-serif;
        background: var(--background);
        color: var(--text);
        line-height: 1.6;
    }

    /* Navigation */
    .navbar {
        min-height: 70px;
        background: var(--primary);
        color: white;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 16px;
        padding: 14px 5%;
        box-shadow: 0 3px 12px rgba(15, 23, 42, 0.15);
    }

    .logo {
        font-size: 26px;
        font-weight: 800;
        letter-spacing: -0.5px;
    }

    .admin-info {
        display: flex;
        align-items: center;
        gap: 18px;
        flex-wrap: wrap;
    }

    .logout {
        text-decoration: none;
        color: white;
        background: #dc2626;
        padding: 9px 17px;
        border-radius: 8px;
        font-weight: 600;
        transition: background 0.2s;
    }

    .logout:hover {
        background: #b91c1c;
    }

    /* Main layout */
    .container {
        width: 100%;
        max-width: 1450px;
        margin: 0 auto;
        padding: 36px 5%;
    }

    .welcome {
        margin-bottom: 30px;
    }

    .welcome h1 {
        font-size: clamp(26px, 3vw, 34px);
        color: var(--text);
        margin-bottom: 8px;
        letter-spacing: -0.6px;
    }

    .welcome p {
        color: var(--muted);
        font-size: 15px;
    }

    /* Summary cards */
    .cards {
        display: grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 20px;
    }

    .card {
        background: var(--surface);
        padding: 25px;
        border: 1px solid var(--border);
        border-radius: 14px;
        box-shadow: var(--shadow);
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .card:hover {
        transform: translateY(-4px);
        box-shadow: 0 10px 24px rgba(15, 23, 42, 0.09);
    }

    .card-icon {
        font-size: 34px;
        margin-bottom: 12px;
    }

    .card h3 {
        color: var(--text);
        font-size: 18px;
        margin-bottom: 7px;
    }

    .card p {
        color: var(--muted);
        font-size: 14px;
    }

    /* Management modules */
    .section-title {
        margin: 40px 0 20px;
        color: var(--text);
        font-size: 23px;
        font-weight: 750;
    }

    .modules {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 22px;
    }

    .module {
        min-width: 0;
        background: var(--surface);
        padding: 25px;
        border: 1px solid var(--border);
        border-radius: 14px;
        box-shadow: var(--shadow);
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .module:hover {
        transform: translateY(-3px);
        box-shadow: 0 9px 22px rgba(15, 23, 42, 0.08);
    }

    .module h3 {
        font-size: 18px;
        line-height: 1.5;
        margin-bottom: 10px;
        color: var(--text);
    }

    .module p {
        color: var(--muted);
        margin-bottom: 16px;
        font-size: 14px;
    }

    /* Buttons and links */
    .module-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
        border: none;
        text-decoration: none;
        background: var(--primary-light);
        color: white;
        padding: 10px 17px;
        border-radius: 8px;
        font-family: inherit;
        font-size: 14px;
        font-weight: 650;
        cursor: pointer;
        transition: background 0.2s, transform 0.2s;
    }

    .module-btn:hover {
        background: var(--primary);
        transform: translateY(-1px);
    }

    .module-btn:focus-visible,
    .logout:focus-visible {
        outline: 3px solid #93c5fd;
        outline-offset: 3px;
    }

    .module form {
        margin-top: 4px;
    }

    /* Seating allocation summary */
    .module h4 {
        font-size: 16px;
        margin-bottom: 10px;
        color: var(--primary);
    }

    .module > div[style*="border-bottom"] {
        margin-top: 10px;
    }

    .module > div[style*="border-bottom"] p {
        margin: 5px 0;
    }

    /* Responsive design */
    @media (max-width: 1000px) {
        .cards {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .modules {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }
    }

    @media (max-width: 600px) {
        .navbar {
            align-items: flex-start;
            flex-direction: column;
            padding: 16px 5%;
        }

        .admin-info {
            gap: 12px;
        }

        .container {
            padding: 25px 5%;
        }

        .cards,
        .modules {
            grid-template-columns: 1fr;
        }

        .card,
        .module {
            padding: 20px;
        }

        .section-title {
            margin-top: 30px;
            font-size: 21px;
        }
    }
</style>

</head>

<body>

    <!-- Navbar -->

    <div class="navbar">

        <div class="logo">
            PrepTrack
        </div>

        <div class="admin-info">

            <span>
                👤 <%= admin.getName() %>
            </span>

            <a class="logout"
               href="<%= request.getContextPath() %>/logout">
                Logout
            </a>

        </div>

    </div>


    <!-- Main Content -->

    <div class="container">

        <div class="welcome">

            <h1>
                Admin Dashboard
            </h1>

            <p>
                Welcome, <strong><%= admin.getName() %></strong>.
                Manage the PrepTrack examination system from here.
            </p>

        </div>


        <!-- Statistics -->

        <div class="cards">

            <div class="card">

                <div class="card-icon">
                    👨‍🎓
                </div>

                <h3>
                    Students
                </h3>

                <p>
                    Manage registered ICT students.
                </p>

            </div>


            <div class="card">

                <div class="card-icon">
                    👨‍🏫
                </div>

                <h3>
                    Faculty
                </h3>

                <p>
                    Manage faculty members.
                </p>

            </div>


            <div class="card">

                <div class="card-icon">
                    🏫
                </div>

                <h3>
                    Rooms
                </h3>

                <p>
                    Manage examination rooms.
                </p>

            </div>


            <div class="card">

                <div class="card-icon">
                    📝
                </div>

                <h3>
                    Exams
                </h3>

                <p>
                    Create and manage examinations.
                </p>

            </div>

        </div>


        <!-- Management Modules -->

        <h2 class="section-title">
            Management Modules
        </h2>


        <div class="modules">

            <div class="module">

                <h3>
                    👨‍🎓 Student Management
                </h3>

                <p>
                    View and manage ICT department students.
                </p>

               <a href="<%= request.getContextPath() %>/admin/students"
   class="module-btn">
    Manage Students
</a>

            </div>


            <div class="module">

                <h3>
                    👨‍🏫 Faculty Management
                </h3>

                <p>
                    Add, update and manage faculty members.
                </p>

               <a href="<%= request.getContextPath() %>/admin/faculty"
   class="module-btn">
    Manage Faculty
</a>

            </div>


            <div class="module">

                <h3>
                    🏫 Room Management
                </h3>

                <p>
                    Manage examination rooms and capacities.
                </p>

               <a href="<%= request.getContextPath() %>/admin/rooms"
   class="module-btn">
    Manage Rooms
</a>

            </div>


            <div class="module">

                <h3>
                    📚 Course Management
                </h3>

                <p>
                    Manage courses for the ICT department.
                </p>

               <a href="<%= request.getContextPath() %>/admin/courses"
   class="module-btn">
    Manage Courses
</a>
            </div>


           <div class="module">

    <h3>
        📝 Exam Management
    </h3>

    <p>
        Create and schedule examinations.
    </p>

    <a href="<%= request.getContextPath() %>/admin/exams"
       class="module-btn">
        Manage Exams
    </a>

</div>


            <div class="module">

                <h3>
                    💺 Seat Allocation
                </h3>

                <p>
                    Automatically allocate students to exam seats.
                </p>

               <form action="${pageContext.request.contextPath}/admin/seats/allocate"
      method="post">
    <input type="hidden" name="examId" value="1">
    <button type="submit" class="module-btn">
        Allocate Seats
    </button>
</form>

            </div>


            <div class="module">

                <h3>
                    👮 Invigilation Duty
                </h3>

                <p>
                    Assign faculty members to examination rooms.
                </p>

               
<a href="${pageContext.request.contextPath}/admin/duties"
   class="module-btn">
    Assign Duties
</a>


            </div>


            <div class="module">

                <h3>
                    📊 Reports
                </h3>

                <p>
                    View examination and allocation reports.
                </p>

               <a href="${pageContext.request.contextPath}/admin/reports"
   class="module-btn">
    View Reports
</a>

            </div>
            <!-- Seating Allocation Summary -->
<div class="module" style="grid-column: 1 / -1;">
    <h3>🪑 Seating Allocation Summary</h3>

    <%
        java.util.List<java.util.Map<String, Object>> seatSummary =
            (java.util.List<java.util.Map<String, Object>>)
            request.getAttribute("examSeatSummary");

        if (seatSummary != null && !seatSummary.isEmpty()) {
            for (java.util.Map<String, Object> item : seatSummary) {
    %>

    <div style="padding:15px 0; border-bottom:1px solid #e2e8f0;">
        <h4>
            <%= item.get("courseCode") %> -
            <%= item.get("courseName") %>
        </h4>

        <p>
            Registered Students:
            <strong><%= item.get("registeredStudents") %></strong>
        </p>

        <p>
            Allocated Students:
            <strong><%= item.get("allocatedStudents") %></strong>
        </p>

        <p>
            Allocated Seats:
            <strong><%= item.get("allocatedSeats") %></strong>
        </p>

        <p>
            Pending Students:
            <strong><%= item.get("pendingStudents") %></strong>
        </p>

        <p>
            Completion:
            <strong><%= item.get("completionPercentage") %>%</strong>
        </p>
    </div>

    <%
            }
        } else {
    %>

    <p>No seating allocation summary available.</p>

    <% } %>
</div>

        </div>

    </div>

</body>
</html>