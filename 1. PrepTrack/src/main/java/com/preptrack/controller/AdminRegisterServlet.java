package com.preptrack.controller;

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

@WebServlet("/admin/register")
public class AdminRegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword =
                request.getParameter("confirmPassword");

        if (name == null || email == null ||
            password == null || confirmPassword == null ||
            name.isBlank() || email.isBlank() ||
            password.isBlank() || confirmPassword.isBlank()) {

            request.setAttribute(
                    "error",
                    "All fields are required."
            );

            request.getRequestDispatcher(
                    "/admin/register.jsp"
            ).forward(request, response);

            return;
        }

        name = name.trim();
        email = email.trim().toLowerCase();

        if (!password.equals(confirmPassword)) {

            request.setAttribute(
                    "error",
                    "Passwords do not match."
            );

            request.getRequestDispatcher(
                    "/admin/register.jsp"
            ).forward(request, response);

            return;
        }

        if (password.length() < 6) {

            request.setAttribute(
                    "error",
                    "Password must contain at least 6 characters."
            );

            request.getRequestDispatcher(
                    "/admin/register.jsp"
            ).forward(request, response);

            return;
        }

        String hashedPassword =
                BCrypt.hashpw(password, BCrypt.gensalt(10));

        String sql = """
                INSERT INTO users
                (name, email, password_hash, role)
                VALUES (?, ?, ?, 'ADMIN')
                """;

        try (Connection connection =
                     DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, name);
            statement.setString(2, email);
            statement.setString(3, hashedPassword);

            statement.executeUpdate();

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?adminCreated=true"
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Could not create admin account. Email may already exist."
            );

            request.getRequestDispatcher(
                    "/admin/register.jsp"
            ).forward(request, response);
        }
    }
}