package com.preptrack.controller;

import com.preptrack.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/admin/faculty/add")
public class AddFacultyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Admin login check
        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (name == null || email == null || password == null ||
            name.isBlank() || email.isBlank() || password.isBlank()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/faculty?error=required"
            );

            return;
        }

        name = name.trim();
        email = email.trim().toLowerCase();

        if (password.length() < 6) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/faculty?error=password"
            );

            return;
        }

        String hashedPassword =
                BCrypt.hashpw(password, BCrypt.gensalt(10));

        Connection connection = null;

        try {

            connection = DBConnection.getConnection();

            connection.setAutoCommit(false);

            // Insert into users
            String userSQL = """
                    INSERT INTO users
                    (name, email, password_hash, role)
                    VALUES (?, ?, ?, 'FACULTY')
                    """;

            int userId;

            try (PreparedStatement statement =
                         connection.prepareStatement(
                                 userSQL,
                                 java.sql.Statement.RETURN_GENERATED_KEYS)) {

                statement.setString(1, name);
                statement.setString(2, email);
                statement.setString(3, hashedPassword);

                statement.executeUpdate();

                try (ResultSet keys =
                             statement.getGeneratedKeys()) {

                    if (!keys.next()) {
                        throw new Exception(
                                "Could not get user ID."
                        );
                    }

                    userId = keys.getInt(1);
                }
            }

            // Insert into faculty
            String facultySQL = """
                    INSERT INTO faculty
                    (user_id, department)
                    VALUES (?, 'ICT')
                    """;

            try (PreparedStatement statement =
                         connection.prepareStatement(facultySQL)) {

                statement.setInt(1, userId);

                statement.executeUpdate();
            }

            connection.commit();

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/faculty?success=added"
            );

        } catch (Exception e) {

            e.printStackTrace();

            try {
                if (connection != null) {
                    connection.rollback();
                }
            } catch (Exception rollbackError) {
                rollbackError.printStackTrace();
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/faculty?error=failed"
            );

        } finally {

            try {
                if (connection != null) {
                    connection.close();
                }
            } catch (Exception closeError) {
                closeError.printStackTrace();
            }
        }
    }
}