
package com.preptrack.dao;

import com.preptrack.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import java.util.*;


public class InvigilationDutyDAO {

    public String allocateDuties(int examId) throws SQLException {

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Check exam and lock its record
            String examSql =
                "SELECT e.exam_id, e.exam_date, e.start_time, e.end_time, " +
                "e.status, c.department " +
                "FROM exams e " +
                "JOIN courses c ON e.course_id = c.course_id " +
                "WHERE e.exam_id = ? FOR UPDATE";

            int courseDepartment;
            String department;
            java.sql.Date examDate;
            Time startTime;
            Time endTime;
            String status;

            try (PreparedStatement ps = con.prepareStatement(examSql)) {
                ps.setInt(1, examId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback();
                        return "EXAM_NOT_FOUND";
                    }

                    status = rs.getString("status");
                    examDate = rs.getDate("exam_date");
                    startTime = rs.getTime("start_time");
                    endTime = rs.getTime("end_time");
                    department = rs.getString("department");
                }
            }

            if (!"PUBLISHED".equals(status)) {
                con.rollback();
                return "EXAM_NOT_PUBLISHED";
            }

            // 2. Prevent duplicate allocation
            String existingSql =
                "SELECT COUNT(*) FROM invigilation_duties WHERE exam_id = ?";

            try (PreparedStatement ps = con.prepareStatement(existingSql)) {
                ps.setInt(1, examId);

                try (ResultSet rs = ps.executeQuery()) {
                    rs.next();

                    if (rs.getInt(1) > 0) {
                        con.rollback();
                        return "ALREADY_ALLOCATED";
                    }
                }
            }

            // 3. Find rooms that actually have allocated students
            List<Integer> roomIds = new ArrayList<>();

            String roomSql =
                "SELECT DISTINCT room_id " +
                "FROM seating_allocations " +
                "WHERE exam_id = ? ORDER BY room_id";

            try (PreparedStatement ps = con.prepareStatement(roomSql)) {
                ps.setInt(1, examId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        roomIds.add(rs.getInt("room_id"));
                    }
                }
            }

            if (roomIds.isEmpty()) {
                con.rollback();
                return "NO_ALLOCATED_ROOMS";
            }

            // 4. Find eligible faculty
            String facultySql =
                "SELECT f.faculty_id, f.max_duties " +
                "FROM faculty f " +
                "JOIN users u ON f.user_id = u.user_id " +
                "WHERE f.active = 1 " +
                "AND u.role = 'FACULTY' " +
                "AND f.department = ? " +
                "AND NOT EXISTS (" +
                " SELECT 1 FROM faculty_unavailability fu " +
                " WHERE fu.faculty_id = f.faculty_id " +
                " AND fu.unavailable_date = ?" +
                ") " +
                "AND (" +
                " SELECT COUNT(*) FROM invigilation_duties d " +
                " WHERE d.faculty_id = f.faculty_id" +
                ") < f.max_duties " +
                "AND NOT EXISTS (" +
                " SELECT 1 FROM invigilation_duties d " +
                " JOIN exams e2 ON d.exam_id = e2.exam_id " +
                " WHERE d.faculty_id = f.faculty_id " +
                " AND e2.exam_date = ? " +
                " AND e2.start_time < ? " +
                " AND e2.end_time > ?" +
                ") " +
                "ORDER BY (" +
                " SELECT COUNT(*) FROM invigilation_duties d " +
                " WHERE d.faculty_id = f.faculty_id" +
                "), f.faculty_id";

            List<Integer> facultyIds = new ArrayList<>();

            try (PreparedStatement ps = con.prepareStatement(facultySql)) {
                ps.setString(1, department);
                ps.setDate(2, examDate);
                ps.setDate(3, examDate);
                ps.setTime(4, endTime);
                ps.setTime(5, startTime);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        facultyIds.add(rs.getInt("faculty_id"));
                    }
                }
            }

            // One faculty member per occupied room
            if (facultyIds.size() < roomIds.size()) {
                con.rollback();
                return "NOT_ENOUGH_FACULTY";
            }

            // 5. Insert duties, balancing faculty workload
            String insertSql =
                "INSERT INTO invigilation_duties " +
                "(exam_id, faculty_id, room_id) VALUES (?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                for (int i = 0; i < roomIds.size(); i++) {
                    ps.setInt(1, examId);
                    ps.setInt(2, facultyIds.get(i));
                    ps.setInt(3, roomIds.get(i));
                    ps.addBatch();
                }

                ps.executeBatch();
            }

            con.commit();
            return "SUCCESS";

        } catch (SQLException e) {
            if (con != null) {
                con.rollback();
            }
            throw e;

        } finally {
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }

