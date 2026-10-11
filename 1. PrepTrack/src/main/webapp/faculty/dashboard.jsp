
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Dashboard | PrepTrack</title>

   
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
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

.logout-btn {
    background: #ffffff;
    color: #142b4a;
    text-decoration: none;
    padding: 10px 18px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 700;
    transition: background 0.2s, transform 0.2s;
}

.logout-btn:hover {
    background: #e8eef7;
    transform: translateY(-1px);
}

.container {
    max-width: 1200px;
    margin: 35px auto;
    padding: 0 24px;
}

.welcome {
    margin-bottom: 28px;
}

.welcome h1 {
    font-size: 30px;
    line-height: 1.3;
    margin-bottom: 8px;
    color: #142b4a;
    letter-spacing: -0.5px;
}

.welcome p {
    color: #64748b;
    font-size: 15px;
}

.summary-card {
    background: #ffffff;
    padding: 26px;
    border: 1px solid #e2e8f0;
    border-left: 5px solid #2563eb;
    border-radius: 13px;
    box-shadow: 0 4px 16px rgba(15, 23, 42, 0.04);
    margin-bottom: 28px;
    max-width: 360px;
}

.summary-card h3 {
    color: #64748b;
    font-size: 14px;
    font-weight: 600;
    margin-bottom: 10px;
}

.summary-card .number {
    font-size: 38px;
    line-height: 1.2;
    font-weight: 700;
    color: #142b4a;
}

.section {
    background: #ffffff;
    padding: 28px;
    border: 1px solid #e2e8f0;
    border-radius: 13px;
    box-shadow: 0 4px 16px rgba(15, 23, 42, 0.04);
    margin-bottom: 28px;
}

.section h2 {
    font-size: 22px;
    line-height: 1.4;
    margin-bottom: 8px;
    color: #142b4a;
}

.section-description {
    color: #64748b;
    margin-bottom: 24px;
    font-size: 14px;
    line-height: 1.7;
}

.table-responsive {
    width: 100%;
    overflow-x: auto;
    border: 1px solid #e2e8f0;
    border-radius: 9px;
}

table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    min-width: 700px;
}

thead th {
    padding: 15px 14px;
    background: #142b4a;
    color: #ffffff;
    text-align: left;
    font-size: 12px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.35px;
    white-space: nowrap;
}

tbody td {
    padding: 16px 14px;
    text-align: left;
    border-bottom: 1px solid #e8edf4;
    color: #334155;
    font-size: 14px;
    vertical-align: middle;
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

.room-badge {
    display: inline-block;
    background: #dcfce7;
    color: #166534;
    padding: 6px 12px;
    border: 1px solid #bbf7d0;
    border-radius: 7px;
    font-size: 12px;
    font-weight: 700;
    white-space: nowrap;
}

.empty-state {
    text-align: center;
    padding: 42px 20px;
    background: #f8fafc;
    border: 1px dashed #cbd5e1;
    border-radius: 10px;
    color: #64748b;
}

.empty-state h3 {
    color: #142b4a;
    font-size: 18px;
    margin-bottom: 8px;
}

.empty-state p {
    font-size: 14px;
}

.error-message {
    color: #991b1b;
    background: #fef2f2;
    border: 1px solid #fecaca;
    padding: 15px 17px;
    border-radius: 9px;
    margin-bottom: 20px;
    font-size: 14px;
}

.footer {
    text-align: center;
    padding: 25px 15px;
    color: #64748b;
    font-size: 13px;
    border-top: 1px solid #e2e8f0;
    margin-top: 35px;
}

@media (max-width: 600px) {
    .navbar {
        padding: 16px 20px;
    }

    .brand {
        font-size: 21px;
    }

    .logout-btn {
        padding: 9px 13px;
    }

    .container {
        margin-top: 25px;
        padding: 0 13px;
    }

    .welcome h1 {
        font-size: 25px;
    }

    .summary-card {
        max-width: 100%;
        padding: 22px;
    }

    .section {
        padding: 18px 14px;
    }

    .section h2 {
        font-size: 20px;
    }

    .footer {
        margin-top: 20px;
    }
}
</style>
</head>

<body>

    <header class="navbar">
        <div class="brand">PrepTrack</div>

        <a class="logout-btn"
           href="${pageContext.request.contextPath}/logout">
            Logout
        </a>
    </header>

    <main class="container">

        <section class="welcome">
            <h1>Faculty Dashboard</h1>
            <p>Welcome! Manage and review your examination duties.</p>
        </section>

        <section class="summary-card">
            <h3>My Assigned Duties</h3>
            <div class="number">
                <c:out value="${empty duties ? 0 : duties.size()}"/>
            </div>
        </section>

        <section class="section">
            <h2>My Invigilation Duties</h2>

            <p class="section-description">
                View your assigned examination schedule, exam time
                and examination room.
            </p>

            <c:choose>
                <c:when test="${not empty dutyError}">
                    <div class="error-message">
                        <c:out value="${dutyError}"/>
                    </div>
                </c:when>

                <c:when test="${not empty duties}">
                    <div class="table-responsive">
                        <table>
                            <thead>
                                <tr>
                                    <th>Course Code</th>
                                    <th>Course Name</th>
                                    <th>Exam Date</th>
                                    <th>Start Time</th>
                                    <th>End Time</th>
                                    <th>Room</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="duty" items="${duties}">
                                    <tr>
                                        <td>
                                            <c:out value="${duty.courseCode}"/>
                                        </td>

                                        <td>
                                            <c:out value="${duty.courseName}"/>
                                        </td>

                                        <td>
                                            <c:out value="${duty.examDate}"/>
                                        </td>

                                        <td>
                                            <c:out value="${duty.startTime}"/>
                                        </td>

                                        <td>
                                            <c:out value="${duty.endTime}"/>
                                        </td>

                                        <td>
                                            <span class="room-badge">
                                                <c:out value="${duty.roomNumber}"/>
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="empty-state">
                        <h3>No Duties Assigned Yet</h3>
                        <p>
                            Your invigilation duties will appear here
                            after the administrator assigns them.
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

    </main>

    <footer class="footer">
        PrepTrack &mdash; Exam Seat &amp; Invigilation Duty Allocator
    </footer>

</body>
</html>
