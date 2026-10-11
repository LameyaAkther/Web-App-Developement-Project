package com.preptrack.controller;

import com.preptrack.dao.UserDAO;
import com.preptrack.model.User;
import com.preptrack.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        String rollNo = request.getParameter("rollNo");
        String department = request.getParameter("department");
        String semesterText = request.getParameter("semester");
        String section = request.getParameter("section");

        // Basic validation
        if (name == null || email == null ||
                password == null || confirmPassword == null ||
                rollNo == null || department == null ||
                semesterText == null) {

            request.setAttribute(
                    "error",
                    "All required fields must be completed."
            );

            request.getRequestDispatcher("/register.jsp")
                    .forward(request, response);

            return;
        }

        // Remove unnecessary spaces
        name = name.trim();
        email = email.trim().toLowerCase();
        rollNo = rollNo.trim();
        department = department.trim();
        if (!"ICT".equalsIgnoreCase(department)) {
            request.setAttribute(
                "error",
                "Only ICT department students can register."
            );

            request.getRequestDispatcher("/register.jsp")
                   .forward(request, response);

            return;
        }

        department = "ICT";
        section = section == null ? "" : section.trim();

        // Check password confirmation
        if (!password.equals(confirmPassword)) {

            request.setAttribute(
                    "error",
                    "Passwords do not match."
            );

            request.getRequestDispatcher("/register.jsp")
                    .forward(request, response);

            return;
        }

        // Basic password length check
        if (password.length() < 6) {

            request.setAttribute(
                    "error",
                    "Password must contain at least 6 characters."
            );

            request.getRequestDispatcher("/register.jsp")
                    .forward(request, response);

            return;
        }

        int semester;

        try {

            semester = Integer.parseInt(semesterText);

        } catch (NumberFormatException e) {

            request.setAttribute(
                    "error",
                    "Semester must be a valid number."
            );

            request.getRequestDispatcher("/register.jsp")
                    .forward(request, response);

            return;
        }

        try {

            // Check whether email already exists
            User existingUser = userDAO.findByEmail(email);

            if (existingUser != null) {

                request.setAttribute(
                        "error",
                        "An account with this email already exists."
                );

                request.getRequestDispatcher("/register.jsp")
                        .forward(request, response);

                return;
            }

            // Hash password using BCrypt
            String hashedPassword =
                    BCrypt.hashpw(password, BCrypt.gensalt(10));

            /*
             * We need to insert into two tables:
             *
             * users
             * students
             *
             * Both operations should succeed together.
             */

            Connection connection = DBConnection.getConnection();

            try {

                connection.setAutoCommit(false);

                // 1. Insert into users
                String userSQL = """
                        INSERT INTO users
                        (name, email, password_hash, role)
                        VALUES (?, ?, ?, 'STUDENT')
                        """;

                int userId;

                try (PreparedStatement statement =
                             connection.prepareStatement(
                                     userSQL,
                                     PreparedStatement.RETURN_GENERATED_KEYS)) {

                    statement.setString(1, name);
                    statement.setString(2, email);
                    statement.setString(3, hashedPassword);

                    statement.executeUpdate();

                    try (ResultSet keys =
                                 statement.getGeneratedKeys()) {

                        if (!keys.next()) {

                            throw new Exception(
                                    "Unable to create user account."
                            );
                        }

                        userId = keys.getInt(1);
                    }
                }

                // 2. Insert into students
                String studentSQL = """
                        INSERT INTO students
                        (user_id, roll_no, department, semester, section)
                        VALUES (?, ?, ?, ?, ?)
                        """;

                try (PreparedStatement statement =
                             connection.prepareStatement(studentSQL)) {

                    statement.setInt(1, userId);
                    statement.setString(2, rollNo);
                    statement.setString(3, department);
                    statement.setInt(4, semester);
                    statement.setString(5, section);

                    statement.executeUpdate();
                }

                // Everything succeeded
                connection.commit();

                response.sendRedirect(
                        request.getContextPath()
                        + "/login.jsp?registered=true"
                );

            } catch (Exception e) {

                // Undo changes if something failed
                connection.rollback();

                throw e;

            } finally {

                connection.setAutoCommit(true);
                connection.close();
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Registration failed. Please check your information."
            );

            request.getRequestDispatcher("/register.jsp")
                    .forward(request, response);
        }
    }
}