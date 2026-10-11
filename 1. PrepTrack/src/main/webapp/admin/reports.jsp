<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.preptrack.model.Exam" %>

<%
    Object currentUser = session.getAttribute("user");

    if (currentUser == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }

    List<Exam> exams = (List<Exam>) request.getAttribute("exams");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Examination Reports | PrepTrack</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f4f7fb;
    color: #1e293b;
}

.navbar {
    background: #142b4a;
    color: white;
    padding: 20px 6%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    flex-wrap: wrap;
}

.navbar h2 {
    margin: 0;
    font-size: 22px;
}

.navbar a {
    color: white;
    text-decoration: none;
    margin-left: 18px;
    font-size: 14px;
}

.container {
    max-width: 1150px;
    margin: 35px auto;
    padding: 0 20px;
}

.heading {
    margin-bottom: 25px;
}

.heading h1 {
    margin: 0 0 8px;
    font-size: 28px;
}

.heading p {
    margin: 0;
    color: #64748b;
}

.card {
    background: white;
    padding: 24px;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(15, 23, 42, 0.06);
    overflow-x: auto;
}

.card h3 {
    margin-top: 0;
    margin-bottom: 20px;
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 650px;
}

th, td {
    padding: 14px 12px;
    text-align: left;
    border-bottom: 1px solid #e5eaf1;
    font-size: 14px;
}

th {
    background: #f1f5f9;
    color: #334155;
}

tr:hover td {
    background: #f8fafc;
}

.status {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: bold;
    background: #e0e7ff;
    color: #3730a3;
}

.empty {
    padding: 30px;
    text-align: center;
    color: #64748b;
}

.back-btn {
    display: inline-block;
    margin-bottom: 20px;
    padding: 10px 16px;
    background: #e2e8f0;
    color: #1e293b;
    text-decoration: none;
    border-radius: 7px;
    font-size: 14px;
}

@media (max-width: 600px) {
    .navbar {
        padding: 18px 5%;
    }

    .container {
        margin-top: 24px;
        padding: 0 12px;
    }

    .heading h1 {
        font-size: 23px;
    }

    .card {
        padding: 15px;
    }
}
</style>
</head>

<body>

<header class="navbar">
    <h2>PrepTrack</h2>
    <nav>
        <a href="<%= request.getContextPath() %>/admin/dashboard">
            Dashboard
        </a>
        <a href="<%= request.getContextPath() %>/logout">
            Logout
        </a>
    </nav>
</header>

<main class="container">

    <a class="back-btn"
       href="<%= request.getContextPath() %>/admin/dashboard">
        &larr; Back to Dashboard
    </a>

    <section class="heading">
        <h1>Examination Reports</h1>
        <p>View the examination records available in PrepTrack.</p>
    </section>

    <section class="card">
        <h3>Examination Overview</h3>

        <% if (exams != null && !exams.isEmpty()) { %>

        <table>
            <thead>
                <tr>
                    <th>Exam ID</th>
                    <th>Course</th>
                    <th>Exam Date</th>
                    <th>Start Time</th>
                    <th>End Time</th>
                    <th>Status</th>
                </tr>
            </thead>

            <tbody>
            <% for (Exam exam : exams) { %>
                <tr>
                    <td><%= exam.getExamId() %></td>
                    <td><%= exam.getCourseName() %></td>
                    <td><%= exam.getExamDate() %></td>
                    <td><%= exam.getStartTime() %></td>
                    <td><%= exam.getEndTime() %></td>
                    <td>
                        <span class="status">
                            <%= exam.getStatus() %>
                        </span>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>

        <% } else { %>

        <div class="empty">
            No examination records found.
        </div>

        <% } %>
    </section>

</main>

</body>
</html>