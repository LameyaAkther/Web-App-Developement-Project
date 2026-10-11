
package com.preptrack.controller;

import com.preptrack.dao.InvigilationDutyDAO;
import com.preptrack.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

@WebServlet("/faculty/dashboard")
public class FacultyDashboardServlet extends HttpServlet {

    private final InvigilationDutyDAO dutyDAO =
            new InvigilationDutyDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                !(session.getAttribute("user") instanceof User)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (!"FACULTY".equalsIgnoreCase(user.getRole())) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Faculty access required.");
            return;
        }

        try {
            request.setAttribute(
                    "duties",
                    dutyDAO.getFacultyDuties(user.getUserId()));

        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to load invigilation duties.", e);
        }

        request.getRequestDispatcher(
                "/faculty/dashboard.jsp").forward(request, response);
    }
}
