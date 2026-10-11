<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.preptrack.model.Course" %>

<%
    List<Course> courses =
            (List<Course>) request.getAttribute("courses");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Course Management - PrepTrack</title>

   <style>
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
        font-family: "Segoe UI", Arial, sans-serif;
    }

    body {
        background: #f1f5f9;
        color: #1e293b;
        line-height: 1.6;
    }

    /* Navigation */
    .navbar {
        min-height: 70px;
        background: #1e3a8a;
        color: white;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 14px 5%;
        gap: 16px;
        box-shadow: 0 3px 12px rgba(15, 23, 42, 0.12);
    }

    .logo {
        font-size: 26px;
        font-weight: 800;
        letter-spacing: -0.5px;
    }

    .back {
        text-decoration: none;
        color: white;
        background: #2563eb;
        padding: 10px 17px;
        border-radius: 8px;
        font-weight: 600;
        transition: background 0.2s;
    }

    .back:hover {
        background: #1d4ed8;
    }

    /* Main layout */
    .container {
        width: 100%;
        max-width: 1400px;
        margin: 0 auto;
        padding: 36px 5%;
    }

    .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 20px;
        flex-wrap: wrap;
        margin-bottom: 28px;
    }

    .header h1 {
        color: #1e293b;
        font-size: clamp(24px, 3vw, 32px);
        letter-spacing: -0.5px;
    }

    .header p {
        color: #64748b;
        margin-top: 6px;
        font-size: 15px;
    }

    .course-count {
        background: white;
        padding: 15px 20px;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(15, 23, 42, 0.05);
        color: #334155;
        white-space: nowrap;
    }

    .course-count strong {
        color: #2563eb;
        font-size: 20px;
        margin-left: 5px;
    }

    .header > div:last-child {
        display: flex;
        align-items: center;
        gap: 15px;
        flex-wrap: wrap;
    }

    /* Add course button */
    .add-btn {
        display: inline-block;
        text-decoration: none;
        color: white;
        background: #15803d;
        padding: 11px 18px;
        border-radius: 8px;
        font-weight: 650;
        transition: background 0.2s, transform 0.2s;
    }

    .add-btn:hover {
        background: #166534;
        transform: translateY(-1px);
    }

    /* Course table */
    .table-container {
        background: white;
        border: 1px solid #e2e8f0;
        border-radius: 14px;
        overflow-x: auto;
        box-shadow: 0 4px 18px rgba(15, 23, 42, 0.06);
    }

    table {
        width: 100%;
        border-collapse: collapse;
        text-align: left;
    }

    thead th {
        background: #1e3a8a;
        color: white;
        padding: 16px 18px;
        font-size: 13px;
        font-weight: 700;
        letter-spacing: 0.3px;
        white-space: nowrap;
    }

    tbody td {
        padding: 16px 18px;
        border-bottom: 1px solid #e2e8f0;
        color: #334155;
        font-size: 14px;
        vertical-align: middle;
    }

    tbody tr:last-child td {
        border-bottom: none;
    }

    tbody tr:nth-child(even) {
        background: #f8fafc;
    }

    tbody tr:hover {
        background: #eff6ff;
    }

    .empty {
        text-align: center;
        padding: 45px 20px;
        color: #64748b;
        font-size: 15px;
    }

    /* Responsive */
    @media (max-width: 600px) {
        .navbar {
            align-items: flex-start;
            flex-direction: column;
            padding: 16px 5%;
        }

        .container {
            padding: 24px 4%;
        }

        .header {
            align-items: flex-start;
            flex-direction: column;
        }

        .header > div:last-child {
            width: 100%;
            align-items: flex-start;
        }

        .course-count {
            width: 100%;
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

        <a class="back"
           href="<%= request.getContextPath() %>/admin/dashboard">
            ← Dashboard
        </a>

    </div>


    <!-- Main Content -->

    <div class="container">

        <div class="header">

            <div>

                <h1>📚 Course Management</h1>

                <p>
                    ICT Department Courses
                </p>

            </div>


            <div style="display:flex; align-items:center; gap:15px;">

                <a class="add-btn"
                   href="<%= request.getContextPath() %>/admin/add-course.jsp">
                    + Add Course
                </a>

                <div class="course-count">

                    Total Courses:
                    <strong>
                        <%= courses.size() %>
                    </strong>

                </div>

            </div>

        </div>


        <!-- Course Table -->

        <div class="table-container">

            <table>

                <thead>

                    <tr>

                        <th>#</th>
                        <th>Course Code</th>
                        <th>Course Name</th>
                        <th>Department</th>

                    </tr>

                </thead>

                <tbody>

                <%
                    if (courses.isEmpty()) {
                %>

                    <tr>

                        <td colspan="4" class="empty">

                            No ICT courses found.

                        </td>

                    </tr>

                <%
                    } else {

                        int count = 1;

                        for (Course course : courses) {
                %>

                    <tr>

                        <td>
                            <%= count++ %>
                        </td>

                        <td>
                            <%= course.getCourseCode() %>
                        </td>

                        <td>
                            <%= course.getCourseName() %>
                        </td>

                        <td>
                            <%= course.getDepartment() %>
                        </td>

                    </tr>

                <%
                        }
                    }
                %>

                </tbody>

            </table>

        </div>

    </div>

</body>

</html>