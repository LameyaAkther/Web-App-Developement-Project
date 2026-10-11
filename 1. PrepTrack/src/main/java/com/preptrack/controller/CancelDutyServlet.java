package com.preptrack.controller;

import com.preptrack.dao.InvigilationDutyDAO;
import com.preptrack.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/duties/cancel")
public class CancelDutyServlet extends HttpServlet {

    private final InvigilationDutyDAO dutyDAO =
            new InvigilationDutyDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !(session.getAttribute("user") instanceof User)) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Admin access required.");
            return;
        }

        String dutyIdParam = request.getParameter("dutyId");

        try {
            int dutyId = Integer.parseInt(dutyIdParam);

            if (dutyId <= 0) {
                response.sendRedirect(
                    request.getContextPath()
                    + "/admin/duties?cancel=invalid");
                return;
            }

            boolean cancelled = dutyDAO.cancelDuty(dutyId);

            response.sendRedirect(
                request.getContextPath()
                + "/admin/duties?cancel="
                + (cancelled ? "success" : "notfound"));

        } catch (NumberFormatException e) {
            response.sendRedirect(
                request.getContextPath()
                + "/admin/duties?cancel=invalid");
        }
    }
}