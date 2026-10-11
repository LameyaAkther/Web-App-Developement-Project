
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.preptrack.model.FacultyMember" %>

<%
    List<FacultyMember> facultyMembers =
        (List<FacultyMember>) request.getAttribute("facultyMembers");

    if (facultyMembers == null) {
        facultyMembers = new java.util.ArrayList<>();
    }

    List<Map<String, Object>> unavailabilityList =
        (List<Map<String, Object>>) request.getAttribute("unavailabilityList");

    if (unavailabilityList == null) {
        unavailabilityList = new java.util.ArrayList<>();
    }

    String message = request.getParameter("unavailability");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Faculty Management - PrepTrack</title>

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

    .navbar {
        min-height: 70px;
        background: #1e3a8a;
        color: white;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 16px;
        padding: 14px 5%;
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

    .container {
        max-width: 1500px;
        margin: 0 auto;
        padding: 36px 5%;
    }

    .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 18px;
        flex-wrap: wrap;
        margin-bottom: 28px;
    }

    .header h1 {
        font-size: clamp(24px, 3vw, 32px);
        color: #1e293b;
        letter-spacing: -0.5px;
    }

    .header p {
        color: #64748b;
        margin-top: 6px;
        font-size: 15px;
    }

    .faculty-count {
        background: white;
        padding: 15px 20px;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(15, 23, 42, 0.05);
        color: #334155;
        white-space: nowrap;
    }

    .faculty-count strong {
        color: #2563eb;
        font-size: 20px;
        margin-left: 5px;
    }

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

    .section-title {
        color: #1e293b;
        font-size: 22px;
        margin: 32px 0 16px;
        font-weight: 750;
    }

    .table-container {
        background: white;
        border: 1px solid #e2e8f0;
        border-radius: 14px;
        overflow-x: auto;
        box-shadow: 0 4px 18px rgba(15, 23, 42, 0.06);
        margin-bottom: 30px;
    }

    table {
        width: 100%;
        min-width: 760px;
        border-collapse: collapse;
        text-align: left;
    }

    th {
        background: #1e3a8a;
        color: white;
        padding: 15px 17px;
        font-size: 13px;
        font-weight: 700;
        white-space: nowrap;
    }

    td {
        padding: 15px 17px;
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

    .message {
        padding: 13px 17px;
        border: 1px solid #bbf7d0;
        border-radius: 9px;
        margin-bottom: 20px;
        background: #dcfce7;
        color: #166534;
        font-size: 14px;
    }

    .message.error {
        background: #fee2e2;
        border-color: #fecaca;
        color: #991b1b;
    }

    .unavailability-form {
        display: flex;
        align-items: center;
        gap: 8px;
        flex-wrap: wrap;
        min-width: 270px;
    }

    .unavailability-form input {
        min-width: 145px;
        padding: 9px 10px;
        border: 1px solid #cbd5e1;
        border-radius: 7px;
        background: white;
        color: #334155;
        font-size: 13px;
    }

    .unavailability-form input:focus {
        outline: 2px solid #bfdbfe;
        border-color: #2563eb;
    }

    .unavailability-form button {
        background: #d97706;
        color: white;
        border: none;
        padding: 10px 12px;
        border-radius: 7px;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        transition: background 0.2s;
    }

    .unavailability-form button:hover {
        background: #b45309;
    }

    .empty {
        text-align: center;
        padding: 40px 20px;
        color: #64748b;
        font-size: 14px;
    }

    .date-badge {
        display: inline-block;
        background: #fee2e2;
        color: #991b1b;
        padding: 7px 11px;
        border-radius: 7px;
        font-weight: 650;
        white-space: nowrap;
    }

    /* Workload progress bar */
    td div[style*="border-radius"] {
        max-width: 150px;
    }

    td small {
        display: inline-block;
        margin-top: 5px;
        color: #64748b;
        font-weight: 600;
    }

    @media (max-width: 700px) {
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
            flex-wrap: wrap;
        }

        .section-title {
            font-size: 20px;
        }
    }
</style>
</head>

