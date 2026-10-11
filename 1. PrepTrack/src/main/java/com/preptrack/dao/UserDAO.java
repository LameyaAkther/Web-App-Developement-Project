package com.preptrack.dao;

import com.preptrack.model.User;
import com.preptrack.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public User findByEmail(String email) throws SQLException {

        String sql = """
                SELECT user_id, name, email, password_hash, role
                FROM users
                WHERE email = ?
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, email);

            try (ResultSet result = statement.executeQuery()) {

                if (result.next()) {

                    User user = new User();

                    user.setUserId(result.getInt("user_id"));
                    user.setName(result.getString("name"));
                    user.setEmail(result.getString("email"));
                    user.setPasswordHash(
                            result.getString("password_hash")
                    );
                    user.setRole(result.getString("role"));

                    return user;
                }
            }
        }

        return null;
    }


    public boolean createUser(User user) throws SQLException {

        String sql = """
                INSERT INTO users
                (name, email, password_hash, role)
                VALUES (?, ?, ?, ?)
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, user.getName());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPasswordHash());
            statement.setString(4, user.getRole());

            return statement.executeUpdate() > 0;
        }
    }
}