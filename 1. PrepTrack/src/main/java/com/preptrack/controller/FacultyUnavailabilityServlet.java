package com.preptrack.controller;

import com.preptrack.model.User;
import com.preptrack.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/admin/faculty/unavailability")
public class FacultyUnavailabilityServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String redirect = request.getContextPath() + "/admin/faculty";

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
                    HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            int facultyId = Integer.parseInt(
                    request.getParameter("facultyId"));

            Date unavailableDate = Date.valueOf(
                    request.getParameter("unavailableDate"));

            if (facultyId <= 0 ||
                    unavailableDate.before(
                            new Date(System.currentTimeMillis()))) {
                response.sendRedirect(
                        redirect + "?unavailability=invalid");
                return;
            }

            String sql =
                    "INSERT INTO faculty_unavailability " +
                    "(faculty_id, unavailable_date) " +
                    "SELECT faculty_id, ? FROM faculty " +
                    "WHERE faculty_id = ? AND active = 1 " +
                    "AND department = 'ICT' " +
                    "AND NOT EXISTS (" +
                    "SELECT 1 FROM faculty_unavailability " +
                    "WHERE faculty_id = ? AND unavailable_date = ?)";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setDate(1, unavailableDate);
                ps.setInt(2, facultyId);
                ps.setInt(3, facultyId);
                ps.setDate(4, unavailableDate);

                int inserted = ps.executeUpdate();

                response.sendRedirect(
                        redirect + (inserted == 1
                                ? "?unavailability=success"
                                : "?unavailability=unavailable"));
            }

        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    redirect + "?unavailability=invalid");

        } catch (SQLException e) {
            throw new ServletException(
                    "Unable to save faculty unavailability.", e);
        }
    }
}
