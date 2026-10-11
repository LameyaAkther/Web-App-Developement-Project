package com.preptrack.dao;

import com.preptrack.model.Course;
import com.preptrack.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {

    public List<Course> getAllICTCourses() {

        List<Course> courses = new ArrayList<>();

        String sql = """
                SELECT
                    course_id,
                    course_code,
                    course_name,
                    department
                FROM courses
                WHERE department = 'ICT'
                ORDER BY course_code
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {

            while (result.next()) {

                Course course = new Course();

                course.setCourseId(
                        result.getInt("course_id")
                );

                course.setCourseCode(
                        result.getString("course_code")
                );

                course.setCourseName(
                        result.getString("course_name")
                );

                course.setDepartment(
                        result.getString("department")
                );

                courses.add(course);
            }

        } catch (Exception e) {
            System.err.println("Error loading ICT courses:");
            e.printStackTrace();
            throw new RuntimeException("Unable to load ICT courses", e);
        }

        return courses;
    }
}