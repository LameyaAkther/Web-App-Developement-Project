package com.preptrack.dao;

import com.preptrack.model.Exam;
import com.preptrack.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;

public class ExamDAO {

    public List<Exam> getAllICTExams() {

        List<Exam> exams = new ArrayList<>();

        String sql = """
                SELECT
                    e.exam_id,
                    e.course_id,
                    c.course_code,
                    c.course_name,
                    e.exam_date,
                    e.start_time,
                    e.end_time,
                    e.status
                FROM exams e
                INNER JOIN courses c
                    ON e.course_id = c.course_id
                WHERE c.department = 'ICT'
                ORDER BY e.exam_date, e.start_time
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {

            while (result.next()) {

                Exam exam = new Exam();

                exam.setExamId(
                        result.getInt("exam_id")
                );

                exam.setCourseId(
                        result.getInt("course_id")
                );

                exam.setCourseCode(
                        result.getString("course_code")
                );

                exam.setCourseName(
                        result.getString("course_name")
                );

                exam.setExamDate(
                        result.getString("exam_date")
                );

                exam.setStartTime(
                        result.getString("start_time")
                );

                exam.setEndTime(
                        result.getString("end_time")
                );

                exam.setStatus(
                        result.getString("status")
                );

                exams.add(exam);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return exams;
    }
    public List<Exam> getPublishedICTExams() {

        List<Exam> exams = new ArrayList<>();

        String sql = """
            SELECT
                e.exam_id,
                e.course_id,
                c.course_code,
                c.course_name,
                e.exam_date,
                e.start_time,
                e.end_time,
                e.status
            FROM exams e
            INNER JOIN courses c
                ON e.course_id = c.course_id
            WHERE c.department = 'ICT'
              AND e.status = 'PUBLISHED'
            ORDER BY e.exam_date, e.start_time
            """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                 connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {

            while (result.next()) {

                Exam exam = new Exam();

                exam.setExamId(result.getInt("exam_id"));
                exam.setCourseId(result.getInt("course_id"));
                exam.setCourseCode(result.getString("course_code"));
                exam.setCourseName(result.getString("course_name"));
                exam.setExamDate(result.getString("exam_date"));
                exam.setStartTime(result.getString("start_time"));
                exam.setEndTime(result.getString("end_time"));
                exam.setStatus(result.getString("status"));

                exams.add(exam);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return exams;
    }
    public List<Exam> getPublishedICTExamsForStudent(int userId) {

        List<Exam> exams = new ArrayList<>();

        String sql = """
            SELECT e.exam_id, e.course_id,
                   c.course_code, c.course_name,
                   e.exam_date, e.start_time, e.end_time,
                   e.status,
                   CASE
                       WHEN s.student_id IS NOT NULL THEN 1
                       ELSE 0
                   END AS registered
            FROM exams e
            INNER JOIN courses c
                ON e.course_id = c.course_id
            LEFT JOIN registrations r
                ON r.exam_id = e.exam_id
            LEFT JOIN students s
                ON s.student_id = r.student_id
               AND s.user_id = ?
            WHERE c.department = 'ICT'
              AND e.status = 'PUBLISHED'
            ORDER BY e.exam_date, e.start_time
            """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            try (ResultSet result = statement.executeQuery()) {

                while (result.next()) {

                    Exam exam = new Exam();

                    exam.setExamId(result.getInt("exam_id"));
                    exam.setCourseId(result.getInt("course_id"));
                    exam.setCourseCode(result.getString("course_code"));
                    exam.setCourseName(result.getString("course_name"));
                    exam.setExamDate(result.getString("exam_date"));
                    exam.setStartTime(result.getString("start_time"));
                    exam.setEndTime(result.getString("end_time"));
                    exam.setStatus(result.getString("status"));

                    exam.setRegistered(
                        result.getInt("registered") == 1
                    );

                    exams.add(exam);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return exams;
    }
}