public java.util.List<java.util.Map<String, Object>>
        getFacultyDuties(int userId) throws java.sql.SQLException {

    java.util.List<java.util.Map<String, Object>> duties =
            new java.util.ArrayList<>();

    String sql =
        "SELECT d.duty_id, e.exam_id, c.course_code, " +
        "c.course_name, e.exam_date, e.start_time, e.end_time, " +
        "r.room_name AS room_number " +
        "FROM invigilation_duties d " +
        "JOIN faculty f ON d.faculty_id = f.faculty_id " +
        "JOIN exams e ON d.exam_id = e.exam_id " +
        "JOIN courses c ON e.course_id = c.course_id " +
        "JOIN rooms r ON d.room_id = r.room_id " +
        "WHERE f.user_id = ? " +
        "ORDER BY e.exam_date, e.start_time";

    try (java.sql.Connection con =
                 com.preptrack.util.DBConnection.getConnection();
         java.sql.PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, userId);

        try (java.sql.ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                java.util.Map<String, Object> duty =
                        new java.util.HashMap<>();

                duty.put("dutyId", rs.getInt("duty_id"));
                duty.put("examId", rs.getInt("exam_id"));
                duty.put("courseCode", rs.getString("course_code"));
                duty.put("courseName", rs.getString("course_name"));
                duty.put("examDate", rs.getDate("exam_date"));
                duty.put("startTime", rs.getTime("start_time"));
                duty.put("endTime", rs.getTime("end_time"));
                duty.put("roomNumber", rs.getString("room_number"));

                duties.add(duty);
            }
        }
    }

    return duties;
}
public List<Map<String, Object>> getAllDuties() {
    List<Map<String, Object>> duties = new ArrayList<>();

    String sql = "SELECT d.duty_id, u.name AS faculty_name, " +
            "c.course_code, c.course_name, e.exam_date, " +
            "e.start_time, e.end_time, r.room_name, " +
            "f.max_duties, " +
            "(SELECT COUNT(*) FROM invigilation_duties d2 " +
            " WHERE d2.faculty_id = f.faculty_id) AS assigned_duties " +
            "FROM invigilation_duties d " +
            "JOIN faculty f ON d.faculty_id = f.faculty_id " +
            "JOIN users u ON f.user_id = u.user_id " +
            "JOIN exams e ON d.exam_id = e.exam_id " +
            "JOIN courses c ON e.course_id = c.course_id " +
            "JOIN rooms r ON d.room_id = r.room_id " +
            "ORDER BY e.exam_date, e.start_time, r.room_name";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Map<String, Object> duty = new HashMap<>();

            duty.put("dutyId", rs.getInt("duty_id"));
            duty.put("facultyName", rs.getString("faculty_name"));
            duty.put("courseCode", rs.getString("course_code"));
            duty.put("courseName", rs.getString("course_name"));
            duty.put("examDate", rs.getDate("exam_date"));
            duty.put("startTime", rs.getTime("start_time"));
            duty.put("endTime", rs.getTime("end_time"));
            duty.put("roomName", rs.getString("room_name"));

            int maxDuties = rs.getInt("max_duties");
            int assignedDuties = rs.getInt("assigned_duties");

            int workload = maxDuties > 0
                    ? Math.min(100, assignedDuties * 100 / maxDuties)
                    : 0;

            duty.put("maxDuties", maxDuties);
            duty.put("assignedDuties", assignedDuties);
            duty.put("workload", workload);
            duty.put("remainingDuties",
                    Math.max(0, maxDuties - assignedDuties));

            duties.add(duty);
        }

    } catch (SQLException e) {
        throw new RuntimeException(
                "Unable to load invigilation duties.", e);
    }

    return duties;
}
public boolean cancelDuty(int dutyId) {

    String sql =
        "DELETE FROM invigilation_duties WHERE duty_id = ?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, dutyId);

        return ps.executeUpdate() == 1;

    } catch (SQLException e) {
        throw new RuntimeException(
            "Unable to cancel invigilation duty.", e);
    }
}
public List<Map<String, Object>> getEligibleFaculty(int dutyId) {

    List<Map<String, Object>> facultyList = new ArrayList<>();

    String sql =
        "SELECT f.faculty_id, u.name " +
        "FROM invigilation_duties d " +
        "JOIN exams e ON d.exam_id = e.exam_id " +
        "JOIN courses c ON e.course_id = c.course_id " +
        "JOIN faculty f ON f.department = c.department " +
        "JOIN users u ON f.user_id = u.user_id " +
        "WHERE d.duty_id = ? " +
        "AND f.active = 1 " +
        "AND f.max_duties > (" +
        " SELECT COUNT(*) FROM invigilation_duties d2 " +
        " WHERE d2.faculty_id = f.faculty_id " +
        ") " +
        "AND NOT EXISTS (" +
        " SELECT 1 FROM faculty_unavailability fu " +
        " WHERE fu.faculty_id = f.faculty_id " +
        " AND fu.unavailable_date = e.exam_date " +
        ") " +
        "AND NOT EXISTS (" +
        " SELECT 1 FROM invigilation_duties d3 " +
        " JOIN exams e3 ON d3.exam_id = e3.exam_id " +
        " WHERE d3.faculty_id = f.faculty_id " +
        " AND d3.duty_id <> d.duty_id " +
        " AND e3.exam_date = e.exam_date " +
        " AND e3.start_time < e.end_time " +
        " AND e3.end_time > e.start_time " +
        ") " +
        "ORDER BY u.name";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, dutyId);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> faculty = new HashMap<>();
                faculty.put("facultyId", rs.getInt("faculty_id"));
                faculty.put("name", rs.getString("name"));
                facultyList.add(faculty);
            }
        }

    } catch (SQLException e) {
        throw new RuntimeException(
            "Unable to load eligible faculty.", e);
    }

    return facultyList;
}
public boolean reassignDuty(int dutyId, int newFacultyId) {

    String lockSql =
        "SELECT d.exam_id, d.room_id, e.exam_date, " +
        "e.start_time, e.end_time, c.department " +
        "FROM invigilation_duties d " +
        "JOIN exams e ON d.exam_id = e.exam_id " +
        "JOIN courses c ON e.course_id = c.course_id " +
        "WHERE d.duty_id = ? FOR UPDATE";

    String facultySql =
        "SELECT f.faculty_id " +
        "FROM faculty f " +
        "JOIN courses c ON f.department = c.department " +
        "JOIN exams e ON e.course_id = c.course_id " +
        "JOIN invigilation_duties d ON d.exam_id = e.exam_id " +
        "WHERE d.duty_id = ? " +
        "AND f.faculty_id = ? " +
        "AND f.active = 1 " +
        "AND f.max_duties > (" +
        " SELECT COUNT(*) FROM invigilation_duties x " +
        " WHERE x.faculty_id = f.faculty_id " +
        " AND x.duty_id <> d.duty_id" +
        ") " +
        "AND NOT EXISTS (" +
        " SELECT 1 FROM faculty_unavailability fu " +
        " WHERE fu.faculty_id = f.faculty_id " +
        " AND fu.unavailable_date = e.exam_date" +
        ") " +
        "AND NOT EXISTS (" +
        " SELECT 1 FROM invigilation_duties x " +
        " JOIN exams ex ON x.exam_id = ex.exam_id " +
        " WHERE x.faculty_id = f.faculty_id " +
        " AND x.duty_id <> d.duty_id " +
        " AND ex.exam_date = e.exam_date " +
        " AND ex.start_time < e.end_time " +
        " AND ex.end_time > e.start_time" +
        ")";

    String updateSql =
        "UPDATE invigilation_duties " +
        "SET faculty_id = ? WHERE duty_id = ?";

    try (Connection con = DBConnection.getConnection()) {

        con.setAutoCommit(false);

        try {
            // Lock the selected duty.
            try (PreparedStatement ps =
                     con.prepareStatement(lockSql)) {

                ps.setInt(1, dutyId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback();
                        return false;
                    }

                    if (!"PUBLISHED".equalsIgnoreCase(
                            getExamStatus(con, rs.getInt("exam_id")))) {
                        con.rollback();
                        return false;
                    }
                }
            }

            // Recheck eligibility on the server.
            try (PreparedStatement ps =
                     con.prepareStatement(facultySql)) {

                ps.setInt(1, dutyId);
                ps.setInt(2, newFacultyId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback();
                        return false;
                    }
                }
            }

            // Update the existing duty.
            try (PreparedStatement ps =
                     con.prepareStatement(updateSql)) {

                ps.setInt(1, newFacultyId);
                ps.setInt(2, dutyId);

                if (ps.executeUpdate() != 1) {
                    con.rollback();
                    return false;
                }
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            con.rollback();
            throw e;

        } finally {
            con.setAutoCommit(true);
        }

    } catch (SQLException e) {
        throw new RuntimeException(
            "Unable to reassign invigilation duty.", e);
    }
}

