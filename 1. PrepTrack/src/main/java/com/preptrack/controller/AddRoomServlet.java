package com.preptrack.controller;

import com.preptrack.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/admin/rooms/add")
public class AddRoomServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
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

        String roomName = request.getParameter("roomName");
        String building = request.getParameter("building");
        String floorText = request.getParameter("floorNo");
        String capacityText = request.getParameter("roomCapacity");
        String rowsText = request.getParameter("rowsCount");
        String colsText = request.getParameter("colsCount");

        if (roomName == null || building == null ||
            floorText == null || capacityText == null ||
            rowsText == null || colsText == null ||
            roomName.isBlank() || building.isBlank()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/add-room.jsp?error=required"
            );
            return;
        }

        try {

            int floorNo = Integer.parseInt(floorText);
            int roomCapacity = Integer.parseInt(capacityText);
            int rowsCount = Integer.parseInt(rowsText);
            int colsCount = Integer.parseInt(colsText);

            if (floorNo < 0 ||
                roomCapacity <= 0 ||
                rowsCount <= 0 ||
                colsCount <= 0) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/add-room.jsp?error=invalid"
                );
                return;
            }

            String sql = """
                    INSERT INTO rooms
                    (
                        room_name,
                        building,
                        floor_no,
                        room_capacity,
                        rows_count,
                        cols_count,
                        active
                    )
                    VALUES (?, ?, ?, ?, ?, ?, 1)
                    """;

            try (Connection connection =
                         DBConnection.getConnection();
                 PreparedStatement statement =
                         connection.prepareStatement(sql)) {

                statement.setString(1, roomName.trim());
                statement.setString(2, building.trim());
                statement.setInt(3, floorNo);
                statement.setInt(4, roomCapacity);
                statement.setInt(5, rowsCount);
                statement.setInt(6, colsCount);

                statement.executeUpdate();
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/rooms?success=added"
            );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/add-room.jsp?error=invalid"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/add-room.jsp?error=failed"
            );
        }
    }
}