
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.preptrack.model.Exam" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Exam Management - PrepTrack</title>

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

    .container {
        width: 92%;
        max-width: 1500px;
        margin: 35px auto;
    }

    .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 20px;
        flex-wrap: wrap;
        margin-bottom: 28px;
    }

    h2 {
        margin: 0;
        font-size: clamp(24px, 3vw, 32px);
        color: #1e293b;
        letter-spacing: -0.5px;
    }

    .header-actions {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
    }

    .btn {
        display: inline-block;
        text-decoration: none;
        padding: 11px 18px;
        border-radius: 8px;
        color: white;
        background: #2563eb;
        border: none;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        transition: background 0.2s, transform 0.2s;
    }

    .btn:hover {
        background: #1d4ed8;
        transform: translateY(-1px);
    }

    .dashboard-btn {
        background: #334155;
    }

    .dashboard-btn:hover {
        background: #1e293b;
    }

    .success, .error, .warning {
        padding: 15px 18px;
        border-radius: 10px;
        margin-bottom: 18px;
        border: 1px solid transparent;
        font-size: 14px;
    }

    .success {
        background: #dcfce7;
        color: #166534;
        border-color: #bbf7d0;
    }

    .error {
        background: #fee2e2;
        color: #991b1b;
        border-color: #fecaca;
    }

    .warning {
        background: #fef3c7;
        color: #92400e;
        border-color: #fde68a;
    }

    .table-wrapper,
    .table-container {
        width: 100%;
        overflow-x: auto;
        background: white;
        border: 1px solid #e2e8f0;
        border-radius: 14px;
        box-shadow: 0 4px 18px rgba(15, 23, 42, 0.06);
        margin-bottom: 30px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        background: white;
    }

    th, td {
        padding: 15px 16px;
        border-bottom: 1px solid #e2e8f0;
        text-align: left;
        vertical-align: middle;
    }

    th {
        background: #1e3a8a;
        color: white;
        font-size: 13px;
        font-weight: 700;
        white-space: nowrap;
    }

    td {
        color: #334155;
        font-size: 14px;
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

    .status {
        display: inline-block;
        padding: 6px 11px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 700;
        white-space: nowrap;
    }

    .draft {
        background: #fef3c7;
        color: #92400e;
    }

    .published {
        background: #dcfce7;
        color: #166534;
    }

    .completed {
        background: #e2e8f0;
        color: #334155;
    }

    .publish-btn,
    .allocation-btn {
        color: white;
        border: none;
        padding: 10px 14px;
        border-radius: 8px;
        cursor: pointer;
        font-size: 13px;
        font-weight: 650;
        white-space: nowrap;
        transition: background 0.2s;
    }

    .publish-btn {
        background: #15803d;
    }

    .publish-btn:hover {
        background: #166534;
    }

    .allocation-btn {
        background: #6d28d9;
        margin-top: 10px;
    }

    .allocation-btn:hover {
        background: #5b21b6;
    }

    .action-form {
        margin: 0;
    }

    .empty {
        text-align: center;
        padding: 35px 20px;
        color: #64748b;
    }

    .section-title {
        font-size: 23px;
        margin: 32px 0 18px;
        color: #1e293b;
    }

    @media (max-width: 768px) {
        .container {
            width: 94%;
            margin: 24px auto;
        }

        .header {
            align-items: flex-start;
            flex-direction: column;
        }

        .header-actions {
            width: 100%;
        }

        th, td {
            padding: 12px;
        }

        .section-title {
            font-size: 20px;
        }
    }
</style>
</head>

<body>

<div class="container">

    <!-- HEADER -->
    <div class="header">

        <h2>📝 Exam Management</h2>

        <div class="header-actions">

            <a class="btn"
               href="<%= request.getContextPath() %>/admin/add-exam">
                + Add Exam
            </a>

            <a class="btn dashboard-btn"
               href="<%= request.getContextPath() %>/admin/dashboard">
                Dashboard
            </a>

        </div>
    </div>

    <!-- STATUS PARAMETERS -->
    <%
        String publishStatus = request.getParameter("publish");
        String allocationStatus = request.getParameter("allocation");
        String success = request.getParameter("success");
        String error = request.getParameter("error");
    %>

    <!-- PUBLISH MESSAGES -->
    <% if ("success".equals(publishStatus)) { %>

        <div class="success">
            Exam published successfully!
        </div>

    <% } else if ("unavailable".equals(publishStatus)) { %>

        <div class="warning">
            Exam could not be published. It may already be published
            or may not belong to the ICT department.
        </div>

    <% } else if ("invalid".equals(publishStatus)) { %>

        <div class="error">
            Invalid exam ID.
        </div>

    <% } else if ("error".equals(publishStatus)) { %>

        <div class="error">
            A system error occurred while publishing the exam.
        </div>

    <% } %>

    <!-- SEAT ALLOCATION MESSAGES -->
    <% if ("success".equals(allocationStatus)) { %>

        <div class="success">
            Seat allocation completed successfully!
        </div>

    <% } else if ("unavailable".equals(allocationStatus)) { %>

        <div class="warning">
            Seat allocation could not be completed.
            Check exam status, registrations, available seats,
            and whether allocation already exists.
        </div>

    <% } else if ("invalid".equals(allocationStatus)) { %>

        <div class="error">
            Invalid exam selection.
        </div>

    <% } else if ("error".equals(allocationStatus)) { %>

        <div class="error">
            A system error occurred during seat allocation.
        </div>

    <% } %>

    <!-- ADD EXAM MESSAGES -->
    <% if ("added".equals(success)) { %>

        <div class="success">
            Exam added successfully.
        </div>

    <% } %>

    <% if ("failed".equals(error)) { %>

        <div class="error">
            Failed to add exam. Please try again.
        </div>

    <% } %>

    <!-- EXAM LIST -->
    <%
        List<Exam> exams =
            (List<Exam>) request.getAttribute("exams");
    %>

    <div class="table-wrapper">

        <table>

            <thead>
                <tr>
                    <th>#</th>
                    <th>Course Code</th>
                    <th>Course Name</th>
                    <th>Exam Date</th>
                    <th>Start Time</th>
                    <th>End Time</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>

            <% if (exams != null && !exams.isEmpty()) { %>

                <% for (Exam exam : exams) { %>

                    <%
                        String status = exam.getStatus();
                        String statusClass = "draft";

                        if ("PUBLISHED".equals(status)) {
                            statusClass = "published";
                        } else if ("COMPLETED".equals(status)) {
                            statusClass = "completed";
                        }
                    %>

                    <tr>

                        <td>
                            <%= exam.getExamId() %>
                        </td>

                        <td>
                            <strong>
                                <%= exam.getCourseCode() %>
                            </strong>
                        </td>

                        <td>
                            <%= exam.getCourseName() %>
                        </td>

                        <td>
                            <%= exam.getExamDate() %>
                        </td>

                        <td>
                            <%= exam.getStartTime() %>
                        </td>

                        <td>
                            <%= exam.getEndTime() %>
                        </td>

                        <td>
                            <span class="status <%= statusClass %>">
                                <%= status %>
                            </span>
                        </td>

                        <!-- ACTIONS -->
                        <td>

                            <% if ("DRAFT".equals(status)) { %>

                                <form class="action-form"
                                      action="<%= request.getContextPath() %>/admin/exams/publish"
                                      method="post">

                                    <input type="hidden"
                                           name="examId"
                                           value="<%= exam.getExamId() %>">

                                    <button type="submit"
                                            class="publish-btn">
                                        Publish
                                    </button>

                                </form>

                            <% } else if ("PUBLISHED".equals(status)) { %>

                                <span style="color:#166534;font-weight:bold;">
                                    Published
                                </span>

                                <form class="action-form"
                                      action="<%= request.getContextPath() %>/admin/seats/allocate"
                                      method="post"
                                      onsubmit="return confirm('Generate seat allocation for this exam?');">

                                    <input type="hidden"
                                           name="examId"
                                           value="<%= exam.getExamId() %>">

                                    <button type="submit"
                                            class="allocation-btn">
                                        Generate Seat Allocation
                                    </button>

                                </form>
                                
                                 
<form action="${pageContext.request.contextPath}/admin/duties/allocate"
      method="post"
      style="display:inline;">

    <input type="hidden"
           name="examId"
           value="<%= exam.getExamId() %>">

    <button type="submit"
            class="allocation-btn"
            onclick="return confirm('Allocate invigilation duties for this exam?');">
        Allocate Invigilation Duty
    </button>
</form>
                                 
                                

                            <% } else { %>

                                <span style="color:#6b7280;">
                                    No action
                                </span>

                            <% } %>

                        </td>

                    </tr>

                <% } %>

            <% } else { %>

                <tr>
                    <td colspan="8" class="empty">
                        No ICT exams found.
                    </td>
                </tr>

            <% } %>

            </tbody>

        </table>
        <!-- Exam-wise Duty Summary -->
<h2 class="section-title">📊 Exam-wise Duty Summary</h2>

<div class="table-container">
    <table>
        <thead>
            <tr>
                <th>Course</th>
                <th>Exam Date</th>
                <th>Total Rooms</th>
                <th>Total Faculty</th>
                <th>Total Duties</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Map<String, Object>> examSummary =
                    (List<Map<String, Object>>)
                    request.getAttribute("examDutySummary");

                if (examSummary != null && !examSummary.isEmpty()) {
                    for (Map<String, Object> item : examSummary) {
            %>
            <tr>
                <td>
                    <%= item.get("courseCode") %> -
                    <%= item.get("courseName") %>
                </td>
                <td><%= item.get("examDate") %></td>
                <td><%= item.get("totalRooms") %></td>
                <td><%= item.get("totalFaculty") %></td>
                <td><%= item.get("totalDuties") %></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="5" class="empty">
                    No exam summary available.
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>

    </div>

</div>

</body>
</html>
