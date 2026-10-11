package com.preptrack.controller;

import com.preptrack.model.User;
import com.preptrack.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/admin/exams/add")
public class AddExamServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("ADD EXAM POST SERVLET STARTED");

        // 1. Check login session
        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // 2. Verify ADMIN role
        Object sessionUser = session.getAttribute("user");

        if (!(sessionUser instanceof User)) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Invalid session user."
            );
            return;
        }

        User admin = (User) sessionUser;

        if (!"ADMIN".equals(admin.getRole())) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Only administrators can add exams."
            );
            return;
        }

        // 3. Read form values
        String courseIdText = request.getParameter("courseId");
        String examDate = request.getParameter("examDate");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");

        // 4. Validate required fields
        if (courseIdText == null || examDate == null ||
            startTime == null || endTime == null ||
            courseIdText.isBlank() || examDate.isBlank() ||
            startTime.isBlank() || endTime.isBlank()) {

            response.sendRedirect(
                request.getContextPath()
                    + "/admin/add-exam?error=required"
            );
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdText);

            // 5. Validate exam time
            if (startTime.compareTo(endTime) >= 0) {
                response.sendRedirect(
                    request.getContextPath()
                        + "/admin/add-exam?error=invalid"
                );
                return;
            }

            // 6. Insert exam with DRAFT status
            String sql = """
                INSERT INTO exams
                    (course_id, exam_date, start_time, end_time, status)
                SELECT course_id, ?, ?, ?, 'DRAFT'
                FROM courses
                WHERE course_id = ?
                  AND department = 'ICT'
                """;

            try (Connection connection = DBConnection.getConnection();
                 PreparedStatement statement =
                     connection.prepareStatement(sql)) {

                statement.setString(1, examDate);
                statement.setString(2, startTime);
                statement.setString(3, endTime);
                statement.setInt(4, courseId);

                int rowsInserted = statement.executeUpdate();

                if (rowsInserted == 0) {
                    response.sendRedirect(
                        request.getContextPath()
                            + "/admin/add-exam?error=invalid"
                    );
                    return;
                }
            }

            System.out.println("EXAM CREATED SUCCESSFULLY");

            response.sendRedirect(
                request.getContextPath()
                    + "/admin/exams?success=added"
            );

        } catch (NumberFormatException e) {
            response.sendRedirect(
                request.getContextPath()
                    + "/admin/add-exam?error=invalid"
            );

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(
                request.getContextPath()
                    + "/admin/add-exam?error=failed"
            );
        }
    }
}