
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

@WebServlet("/admin/duties/allocate")
public class AllocateDutyServlet extends HttpServlet {

    private final InvigilationDutyDAO dutyDAO =
            new InvigilationDutyDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1. Check admin login
        if (session == null ||
                !(session.getAttribute("user") instanceof User)) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // 2. Only ADMIN can allocate duties
        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Admin access required.");
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
                    request.getContextPath()
                    + "/admin/exams?duty=invalid");
            return;
        }

        // 4. Allocate invigilation duties
        try {
            String result = dutyDAO.allocateDuties(examId);

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?duty=" + result.toLowerCase());

        } catch (SQLException e) {
            throw new ServletException(
                    "Failed to allocate invigilation duties.", e);
        }
    }
}
