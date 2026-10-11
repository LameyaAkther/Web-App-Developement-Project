package com.preptrack.dao;

import com.preptrack.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class SeatAllocationDAO {

    /**
     * Allocates seats sequentially by student roll number.
     * Existing allocations remain unchanged.
     * Only unallocated registered students receive seats.
     */
    public String allocateSeats(int examId) throws SQLException {

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Verify exam exists and is published.
            String examSql =
                    "SELECT status FROM exams WHERE exam_id = ? FOR UPDATE";

            try (PreparedStatement ps = con.prepareStatement(examSql)) {
                ps.setInt(1, examId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback();
                        return "Exam not found.";
                    }

                    if (!"PUBLISHED".equals(rs.getString("status"))) {
                        con.rollback();
                        return "Only published exams can receive seat allocations.";
                    }
                }
            }

            // 2. Get only registered students without an allocation.
            List<Integer> studentIds = new ArrayList<>();

            String studentSql =
                    "SELECT s.student_id " +
                    "FROM registrations r " +
                    "JOIN students s ON s.student_id = r.student_id " +
                    "WHERE r.exam_id = ? " +
                    "AND NOT EXISTS (" +
                    " SELECT 1 FROM seating_allocations a " +
                    " WHERE a.exam_id = r.exam_id " +
                    " AND a.student_id = r.student_id" +
                    ") " +
                    "ORDER BY CAST(s.roll_no AS UNSIGNED), s.roll_no";

            try (PreparedStatement ps = con.prepareStatement(studentSql)) {
                ps.setInt(1, examId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        studentIds.add(rs.getInt("student_id"));
                    }
                }
            }

            // 3. Handle no pending students.
            if (studentIds.isEmpty()) {
                String registeredSql =
                        "SELECT COUNT(*) FROM registrations WHERE exam_id = ?";

                int registeredCount;

                try (PreparedStatement ps =
                             con.prepareStatement(registeredSql)) {
                    ps.setInt(1, examId);

                    try (ResultSet rs = ps.executeQuery()) {
                        rs.next();
                        registeredCount = rs.getInt(1);
                    }
                }

                con.rollback();

                if (registeredCount == 0) {
                    return "No students are registered for this exam.";
                }

                return "All registered students already have seat allocations.";
            }

            // 4. Get seats not already assigned in this exam.
            List<Integer> seatIds = new ArrayList<>();
            List<Integer> roomIds = new ArrayList<>();

            String seatSql =
                    "SELECT s.seat_id, s.room_id " +
                    "FROM rooms r " +
                    "JOIN seats s ON s.room_id = r.room_id " +
                    "WHERE r.active = 1 " +
                    "AND CAST(r.room_name AS UNSIGNED) BETWEEN 201 AND 210 " +
                    "AND NOT EXISTS (" +
                    " SELECT 1 FROM seating_allocations a " +
                    " WHERE a.exam_id = ? AND a.seat_id = s.seat_id" +
                    ") " +
                    "ORDER BY CAST(r.room_name AS UNSIGNED), " +
                    "s.row_label, s.col_no";

            try (PreparedStatement ps = con.prepareStatement(seatSql)) {
                ps.setInt(1, examId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        seatIds.add(rs.getInt("seat_id"));
                        roomIds.add(rs.getInt("room_id"));
                    }
                }
            }

            // 5. Check capacity before inserting anything.
            if (seatIds.size() < studentIds.size()) {
                con.rollback();

                return "Not enough available seats. Required: "
                        + studentIds.size()
                        + ", available: " + seatIds.size()
                        + ". No new allocations were saved.";
            }

            // 6. Allocate one seat per pending student.
            String insertSql =
                    "INSERT INTO seating_allocations " +
                    "(exam_id, student_id, room_id, seat_id) " +
                    "VALUES (?, ?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                for (int i = 0; i < studentIds.size(); i++) {
                    ps.setInt(1, examId);
                    ps.setInt(2, studentIds.get(i));
                    ps.setInt(3, roomIds.get(i));
                    ps.setInt(4, seatIds.get(i));
                    ps.addBatch();
                }

                ps.executeBatch();
            }

            con.commit();

            return "Success! " + studentIds.size()
                    + " students received seats.";

        } catch (SQLException e) {

            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackError) {
                    e.addSuppressed(rollbackError);
                }
            }

            throw e;

        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }

                try {
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public List<Map<String, Object>> getStudentAllocations(int userId)
            throws SQLException {

        List<Map<String, Object>> allocations = new ArrayList<>();

        String sql =
                "SELECT e.exam_id, c.course_code, c.course_name, " +
                "e.exam_date, e.start_time, e.end_time, " +
                "r.room_name, s.row_label, s.col_no " +
                "FROM seating_allocations a " +
                "JOIN exams e ON a.exam_id = e.exam_id " +
                "JOIN courses c ON e.course_id = c.course_id " +
                "JOIN students st ON a.student_id = st.student_id " +
                "JOIN rooms r ON a.room_id = r.room_id " +
                "JOIN seats s ON a.seat_id = s.seat_id " +
                "WHERE st.user_id = ? " +
                "ORDER BY e.exam_date, e.start_time";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new LinkedHashMap<>();

                    item.put("examId", rs.getInt("exam_id"));
                    item.put("courseCode", rs.getString("course_code"));
                    item.put("courseName", rs.getString("course_name"));
                    item.put("examDate", rs.getDate("exam_date"));
                    item.put("startTime", rs.getString("start_time"));
                    item.put("endTime", rs.getString("end_time"));
                    item.put("roomName", rs.getString("room_name"));
                    item.put("rowLabel", rs.getString("row_label"));
                    item.put("colNo", rs.getInt("col_no"));

                    allocations.add(item);
                }
            }
        }

        return allocations;
    }

    public List<Map<String, Object>> getExamSeatSummary() {

        List<Map<String, Object>> summary = new ArrayList<>();

        String sql =
                "SELECT e.exam_id, c.course_code, c.course_name, " +
                "COUNT(DISTINCT reg.student_id) AS registered_students, " +
                "COUNT(DISTINCT sa.student_id) AS allocated_students, " +
                "COUNT(DISTINCT sa.seat_id) AS allocated_seats " +
                "FROM exams e " +
                "JOIN courses c ON e.course_id = c.course_id " +
                "LEFT JOIN registrations reg ON e.exam_id = reg.exam_id " +
                "LEFT JOIN seating_allocations sa " +
                "ON e.exam_id = sa.exam_id " +
                "AND reg.student_id = sa.student_id " +
                "GROUP BY e.exam_id, c.course_code, c.course_name " +
                "ORDER BY e.exam_id";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();

                int registered = rs.getInt("registered_students");
                int allocated = rs.getInt("allocated_students");

                item.put("examId", rs.getInt("exam_id"));
                item.put("courseCode", rs.getString("course_code"));
                item.put("courseName", rs.getString("course_name"));
                item.put("registeredStudents", registered);
                item.put("allocatedStudents", allocated);
                item.put("pendingStudents",
                        Math.max(0, registered - allocated));
                item.put("allocatedSeats", rs.getInt("allocated_seats"));

                item.put("completionPercentage",
                        registered > 0 ? allocated * 100 / registered : 0);

                summary.add(item);
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to load exam seat summary.", e);
        }

        return summary;
    }
}
