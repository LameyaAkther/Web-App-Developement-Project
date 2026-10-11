
package com.preptrack.controller;

import com.preptrack.dao.FacultyDAO;
import com.preptrack.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/faculty")
public class AdminFacultyServlet extends HttpServlet {

    private final FacultyDAO facultyDAO = new FacultyDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Check login
        HttpSession session = request.getSession(false);

        if (session == null ||
                !(session.getAttribute("user") instanceof User)) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        User admin = (User) session.getAttribute("user");

        // Check admin role
        if (!"ADMIN".equalsIgnoreCase(admin.getRole())) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Admin access required.");
            return;
        }

        try {
            // Load ICT faculty
            request.setAttribute(
                    "facultyList",
                    facultyDAO.getAllICTFaculty());

            // Load faculty members with faculty_id
            request.setAttribute(
                    "facultyMembers",
                    facultyDAO.getAllICTFacultyMembers());

            // Load unavailable dates
            request.setAttribute(
                    "unavailabilityList",
                    facultyDAO.getAllUnavailability());
            request.setAttribute(
            	    "facultyDutySummary",
            	    new FacultyDAO().getFacultyDutySummary()
            	);

            // Display existing faculty management page
            request.getRequestDispatcher(
                    "/admin/faculty.jsp").forward(request, response);

        } catch (RuntimeException e) {
            throw new ServletException(
                    "Unable to load faculty management data.", e);
        }
    }
}
