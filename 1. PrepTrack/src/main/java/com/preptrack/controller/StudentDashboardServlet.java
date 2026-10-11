package com.preptrack.controller;

import com.preptrack.dao.StudentDAO;
import com.preptrack.dao.ExamDAO;
import com.preptrack.model.User;
import com.preptrack.model.Exam;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import com.preptrack.dao.SeatAllocationDAO;
import java.util.Map;
import java.sql.SQLException;

@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAO();
    private final ExamDAO examDAO = new ExamDAO();
    private final SeatAllocationDAO seatAllocationDAO =
            new SeatAllocationDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

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

        User loggedInUser = (User) sessionUser;

        if (!"STUDENT".equals(loggedInUser.getRole())) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN
            );
            return;
        }

        User student = studentDAO.getStudentByUserId(
            loggedInUser.getUserId()
        );

        if (student == null) {
            request.setAttribute(
                "error",
                "Student information could not be found."
            );
            

            request.getRequestDispatcher(
                "/student/dashboard.jsp"
            ).forward(request, response);

            return;
        }

        List<Exam> exams =
                examDAO.getPublishedICTExamsForStudent(
                        loggedInUser.getUserId());

        request.setAttribute("student", student);
        request.setAttribute("exams", exams);
        try {
            request.setAttribute(
                "allocations",
                seatAllocationDAO.getStudentAllocations(
                    loggedInUser.getUserId()
                )
            );
        } catch (SQLException e) {
            e.printStackTrace();

            request.setAttribute(
                "allocationError",
                "Could not load your seat allocation."
            );

            request.setAttribute(
                "allocations",
                new java.util.ArrayList<>()
            );
        }

        request.getRequestDispatcher(
            "/student/dashboard.jsp"
        ).forward(request, response);
    }
}