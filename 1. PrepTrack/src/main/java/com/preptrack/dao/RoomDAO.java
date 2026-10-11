package com.preptrack.dao;

import com.preptrack.model.Room;
import com.preptrack.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    public List<Room> getAllRooms() {

        List<Room> rooms = new ArrayList<>();

        String sql = """
                SELECT
                    room_id,
                    room_name,
                    building,
                    floor_no,
                    room_capacity,
                    rows_count,
                    cols_count,
                    active
                FROM rooms
                ORDER BY room_id
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {

            while (result.next()) {

                Room room = new Room();

                room.setRoomId(
                        result.getInt("room_id")
                );

                room.setRoomName(
                        result.getString("room_name")
                );

                room.setBuilding(
                        result.getString("building")
                );

                room.setFloorNo(
                        result.getInt("floor_no")
                );

                room.setRoomCapacity(
                        result.getInt("room_capacity")
                );

                room.setRowsCount(
                        result.getInt("rows_count")
                );

                room.setColsCount(
                        result.getInt("cols_count")
                );

                room.setActive(
                        result.getBoolean("active")
                );

                rooms.add(room);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rooms;
    }
}