package com.preptrack.controller;

import com.preptrack.dao.RegistrationDAO;
import com.preptrack.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/student/register-exam")
public class RegisterExamServlet extends HttpServlet {

    private final RegistrationDAO registrationDAO =
            new RegistrationDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String dashboardURL =
                request.getContextPath() + "/student/dashboard";

        // 1. Check login session
        HttpSession session = request.getSession(false);

        if (session == null ||
                !(session.getAttribute("user") instanceof User)) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        User loggedInUser = (User) session.getAttribute("user");

        // 2. Only students can register
        if (!"STUDENT".equals(loggedInUser.getRole())) {
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
                    dashboardURL + "?registration=invalid");
            return;
        }

        // 4. Register student
        try {
            boolean success =
                    registrationDAO.registerStudentForExam(
                            loggedInUser.getUserId(), examId);

            if (success) {
                response.sendRedirect(
                        dashboardURL + "?registration=success");
            } else {
                response.sendRedirect(
                        dashboardURL + "?registration=unavailable");
            }

        } catch (SQLException e) {
            e.printStackTrace();

            response.sendRedirect(
                    dashboardURL + "?registration=error");
        }
    }
}