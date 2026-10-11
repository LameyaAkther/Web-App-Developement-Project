package com.preptrack.controller;

import com.preptrack.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import com.preptrack.dao.SeatAllocationDAO;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Login check
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        User admin = (User) session.getAttribute("user");

        // Admin role check
        if (!"ADMIN".equals(admin.getRole())) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        request.setAttribute("admin", admin);
        SeatAllocationDAO seatAllocationDAO = new SeatAllocationDAO();

        request.setAttribute(
            "examSeatSummary",
            seatAllocationDAO.getExamSeatSummary()
        );

        request.getRequestDispatcher(
                "/admin/dashboard.jsp"
        ).forward(request, response);
    }
}