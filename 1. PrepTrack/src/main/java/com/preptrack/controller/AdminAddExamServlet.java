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

@WebServlet("/admin/add-exam")
public class AdminAddExamServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("ADD EXAM SERVLET STARTED");

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("user") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        Object sessionUser = session.getAttribute("user");

        if (!(sessionUser instanceof User)) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        User user = (User) sessionUser;

        if (!"ADMIN".equals(user.getRole())) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN
            );
            return;
        }

        List<Course> courses = courseDAO.getAllICTCourses();

        System.out.println(
            "ICT COURSES FOUND: " + courses.size()
        );

        for (Course course : courses) {
            System.out.println(
                course.getCourseCode() + " - "
                + course.getCourseName()
            );
        }

        request.setAttribute("courses", courses);

        request.getRequestDispatcher(
            "/admin/add-exam.jsp"
        ).forward(request, response);
    }
}