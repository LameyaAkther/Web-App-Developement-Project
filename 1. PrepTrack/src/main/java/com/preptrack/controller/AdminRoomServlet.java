package com.preptrack.controller;

import com.preptrack.dao.RoomDAO;
import com.preptrack.model.Room;
import com.preptrack.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/rooms")
public class AdminRoomServlet extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();

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

        // Get all rooms
        List<Room> rooms = roomDAO.getAllRooms();

        request.setAttribute("rooms", rooms);

        request.getRequestDispatcher(
                "/admin/rooms.jsp"
        ).forward(request, response);
    }
}