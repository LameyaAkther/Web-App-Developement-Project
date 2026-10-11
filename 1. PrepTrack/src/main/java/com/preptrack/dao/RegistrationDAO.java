package com.preptrack.dao;

import com.preptrack.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RegistrationDAO {

    /**
     * Registers an ICT student for a published ICT exam.
     * Returns true if registration succeeds.
     * Returns false if the student is invalid,
     * the exam is unavailable, or already registered.
     */
    public boolean registerStudentForExam(
            int userId, int examId) throws SQLException {

        String validationSQL = """
            SELECT e.exam_id
            FROM exams e
            INNER JOIN courses c
                ON e.course_id = c.course_id
            INNER JOIN students s
                ON s.user_id = ?
            INNER JOIN users u
                ON u.user_id = s.user_id
            WHERE e.exam_id = ?
              AND e.status = 'PUBLISHED'
              AND c.department = 'ICT'
              AND s.department = 'ICT'
              AND u.role = 'STUDENT'
            """;

        String insertSQL = """
            INSERT INTO registrations (exam_id, student_id)
            VALUES (?, ?)
            """;

        try (Connection connection =
                 DBConnection.getConnection()) {

            // 1. Validate student and exam
            int studentId;

            try (PreparedStatement statement =
                     connection.prepareStatement(validationSQL)) {

                statement.setInt(1, userId);
                statement.setInt(2, examId);

                try (ResultSet result = statement.executeQuery()) {
                    if (!result.next()) {
                        return false;
                    }
                }
            }

            // 2. Get the student's database ID
            String studentSQL = """
                SELECT student_id
                FROM students
                WHERE user_id = ?
                  AND department = 'ICT'
                """;

            try (PreparedStatement statement =
                     connection.prepareStatement(studentSQL)) {

                statement.setInt(1, userId);

                try (ResultSet result = statement.executeQuery()) {
                    if (!result.next()) {
                        return false;
                    }

                    studentId = result.getInt("student_id");
                }
            }

            // 3. Insert registration
            try (PreparedStatement statement =
                     connection.prepareStatement(insertSQL)) {

                statement.setInt(1, examId);
                statement.setInt(2, studentId);

                return statement.executeUpdate() == 1;
            }

        } catch (SQLException e) {

            // MySQL error 1062 means duplicate unique key.
            if (e.getErrorCode() == 1062) {
                return false;
            }

            throw e;
        }
    }

    /**
     * Checks whether a student is registered for an exam.
     */
    public boolean isRegistered(
            int userId, int examId) throws SQLException {

        String sql = """
            SELECT 1
            FROM registrations r
            INNER JOIN students s
                ON s.student_id = r.student_id
            WHERE s.user_id = ?
              AND r.exam_id = ?
            """;

        try (Connection connection =
                 DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(sql)) {

            statement.setInt(1, userId);
            statement.setInt(2, examId);

            try (ResultSet result = statement.executeQuery()) {
                return result.next();
            }
        }
    }
}