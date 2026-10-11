package com.preptrack.controller;

import com.preptrack.dao.InvigilationDutyDAO;
import com.preptrack.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/duties/reassign")
public class ReassignDutyServlet extends HttpServlet {

    private final InvigilationDutyDAO dutyDAO =
            new InvigilationDutyDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String base = request.getContextPath();

        HttpSession session = request.getSession(false);

        if (session == null ||
            !(session.getAttribute("user") instanceof User)) {
            response.sendRedirect(base + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Admin access required.");
            return;
        }

        try {
            int dutyId = Integer.parseInt(
                request.getParameter("dutyId"));

            int facultyId = Integer.parseInt(
                request.getParameter("facultyId"));

            if (dutyId <= 0 || facultyId <= 0) {
                response.sendRedirect(
                    base + "/admin/duties?reassign=invalid");
                return;
            }

            /*
             * The DAO must validate eligibility again and
             * update the existing duty safely.
             */
            boolean reassigned =
                dutyDAO.reassignDuty(dutyId, facultyId);

            response.sendRedirect(
                base + "/admin/duties?reassign=" +
                (reassigned ? "success" : "failed"));

        } catch (NumberFormatException e) {
            response.sendRedirect(
                base + "/admin/duties?reassign=invalid");
        }
    }
}