package com.preptrack.controller;

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

@WebServlet("/admin/courses/add")
public class AddCourseServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Login check
        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }

        String courseCode =
                request.getParameter("courseCode");

        String courseName =
                request.getParameter("courseName");

        // Required field check
        if (courseCode == null ||
            courseName == null ||
            courseCode.isBlank() ||
            courseName.isBlank()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/add-course.jsp?error=required"
            );

            return;
        }

        courseCode = courseCode.trim().toUpperCase();
        courseName = courseName.trim();

        String sql = """
                INSERT INTO courses
                (course_code, course_name, department)
                VALUES (?, ?, 'ICT')
                """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, courseCode);
            statement.setString(2, courseName);

            statement.executeUpdate();

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/courses?success=added"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/courses?error=failed"
            );
        }
    }
}