private String getExamStatus(Connection con, int examId)
        throws SQLException {

    String sql = "SELECT status FROM exams WHERE exam_id = ?";

    try (PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, examId);

        try (ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getString("status") : null;
        }
    }
}

public List<Map<String, Object>> getExamDutySummary() {
    List<Map<String, Object>> summary = new ArrayList<>();

    String sql = "SELECT e.exam_id, c.course_code, c.course_name, " +
            "e.exam_date, e.start_time, e.end_time, " +
            "COUNT(DISTINCT d.room_id) AS total_rooms, " +
            "COUNT(DISTINCT d.faculty_id) AS total_faculty, " +
            "COUNT(d.duty_id) AS total_duties " +
            "FROM exams e " +
            "JOIN courses c ON e.course_id = c.course_id " +
            "LEFT JOIN invigilation_duties d ON e.exam_id = d.exam_id " +
            "GROUP BY e.exam_id, c.course_code, c.course_name, " +
            "e.exam_date, e.start_time, e.end_time " +
            "ORDER BY e.exam_date, e.start_time";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Map<String, Object> exam = new HashMap<>();

            exam.put("examId", rs.getInt("exam_id"));
            exam.put("courseCode", rs.getString("course_code"));
            exam.put("courseName", rs.getString("course_name"));
            exam.put("examDate", rs.getDate("exam_date"));
            exam.put("startTime", rs.getTime("start_time"));
            exam.put("endTime", rs.getTime("end_time"));
            exam.put("totalRooms", rs.getInt("total_rooms"));
            exam.put("totalFaculty", rs.getInt("total_faculty"));
            exam.put("totalDuties", rs.getInt("total_duties"));

            summary.add(exam);
        }

    } catch (SQLException e) {
        throw new RuntimeException(
                "Unable to load exam duty summary.", e);
    }

    return summary;
}
}
