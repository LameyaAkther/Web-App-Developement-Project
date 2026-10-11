package com.preptrack.controller;

import com.preptrack.dao.InvigilationDutyDAO;
import com.preptrack.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/admin/duties")
public class AdminDutiesServlet extends HttpServlet {

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

        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Admin access required.");
            return;
        }

        try {
        	java.util.List<java.util.Map<String, Object>> duties =
        	        dutyDAO.getAllDuties();

        	for (java.util.Map<String, Object> duty : duties) {

        	    int dutyId = (Integer) duty.get("dutyId");

        	    duty.put(
        	        "eligibleFaculty",
        	        dutyDAO.getEligibleFaculty(dutyId)
        	    );
        	}

        	request.setAttribute("duties", duties);

            request.getRequestDispatcher(
                "/admin/duties.jsp")
                .forward(request, response);

        } catch (RuntimeException e) {
            throw new ServletException(
                "Unable to load invigilation duties.", e);
        }
    }
}