<body>

    <div class="navbar">
        <div class="logo">PrepTrack</div>

        <a class="back"
           href="<%= request.getContextPath() %>/admin/dashboard">
            ← Dashboard
        </a>
    </div>

    <div class="container">

        <div class="header">
            <div>
                <h1>👨‍🏫 Faculty Management</h1>
                <p>ICT Department Faculty and Unavailability</p>
            </div>

            <div style="display:flex; align-items:center; gap:15px;">
                <a class="add-btn"
                   href="<%= request.getContextPath() %>/admin/add-faculty.jsp">
                    + Add Faculty
                </a>

                <div class="faculty-count">
                    Total Faculty:
                    <strong><%= facultyMembers.size() %></strong>
                </div>
            </div>
        </div>

        <% if ("success".equals(message)) { %>
            <div class="message">
                ✓ Faculty unavailability saved successfully.
            </div>
        <% } else if ("unavailable".equals(message)) { %>
            <div class="message error">
                ⚠ Could not save. Faculty may be inactive or this date
                may already be registered.
            </div>
        <% } else if ("invalid".equals(message)) { %>
            <div class="message error">
                ✗ Invalid faculty or date. Select a valid date.
            </div>
        <% } %>

        <!-- ICT Faculty List -->
        <h2 class="section-title">Faculty List</h2>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Department</th>
                        <th>Unavailable Date</th>
                    </tr>
                </thead>

                <tbody>
                    <% if (facultyMembers.isEmpty()) { %>
                        <tr>
                            <td colspan="5" class="empty">
                                No ICT faculty found.
                            </td>
                        </tr>
                    <% } else {
                        int count = 1;

                        for (FacultyMember faculty : facultyMembers) {
                    %>
                        <tr>
                            <td><%= count++ %></td>
                            <td><%= faculty.getName() %></td>
                            <td><%= faculty.getEmail() %></td>
                            <td><%= faculty.getDepartment() %></td>

                            <td>
                                <% if (faculty.isActive()) { %>
                                    <form class="unavailability-form"
                                          action="<%= request.getContextPath() %>/admin/faculty/unavailability"
                                          method="post">

                                        <input type="hidden"
                                               name="facultyId"
                                               value="<%= faculty.getFacultyId() %>">

                                        <input type="date"
                                               name="unavailableDate"
                                               min="<%= java.time.LocalDate.now() %>"
                                               required>

                                        <button type="submit">
                                            Mark Unavailable
                                        </button>
                                    </form>
                                <% } else { %>
                                    Inactive Faculty
                                <% } %>
                            </td>
                        </tr>
                    <%
                        }
                    } %>
                </tbody>
            </table>
            <!-- Faculty Duty Summary -->
<h2 class="section-title">📊 Faculty Duty Summary</h2>

<div class="table-container">
    <table>
        <thead>
            <tr>
                <th>#</th>
                <th>Faculty Name</th>
                <th>Maximum Duties</th>
                <th>Assigned Duties</th>
                <th>Workload</th>
                <th>Remaining Duties</th>
                <th>Capacity Status</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<Map<String, Object>> dutySummary =
                    (List<Map<String, Object>>)
                    request.getAttribute("facultyDutySummary");

                if (dutySummary != null && !dutySummary.isEmpty()) {
                    int i = 1;

                    for (Map<String, Object> faculty : dutySummary) {
            %>
            <tr>
                <td><%= i++ %></td>
                <td><%= faculty.get("name") %></td>
                <td><%= faculty.get("maxDuties") %></td>
                <td><%= faculty.get("assignedDuties") %></td>
                <td>
    <%
        int assigned = ((Number) faculty.get("assignedDuties")).intValue();
        int max = ((Number) faculty.get("maxDuties")).intValue();
        int workload = max > 0
            ? Math.min(100, (assigned * 100) / max)
            : 0;
    %>

    <div style="background:#e2e8f0; border-radius:8px;
                height:12px; width:150px; overflow:hidden;">
        <div style="width:<%= workload %>%; height:12px;
                    background:<%= workload >= 100 ? "#dc2626" :
                    workload >= 75 ? "#f59e0b" : "#16a34a" %>;">
        </div>
    </div>

    <small><%= workload %>%</small>
</td>
                <td><%= faculty.get("remainingDuties") %></td>
                <td>
    <%
        int remaining =
            ((Number) faculty.get("remainingDuties")).intValue();
    %>

    <% if (remaining <= 0) { %>
        <span style="color:#dc2626; font-weight:bold;">
            🔴 Capacity Full
        </span>
    <% } else if (remaining == 1) { %>
        <span style="color:#d97706; font-weight:bold;">
            ⚠ Almost Full
        </span>
    <% } else { %>
        <span style="color:#16a34a; font-weight:bold;">
            ✓ Available
        </span>
    <% } %>
</td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="5" class="empty">
                    No faculty duty summary available.
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>
        </div>

        <!-- Faculty Unavailability Schedule -->
        <h2 class="section-title">📅 Faculty Unavailability Schedule</h2>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Faculty Name</th>
                        <th>Department</th>
                        <th>Unavailable Date</th>
                    </tr>
                </thead>

                <tbody>
                    <% if (unavailabilityList.isEmpty()) { %>
                        <tr>
                            <td colspan="4" class="empty">
                                No unavailable dates recorded yet.
                            </td>
                        </tr>
                    <% } else {
                        int index = 1;

                        for (Map<String, Object> item : unavailabilityList) {
                    %>
                        <tr>
                            <td><%= index++ %></td>
                            <td><%= item.get("name") %></td>
                            <td><%= item.get("department") %></td>
                            <td>
                                <span class="date-badge">
                                    <%= item.get("unavailableDate") %>
                                </span>
                            </td>
                        </tr>
                    <%
                        }
                    } %>
                </tbody>
            </table>
        </div>

    </div>

</body>
</html>
