package com.preptrack.controller;

import com.preptrack.dao.StudentDAO;
import com.preptrack.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/students")
public class AdminStudentServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();

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

        // Admin check
        if (!"ADMIN".equals(admin.getRole())) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }

        // Get ICT students
        List<User> students =
                studentDAO.getAllICTStudents();

        request.setAttribute("students", students);

        request.getRequestDispatcher(
                "/admin/students.jsp"
        ).forward(request, response);
    }
}