package com.preptrack.controller;

import com.preptrack.dao.UserDAO;
import com.preptrack.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null ||
                email.isBlank() || password.isBlank()) {

            request.setAttribute(
                    "error",
                    "Email and password are required."
            );

            request.getRequestDispatcher("/login.jsp")
                   .forward(request, response);

            return;
        }

        try {

            User user = userDAO.findByEmail(email.trim());

            if (user != null &&
                    BCrypt.checkpw(password, user.getPasswordHash())) {

                request.getSession().setAttribute("user", user);
                System.out.println("LOGIN SUCCESS");
                System.out.println("Session ID: " + request.getSession().getId());
                System.out.println("Logged-in User: " +
                        request.getSession().getAttribute("user"));

                switch (user.getRole()) {

                case "STUDENT":
                    response.sendRedirect(
                        request.getContextPath() + "/student/dashboard"
                    );
                    break;

                    case "FACULTY":
                        response.sendRedirect(
                                request.getContextPath()
                                + "/faculty/dashboard");
                        break;

                    case "ADMIN":
                        response.sendRedirect(
                                request.getContextPath()
                                + "/admin/dashboard");
                        break;

                    default:
                        response.sendRedirect(
                                request.getContextPath()
                                + "/login.jsp");
                }

            } else {

                request.setAttribute(
                        "error",
                        "Invalid email or password."
                );

                request.getRequestDispatcher("/login.jsp")
                       .forward(request, response);
            }

        } catch (Exception e) {

            throw new ServletException(
                    "Login failed.",
                    e
            );
        }
    }
}