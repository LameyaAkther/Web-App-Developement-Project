
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.preptrack.model.User" %>
<%@ page import="com.preptrack.model.Exam" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    User student = (User) request.getAttribute("student");
    List<Exam> exams = (List<Exam>) request.getAttribute("exams");

    List<Map<String, Object>> allocations =
        (List<Map<String, Object>>) request.getAttribute("allocations");

    String registrationStatus = request.getParameter("registration");
    String allocationError = (String) request.getAttribute("allocationError");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard | PrepTrack</title>

   <style>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: Arial, Helvetica, sans-serif;
    background: #f4f7fb;
    color: #1e293b;
    line-height: 1.6;
}

.navbar {
    background: #142b4a;
    color: #ffffff;
    padding: 18px 6%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    flex-wrap: wrap;
    box-shadow: 0 3px 12px rgba(15, 23, 42, 0.12);
}

.brand {
    font-size: 24px;
    font-weight: 700;
    letter-spacing: 0.3px;
}

.logout {
    background: #ffffff;
    color: #142b4a;
    text-decoration: none;
    padding: 10px 18px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 700;
    transition: background 0.2s;
}

.logout:hover {
    background: #e2e8f0;
}

.container {
    width: 90%;
    max-width: 1200px;
    margin: 35px auto;
}

.welcome {
    margin-bottom: 30px;
}

.welcome h1 {
    font-size: 30px;
    line-height: 1.35;
    margin-bottom: 8px;
    color: #142b4a;
    letter-spacing: -0.5px;
}

.welcome p {
    color: #64748b;
    font-size: 15px;
}

.section-title {
    font-size: 22px;
    margin-bottom: 18px;
    color: #142b4a;
    font-weight: 700;
}

.info-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 18px;
}

.info-card,
.quick-card {
    background: #ffffff;
    padding: 24px;
    border-radius: 12px;
    border: 1px solid #e2e8f0;
    box-shadow: 0 4px 15px rgba(15, 23, 42, 0.04);
    transition: transform 0.2s, box-shadow 0.2s;
    min-width: 0;
}

.info-card:hover,
.quick-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 7px 20px rgba(15, 23, 42, 0.07);
}

.info-label {
    font-size: 12px;
    color: #64748b;
    margin-bottom: 9px;
    text-transform: uppercase;
    letter-spacing: 0.6px;
    font-weight: 700;
}

.info-value {
    font-size: 19px;
    font-weight: 700;
    color: #142b4a;
    overflow-wrap: anywhere;
}

.exam-section {
    margin-top: 30px;
    background: #ffffff;
    padding: 28px;
    border-radius: 13px;
    border: 1px solid #e2e8f0;
    box-shadow: 0 4px 15px rgba(15, 23, 42, 0.04);
}

.exam-section h2 {
    font-size: 22px;
    margin-bottom: 10px;
    color: #142b4a;
}

.exam-section > p {
    color: #64748b;
    line-height: 1.7;
    font-size: 14px;
}

.table-wrapper {
    width: 100%;
    overflow-x: auto;
    margin-top: 22px;
    border: 1px solid #e2e8f0;
    border-radius: 9px;
}

table {
    width: 100%;
    min-width: 680px;
    border-collapse: separate;
    border-spacing: 0;
    background: #ffffff;
}

th {
    padding: 15px 13px;
    background: #142b4a;
    color: #ffffff;
    text-align: left;
    font-size: 12px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.35px;
    white-space: nowrap;
}

td {
    padding: 15px 13px;
    border-bottom: 1px solid #e8edf4;
    vertical-align: middle;
    font-size: 13px;
    color: #334155;
}

tbody tr:nth-child(even) {
    background: #f8fafc;
}

tbody tr:hover {
    background: #eff6ff;
}

tbody tr:last-child td {
    border-bottom: none;
}

.register-btn {
    background: #1d4ed8;
    color: #ffffff;
    border: none;
    padding: 10px 16px;
    border-radius: 7px;
    cursor: pointer;
    font-size: 13px;
    font-weight: 700;
    white-space: nowrap;
    transition: background 0.2s;
}

.register-btn:hover {
    background: #1e40af;
}

.registered-badge {
    display: inline-block;
    background: #dcfce7;
    color: #166534;
    padding: 8px 12px;
    border: 1px solid #bbf7d0;
    border-radius: 7px;
    font-size: 12px;
    font-weight: 700;
    white-space: nowrap;
}

