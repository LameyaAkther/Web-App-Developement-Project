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
import java.sql.SQLException;

@WebServlet("/admin/exams/publish")
public class PublishExamServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String dashboardURL =
                request.getContextPath() + "/admin/exams";

        // 1. Check admin session
        HttpSession session = request.getSession(false);

        if (session == null ||
                !(session.getAttribute("user") instanceof User)) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        User loggedInUser = (User) session.getAttribute("user");

        // 2. Only ADMIN can publish exams
        if (!"ADMIN".equals(loggedInUser.getRole())) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // 3. Validate exam ID
        int examId;

        try {
            examId = Integer.parseInt(
                    request.getParameter("examId"));

            if (examId <= 0) {
                throw new NumberFormatException();
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(
                    dashboardURL + "?publish=invalid");
            return;
        }

        // 4. Publish only a DRAFT exam belonging to ICT
        String sql = """
            UPDATE exams e
            INNER JOIN courses c
                ON e.course_id = c.course_id
            SET e.status = 'PUBLISHED'
            WHERE e.exam_id = ?
              AND e.status = 'DRAFT'
              AND c.department = 'ICT'
            """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, examId);

            int updatedRows = statement.executeUpdate();

            if (updatedRows == 1) {
                response.sendRedirect(
                        dashboardURL + "?publish=success");
            } else {
                response.sendRedirect(
                        dashboardURL + "?publish=unavailable");
            }

        } catch (SQLException e) {
            e.printStackTrace();

            response.sendRedirect(
                    dashboardURL + "?publish=error");
        }
    }
}