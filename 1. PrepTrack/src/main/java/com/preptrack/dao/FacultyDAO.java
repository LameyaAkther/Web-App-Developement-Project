
package com.preptrack.dao;

import com.preptrack.model.User;
import com.preptrack.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class FacultyDAO {

    public List<User> getAllICTFaculty() {

        List<User> facultyList = new ArrayList<>();

        String sql = """
                SELECT
                    u.user_id,
                    u.name,
                    u.email,
                    u.role,
                    f.faculty_id,
                    f.department,
                    f.active
                FROM users u
                INNER JOIN faculty f
                    ON u.user_id = f.user_id
                WHERE u.role = 'FACULTY'
                AND f.department = 'ICT'
                ORDER BY u.name
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {

            while (result.next()) {

                User faculty = new User();

                faculty.setUserId(result.getInt("user_id"));
                faculty.setName(result.getString("name"));
                faculty.setEmail(result.getString("email"));
                faculty.setRole(result.getString("role"));
                faculty.setDepartment(result.getString("department"));

                facultyList.add(faculty);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return facultyList;
    }

public List<com.preptrack.model.FacultyMember> getAllICTFacultyMembers() {

    List<com.preptrack.model.FacultyMember> list =
            new ArrayList<>();

    String sql = """
            SELECT f.faculty_id, u.user_id, u.name, u.email,
                   f.department, f.active
            FROM users u
            JOIN faculty f ON u.user_id = f.user_id
            WHERE u.role = 'FACULTY'
              AND f.department = 'ICT'
            ORDER BY u.name
            """;

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            com.preptrack.model.FacultyMember member =
                    new com.preptrack.model.FacultyMember();

            member.setFacultyId(rs.getInt("faculty_id"));
            member.setUserId(rs.getInt("user_id"));
            member.setName(rs.getString("name"));
            member.setEmail(rs.getString("email"));
            member.setDepartment(rs.getString("department"));
            member.setActive(rs.getBoolean("active"));

            list.add(member);
        }

    } catch (java.sql.SQLException e) {
        throw new RuntimeException(
                "Unable to load ICT faculty.", e);
    }

    return list;
}

public List<java.util.Map<String, Object>> getAllUnavailability() {

    List<java.util.Map<String, Object>> list =
            new ArrayList<>();

    String sql = """
        SELECT fu.id, f.faculty_id, u.name,
               f.department, fu.unavailable_date
        FROM faculty_unavailability fu
        JOIN faculty f ON fu.faculty_id = f.faculty_id
        JOIN users u ON f.user_id = u.user_id
        ORDER BY fu.unavailable_date, u.name
        """;

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            java.util.Map<String, Object> item =
                    new java.util.HashMap<>();

            item.put("id", rs.getInt("id"));
            item.put("facultyId", rs.getInt("faculty_id"));
            item.put("name", rs.getString("name"));
            item.put("department", rs.getString("department"));
            item.put("unavailableDate",
                    rs.getDate("unavailable_date"));

            list.add(item);
        }

    } catch (java.sql.SQLException e) {
        throw new RuntimeException(
                "Unable to load faculty unavailability.", e);
    }

    return list;
}
public List<Map<String, Object>> getFacultyDutySummary() {
    List<Map<String, Object>> summary = new ArrayList<>();

    String sql = "SELECT f.faculty_id, u.name, f.max_duties, " +
                 "COUNT(d.duty_id) AS assigned_duties, " +
                 "(f.max_duties - COUNT(d.duty_id)) AS remaining_duties " +
                 "FROM faculty f " +
                 "JOIN users u ON f.user_id = u.user_id " +
                 "LEFT JOIN invigilation_duties d ON f.faculty_id = d.faculty_id " +
                 "WHERE f.department = 'ICT' AND f.active = 1 " +
                 "GROUP BY f.faculty_id, u.name, f.max_duties " +
                 "ORDER BY assigned_duties ASC, u.name ASC";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();

            row.put("facultyId", rs.getInt("faculty_id"));
            row.put("name", rs.getString("name"));
            row.put("maxDuties", rs.getInt("max_duties"));
            row.put("assignedDuties", rs.getInt("assigned_duties"));
            row.put("remainingDuties", rs.getInt("remaining_duties"));

            summary.add(row);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return summary;
}
}
