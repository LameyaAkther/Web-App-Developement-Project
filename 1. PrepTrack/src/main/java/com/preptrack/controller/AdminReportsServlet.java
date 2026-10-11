package com.preptrack.controller;

import com.preptrack.dao.ExamDAO;
import com.preptrack.model.Exam;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reports")
public class AdminReportsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        Object userObject = session.getAttribute("user");

        if (!(userObject instanceof com.preptrack.model.User)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        com.preptrack.model.User user =
            (com.preptrack.model.User) userObject;

        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            ExamDAO examDAO = new ExamDAO();
            List<Exam> exams = examDAO.getAllICTExams();

            request.setAttribute("exams", exams);

            request.getRequestDispatcher("/admin/reports.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load examination reports.", e
            );
        }
    }
}