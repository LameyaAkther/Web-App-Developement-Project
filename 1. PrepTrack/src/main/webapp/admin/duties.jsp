<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invigilation Duties | PrepTrack</title>

   
<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    padding: 30px 24px;
    font-family: Arial, Helvetica, sans-serif;
    background: #f4f7fb;
    color: #1e293b;
    line-height: 1.5;
}

.container {
    max-width: 1350px;
    margin: 0 auto;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 18px;
    margin-bottom: 28px;
    padding: 24px 28px;
    background: #ffffff;
    border: 1px solid #e5eaf1;
    border-radius: 14px;
    box-shadow: 0 4px 18px rgba(15, 23, 42, 0.04);
}

h1 {
    margin: 0 0 6px;
    color: #142b4a;
    font-size: 28px;
    font-weight: 700;
    letter-spacing: -0.5px;
}

.subtitle {
    margin: 0;
    color: #64748b;
    font-size: 14px;
}

.btn {
    display: inline-block;
    padding: 11px 17px;
    border: none;
    border-radius: 8px;
    background: #1d4ed8;
    color: #ffffff;
    text-decoration: none;
    font-size: 14px;
    font-weight: 600;
    transition: background 0.2s, transform 0.2s;
}

.btn:hover {
    background: #1e40af;
    transform: translateY(-1px);
}

.card {
    padding: 26px;
    background: #ffffff;
    border: 1px solid #e5eaf1;
    border-radius: 14px;
    box-shadow: 0 4px 18px rgba(15, 23, 42, 0.04);
    overflow-x: auto;
}

.count {
    margin: 0 0 22px;
    padding: 14px 16px;
    background: #eff6ff;
    border: 1px solid #dbeafe;
    border-radius: 9px;
    color: #1e40af;
    font-size: 14px;
}

table {
    width: 100%;
    min-width: 1050px;
    border-collapse: separate;
    border-spacing: 0;
}

thead th {
    padding: 15px 13px;
    background: #142b4a;
    color: #ffffff;
    text-align: left;
    font-size: 12px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.4px;
    white-space: nowrap;
}

thead th:first-child {
    border-radius: 8px 0 0 0;
}

thead th:last-child {
    border-radius: 0 8px 0 0;
}

tbody td {
    padding: 17px 13px;
    border-bottom: 1px solid #e8edf4;
    color: #334155;
    font-size: 13px;
    vertical-align: middle;
}

tbody tr:nth-child(even) td {
    background: #f8fafc;
}

tbody tr:hover td {
    background: #eff6ff;
}

tbody td strong {
    color: #142b4a;
}

tbody td small {
    color: #64748b;
    font-size: 12px;
}

.empty {
    padding: 48px 20px;
    text-align: center;
    color: #64748b;
}

.empty h3 {
    margin: 0 0 8px;
    color: #142b4a;
}

.empty p {
    margin-bottom: 22px;
    font-size: 14px;
}

/* Workload progress bar */
td div[style*="border-radius"] {
    min-width: 100px;
}

/* Cancel Duty */
.cancel-btn {
    display: block;
    width: 100%;
    margin-bottom: 10px;
    padding: 9px 12px;
    border: 1px solid #fecaca;
    border-radius: 7px;
    background: #fef2f2;
    color: #b91c1c;
    cursor: pointer;
    font-size: 12px;
    font-weight: 700;
    transition: background 0.2s;
}

.cancel-btn:hover {
    background: #fee2e2;
}

/* Reassign */
.reassign-btn {
    display: block;
    width: 100%;
    padding: 9px 12px;
    border: none;
    border-radius: 7px;
    background: #1d4ed8;
    color: #ffffff;
    cursor: pointer;
    font-size: 12px;
    font-weight: 700;
    transition: background 0.2s;
}

.reassign-btn:hover {
    background: #1e40af;
}

td select {
    width: 100%;
    max-width: 180px;
    margin: 0 0 8px;
    padding: 9px 10px;
    border: 1px solid #cbd5e1;
    border-radius: 7px;
    background: #ffffff;
    color: #334155;
    font-size: 12px;
    outline: none;
}

td select:focus {
    border-color: #2563eb;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
}

td form {
    margin: 0 0 8px;
}

.status-message {
    padding: 14px 16px;
    margin-bottom: 18px;
    border-radius: 9px;
    font-size: 14px;
    font-weight: 600;
}

.status-message.success {
    background: #dcfce7;
    border: 1px solid #bbf7d0;
    color: #166534;
}

