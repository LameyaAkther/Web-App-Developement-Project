package com.preptrack.controller;

import com.preptrack.dao.ExamDAO;
import com.preptrack.dao.InvigilationDutyDAO;
import com.preptrack.model.Exam;
import com.preptrack.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/exams")
public class AdminExamServlet extends HttpServlet {

    private final ExamDAO examDAO = new ExamDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Login check
        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }

        // Admin check
        User admin = (User) session.getAttribute("user");

        if (!"ADMIN".equals(admin.getRole())) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }

        // Get all ICT exams
        List<Exam> exams =
                examDAO.getAllICTExams();

        request.setAttribute("exams", exams);
        
        request.setAttribute(
        	    "examDutySummary",
        	    new InvigilationDutyDAO().getExamDutySummary()
        	);

        // Open JSP page
        request.getRequestDispatcher(
                "/admin/exams.jsp"
        ).forward(request, response);
    }
}