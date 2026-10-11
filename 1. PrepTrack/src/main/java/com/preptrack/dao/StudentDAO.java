package com.preptrack.dao;

import com.preptrack.model.User;
import com.preptrack.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    public User getStudentByUserId(int userId) {

        String sql = """
                SELECT
                    u.user_id,
                    u.name,
                    u.email,
                    u.role,
                    s.roll_no,
                    s.department,
                    s.semester,
                    s.section
                FROM users u
                INNER JOIN students s
                    ON u.user_id = s.user_id
                WHERE u.user_id = ?
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            try (ResultSet result = statement.executeQuery()) {

                if (result.next()) {

                    User user = new User();

                    user.setUserId(result.getInt("user_id"));
                    user.setName(result.getString("name"));
                    user.setEmail(result.getString("email"));
                    user.setRole(result.getString("role"));
                    user.setRollNo(result.getString("roll_no"));
                    user.setDepartment(result.getString("department"));
                    user.setSemester(result.getInt("semester"));
                    user.setSection(result.getString("section"));

                    return user;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    // Get all ICT students
    public List<User> getAllICTStudents() {

        List<User> students = new ArrayList<>();

        String sql = """
                SELECT
                    u.user_id,
                    u.name,
                    u.email,
                    u.role,
                    s.roll_no,
                    s.department,
                    s.semester,
                    s.section
                FROM users u
                INNER JOIN students s
                    ON u.user_id = s.user_id
                WHERE u.role = 'STUDENT'
                AND s.department = 'ICT'
                ORDER BY s.roll_no
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {

            while (result.next()) {

                User user = new User();

                user.setUserId(result.getInt("user_id"));
                user.setName(result.getString("name"));
                user.setEmail(result.getString("email"));
                user.setRole(result.getString("role"));
                user.setRollNo(result.getString("roll_no"));
                user.setDepartment(result.getString("department"));
                user.setSemester(result.getInt("semester"));
                user.setSection(result.getString("section"));

                students.add(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return students;
    }
}