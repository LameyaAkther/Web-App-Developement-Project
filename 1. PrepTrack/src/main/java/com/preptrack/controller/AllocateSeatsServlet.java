
package com.preptrack.controller;

import com.preptrack.dao.SeatAllocationDAO;
import com.preptrack.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/seats/allocate")
public class AllocateSeatsServlet extends HttpServlet {

    private final SeatAllocationDAO allocationDAO =
            new SeatAllocationDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        Object sessionUser = session.getAttribute("user");

        if (!(sessionUser instanceof User)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        User user = (User) sessionUser;

        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String examIdParam = request.getParameter("examId");

        try {
            int examId = Integer.parseInt(examIdParam);

            if (examId <= 0) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/exams?allocation=invalid");
                return;
            }

            String result = allocationDAO.allocateSeats(examId);

            if (result.startsWith("Success!")) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/exams?allocation=success");
            } else {
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/exams?allocation=unavailable");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/exams?allocation=invalid");

        } catch (SQLException e) {
            throw new ServletException(
                    "Failed to allocate exam seats.", e);
        }
    }
}