.message {
    padding: 14px 16px;
    border-radius: 9px;
    margin-bottom: 20px;
    font-size: 14px;
    line-height: 1.6;
}

.success-message {
    background: #dcfce7;
    border: 1px solid #bbf7d0;
    color: #166534;
}

.warning-message {
    background: #fffbeb;
    border: 1px solid #fde68a;
    color: #92400e;
}

.error-message,
.error-box {
    background: #fef2f2;
    border: 1px solid #fecaca;
    color: #991b1b;
}

.error-box {
    padding: 20px;
    border-radius: 10px;
    margin-top: 20px;
}

.error-box p {
    margin-top: 6px;
}

.seat-card {
    background: #f0fdf4;
    border: 1px solid #bbf7d0;
    border-radius: 12px;
    padding: 22px;
    min-width: 0;
    box-shadow: 0 3px 12px rgba(22, 101, 52, 0.04);
}

.seat-card > strong {
    color: #166534;
    font-size: 15px;
}

.seat-number {
    font-size: 24px;
    font-weight: 700;
    color: #166534;
    margin: 12px 0;
    overflow-wrap: anywhere;
}

.seat-details {
    color: #374151;
    line-height: 1.9;
    font-size: 14px;
    overflow-wrap: anywhere;
}

.quick-section {
    margin-top: 35px;
}

.quick-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 18px;
}

.quick-card h3 {
    margin-bottom: 10px;
    font-size: 17px;
    color: #142b4a;
}

.quick-card p {
    color: #64748b;
    font-size: 14px;
    line-height: 1.7;
}

.footer {
    text-align: center;
    margin-top: 45px;
    padding: 24px 15px;
    color: #64748b;
    background: #ffffff;
    border-top: 1px solid #e2e8f0;
    font-size: 13px;
}

@media (max-width: 600px) {
    .navbar {
        padding: 16px 20px;
    }

    .brand {
        font-size: 21px;
    }

    .container {
        width: 92%;
        margin: 25px auto;
    }

    .welcome h1 {
        font-size: 25px;
    }

    .section-title {
        font-size: 20px;
    }

    .info-grid,
    .quick-grid {
        grid-template-columns: 1fr;
    }

    .info-card,
    .quick-card {
        padding: 20px;
    }

    .exam-section {
        padding: 19px 14px;
    }

    .exam-section h2 {
        font-size: 20px;
    }

    .seat-card {
        padding: 18px;
    }

    .footer {
        margin-top: 30px;
    }
}
</style>
</head>

<body>

<div class="navbar">
    <div class="brand">PrepTrack</div>
    <a class="logout"
       href="<%= request.getContextPath() %>/logout">Logout</a>
</div>

