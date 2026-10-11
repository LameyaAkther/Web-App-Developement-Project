<%@ page import="java.util.List" %>
<%@ page import="com.preptrack.model.Course" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Exam - PrepTrack</title>

   <style>
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
        font-family: "Segoe UI", Arial, sans-serif;
    }

    body {
        min-height: 100vh;
        background: #f1f5f9;
        color: #1e293b;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 30px 16px;
    }

    .container {
        width: 100%;
        max-width: 540px;
        background: #ffffff;
        padding: 36px;
        border: 1px solid #e2e8f0;
        border-radius: 16px;
        box-shadow: 0 10px 35px rgba(15, 23, 42, 0.08);
    }

    h2 {
        color: #1e3a8a;
        text-align: center;
        font-size: 28px;
        margin-bottom: 25px;
        letter-spacing: -0.5px;
    }

    .info {
        background: #eff6ff;
        color: #1e40af;
        border: 1px solid #bfdbfe;
        padding: 14px 16px;
        border-radius: 10px;
        margin-bottom: 22px;
        font-size: 14px;
        line-height: 1.6;
    }

    .error {
        background: #fef2f2;
        color: #b91c1c;
        border: 1px solid #fecaca;
        padding: 13px 15px;
        border-radius: 9px;
        margin-bottom: 18px;
        text-align: center;
        font-size: 14px;
    }

    label {
        display: block;
        margin-top: 19px;
        margin-bottom: 8px;
        font-weight: 650;
        color: #334155;
        font-size: 14px;
    }

    select,
    input {
        display: block;
        width: 100%;
        min-height: 46px;
        padding: 11px 13px;
        border: 1px solid #cbd5e1;
        border-radius: 9px;
        background: #ffffff;
        color: #1e293b;
        font-size: 15px;
        outline: none;
        transition: border-color 0.2s, box-shadow 0.2s;
    }

    select:focus,
    input:focus {
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
    }

    .btn {
        display: block;
        width: 100%;
        margin-top: 28px;
        padding: 13px 16px;
        background: #1e3a8a;
        color: white;
        border: none;
        border-radius: 9px;
        cursor: pointer;
        font-size: 16px;
        font-weight: 650;
        transition: background 0.2s, transform 0.2s;
    }

    .btn:hover {
        background: #2563eb;
        transform: translateY(-1px);
    }

    .back {
        display: block;
        text-align: center;
        margin-top: 22px;
        text-decoration: none;
        color: #475569;
        font-size: 14px;
        font-weight: 600;
        transition: color 0.2s;
    }

    .back:hover {
        color: #2563eb;
    }

    @media (max-width: 480px) {
        body {
            padding: 18px 12px;
            align-items: flex-start;
        }

        .container {
            padding: 25px 20px;
            border-radius: 12px;
        }

        h2 {
            font-size: 24px;
        }
    }
</style>
</head>

<body>

<div class="container">

    <h2>➕ Add ICT Exam</h2>

    <div class="info">
        New exams are created with <strong>DRAFT</strong> status.
    </div>

    <%
        String error = request.getParameter("error");

        if ("required".equals(error)) {
    %>

        <div class="error">
            Please fill in all required fields.
        </div>

    <%
        } else if ("invalid".equals(error)) {
    %>

        <div class="error">
            Please enter valid exam information.
        </div>

    <%
        } else if ("failed".equals(error)) {
    %>

        <div class="error">
            Failed to create exam.
        </div>

    <%
        }
    %>


    <%
        List<Course> courses =
                (List<Course>) request.getAttribute("courses");
    %>


    <form action="<%= request.getContextPath() %>/admin/exams/add"
          method="post">


        <label>Course</label>

        <select name="courseId" required>

            <option value="">
                -- Select ICT Course --
            </option>

            <%
                if (courses != null && !courses.isEmpty()) {

                    for (Course course : courses) {
            %>

                <option value="<%= course.getCourseId() %>">

                    <%= course.getCourseCode() %>
                    -
                    <%= course.getCourseName() %>

                </option>

            <%
                    }

                } else {
            %>

                <option value="" disabled>
                    No ICT courses available
                </option>

            <%
                }
            %>

        </select>


        <label>Exam Date</label>

        <input type="date"
               name="examDate"
               required>


        <label>Start Time</label>

        <input type="time"
               name="startTime"
               required>


        <label>End Time</label>

        <input type="time"
               name="endTime"
               required>


        <button type="submit" class="btn">
            Create Exam
        </button>

    </form>


    <a class="back"
       href="<%= request.getContextPath() %>/admin/exams">
        ← Back to Exam Management
    </a>

</div>

</body>
</html>