.status-message.error {
    background: #fee2e2;
    border: 1px solid #fecaca;
    color: #991b1b;
}

@media (max-width: 768px) {
    body {
        padding: 16px 10px;
    }

    .header {
        padding: 20px;
    }

    h1 {
        font-size: 23px;
    }

    .card {
        padding: 16px;
    }

    .btn {
        width: 100%;
        text-align: center;
    }
}
</style>
</head>

<body>
<div class="container">

    <div class="header">
        <div>
            <h1>Invigilation Duties</h1>
            <p class="subtitle">
                View all assigned faculty examination duties.
            </p>
        </div>

        <a class="btn"
           href="${pageContext.request.contextPath}/admin/dashboard">
            ← Admin Dashboard
        </a>
    </div>

    <div class="card">
    <c:if test="${param.reassign == 'success'}">
    <div class="status-message success">
        Duty reassigned successfully!
    </div>
</c:if>

<c:if test="${param.reassign == 'failed'}">
    <div class="status-message error">
        Reassignment failed. The selected faculty may be
        unavailable, at the duty limit, or assigned to an
        overlapping exam.
    </div>
</c:if>

<c:if test="${param.reassign == 'invalid'}">
    <div class="status-message error">
        Invalid duty or faculty selection.
    </div>
</c:if>

        <p class="count">
            Total assigned duties:
            <strong><c:out value="${duties.size()}" /></strong>
        </p>

        <c:choose>
            <c:when test="${empty duties}">
                <div class="empty">
                    <h3>No duties assigned yet</h3>
                    <p>
                        Publish an exam and allocate invigilation
                        duties from the Exams page.
                    </p>
                    <a class="btn"
                       href="${pageContext.request.contextPath}/admin/exams">
                        Go to Exams
                    </a>
                </div>
            </c:when>

            <c:otherwise>
                <table>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Faculty Name</th>
                        <th>Course</th>
                        <th>Exam Date</th>
                        <th>Start Time</th>
                        <th>End Time</th>
                        <th>Room</th>
                       <th>Workload</th>
                        <th>Action</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach var="duty" items="${duties}"
                               varStatus="status">
                        <tr>
                            <td><c:out value="${status.count}" /></td>
                            <td>
                                <strong>
                                    <c:out value="${duty.facultyName}" />
                                </strong>
                            </td>
                            <td>
                                <c:out value="${duty.courseCode}" />
                                <br>
                                <small>
                                    <c:out value="${duty.courseName}" />
                                </small>
                            </td>
                            <td><c:out value="${duty.examDate}" /></td>
                            <td><c:out value="${duty.startTime}" /></td>
                            <td><c:out value="${duty.endTime}" /></td>
                            <td>
                                <c:out value="${duty.roomName}" />
                            </td>
                           <td>
    <c:set var="workload" value="${duty.workload}" />

    <strong>
        <c:out value="${duty.assignedDuties}" />/<c:out value="${duty.maxDuties}" />
    </strong>

    <div style="background:#e2e8f0; width:120px;
                height:10px; border-radius:8px;
                overflow:hidden; margin-top:6px;">
        <div style="height:10px;
                    width:${workload}%;
                    background:${workload ge 100 ? '#dc2626' : (workload ge 75 ? '#f59e0b' : '#16a34a')};">
        </div>
    </div>

    <small><c:out value="${duty.workload}" />%</small>
</td>
                            <td>
    <form method="post"
          action="${pageContext.request.contextPath}/admin/duties/cancel"
          onsubmit="return confirm('Are you sure you want to cancel this duty?');">

        <input type="hidden"
               name="dutyId"
               value="${duty.dutyId}">

        <button type="submit" class="cancel-btn">
            Cancel Duty
        </button>
    </form>
    <form method="post"
      action="${pageContext.request.contextPath}/admin/duties/reassign"
      onsubmit="return confirm('Are you sure you want to reassign this duty?');">

    <input type="hidden"
           name="dutyId"
           value="${duty.dutyId}">

    <select name="facultyId" required>
        <option value="">Select Faculty</option>

        <c:forEach var="faculty"
                   items="${duty.eligibleFaculty}">
            <option value="${faculty.facultyId}">
                <c:out value="${faculty.name}" />
            </option>
        </c:forEach>
    </select>

    <button type="submit" class="reassign-btn">
        Reassign
    </button>
</form>
</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>

    </div>
</div>
</body>
</html>