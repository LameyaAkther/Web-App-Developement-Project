package com.preptrack.controller;

import com.preptrack.dao.CourseDAO;
import com.preptrack.model.Course;
import com.preptrack.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/courses")
public class AdminCourseServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();

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

        User admin = (User) session.getAttribute("user");

        // Admin check
        if (!"ADMIN".equals(admin.getRole())) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }

        // Get ICT courses
        List<Course> courses =
                courseDAO.getAllICTCourses();

        request.setAttribute("courses", courses);

        request.getRequestDispatcher(
                "/admin/courses.jsp"
        ).forward(request, response);
    }
}