<div class="container">

    <!-- REGISTRATION MESSAGE -->
    <% if ("success".equals(registrationStatus)) { %>
        <div class="message success-message">
            Registration successful! Your exam registration is confirmed.
        </div>
    <% } else if ("unavailable".equals(registrationStatus)) { %>
        <div class="message warning-message">
            Registration unsuccessful. The exam may be unpublished
            or you may already be registered.
        </div>
    <% } else if ("invalid".equals(registrationStatus)) { %>
        <div class="message error-message">
            Invalid exam request. Please try again.
        </div>
    <% } else if ("error".equals(registrationStatus)) { %>
        <div class="message error-message">
            A system error occurred. Please try again later.
        </div>
    <% } %>

    <% if (student == null) { %>

        <div class="error-box">
            <strong>Student information could not be loaded.</strong>
            <p>Please login again.</p>
        </div>

    <% } else { %>

        <!-- WELCOME -->
        <div class="welcome">
            <h1>Welcome, <%= student.getName() %> 👋</h1>
            <p>ICT Department — Student Portal</p>
        </div>

        <!-- STUDENT INFORMATION -->
        <h2 class="section-title">Student Information</h2>

        <div class="info-grid">

            <div class="info-card">
                <div class="info-label">Full Name</div>
                <div class="info-value"><%= student.getName() %></div>
            </div>

            <div class="info-card">
                <div class="info-label">Email</div>
                <div class="info-value"><%= student.getEmail() %></div>
            </div>

            <div class="info-card">
                <div class="info-label">Roll Number</div>
                <div class="info-value"><%= student.getRollNo() %></div>
            </div>

            <div class="info-card">
                <div class="info-label">Department</div>
                <div class="info-value"><%= student.getDepartment() %></div>
            </div>

            <div class="info-card">
                <div class="info-label">Semester</div>
                <div class="info-value"><%= student.getSemester() %></div>
            </div>

            <div class="info-card">
                <div class="info-label">Section</div>
                <div class="info-value"><%= student.getSection() %></div>
            </div>

        </div>

        <!-- MY SEAT ALLOCATION -->
        <div class="exam-section">
            <h2>🪑 My Seat Allocation</h2>
            <p>Your allocated room and seat information will appear here.</p>

            <% if (allocationError != null) { %>
                <div class="message error-message">
                    <%= allocationError %>
                </div>
            <% } else if (allocations != null && !allocations.isEmpty()) { %>

                <div class="info-grid" style="margin-top:20px;">

                    <% for (Map<String, Object> allocation : allocations) { %>

                        <div class="seat-card">

                            <strong>
                                <%= allocation.get("courseCode") %>
                            </strong>

                            <p style="margin-top:5px;">
                                <%= allocation.get("courseName") %>
                            </p>

                            <div class="seat-number">
                                Room <%= allocation.get("roomName") %>
                            </div>

                            <div class="seat-details">
                                <strong>Seat:</strong>
                                <%= allocation.get("rowLabel") %><%= allocation.get("colNo") %>
                                <br>

                                <strong>Exam Date:</strong>
                                <%= allocation.get("examDate") %>
                                <br>

                                <strong>Start:</strong>
                                <%= allocation.get("startTime") %>
                                <br>

                                <strong>End:</strong>
                                <%= allocation.get("endTime") %>
                            </div>

                        </div>

                    <% } %>

                </div>

            <% } else { %>

                <div class="message warning-message" style="margin-top:20px;">
                    No seat has been allocated to you yet.
                    Please check again after the Admin generates the seat plan.
                </div>

            <% } %>
        </div>

        <!-- EXAM REGISTRATION -->
        <div class="exam-section">

            <h2>📚 Examination Information</h2>

            <p>
                Register for an available examination below.
                Registered exams will show their current status.
            </p>

            <div class="table-wrapper">
                <table class="exam-table">

                    <thead>
                        <tr>
                            <th>Course</th>
                            <th>Exam Date</th>
                            <th>Start</th>
                            <th>End</th>
                            <th>Action</th>
                        </tr>
                    </thead>

                 <tbody>
<%
    if (exams != null && !exams.isEmpty()) {

        java.util.Set<Integer> registeredExamIds =
            new java.util.HashSet<>();

        for (Exam item : exams) {
            if (item.isRegistered()) {
                registeredExamIds.add(item.getExamId());
            }
        }

        java.util.Set<Integer> displayedExamIds =
            new java.util.HashSet<>();

        for (Exam exam : exams) {

            // Skip duplicate exam rows
            if (!displayedExamIds.add(exam.getExamId())) {
                continue;
            }
%>
    <tr>
        <td>
            <strong><%= exam.getCourseCode() %></strong>
            <br>
            <%= exam.getCourseName() %>
        </td>

        <td><%= exam.getExamDate() %></td>
        <td><%= exam.getStartTime() %></td>
        <td><%= exam.getEndTime() %></td>

        <td>
            <% if (registeredExamIds.contains(exam.getExamId())) { %>

                <span class="registered-badge">
                    &#10003; Registered
                </span>

            <% } else { %>

                <form
                    action="<%= request.getContextPath() %>/student/register-exam"
                    method="post">

                    <input type="hidden"
                           name="examId"
                           value="<%= exam.getExamId() %>">

                    <button type="submit" class="register-btn">
                        Register
                    </button>
                </form>

            <% } %>
        </td>
    </tr>
<%
        }
    } else {
%>
    <tr>
        <td colspan="5"
            style="text-align:center; padding:20px; color:#666;">
            No published ICT exams are currently available.
        </td>
    </tr>
<%
    }
%>
</tbody>
                </table>
            </div>
        </div>

        <!-- QUICK INFORMATION -->
        <div class="quick-section">

            <h2 class="section-title">Quick Information</h2>

            <div class="quick-grid">

                <div class="quick-card">
                    <h3>📅 Exam Schedule</h3>
                    <p>View your upcoming examination schedule here.</p>
                </div>

                <div class="quick-card">
                    <h3>🪑 Seat Information</h3>
                    <p>Check your allocated room and seat above.</p>
                </div>

                <div class="quick-card">
                    <h3>📢 Notices</h3>
                    <p>Important examination notices will appear here.</p>
                </div>

            </div>
        </div>

    <% } %>

</div>

<div class="footer">
    PrepTrack — Examination Management System
</div>

</body>
</html>
