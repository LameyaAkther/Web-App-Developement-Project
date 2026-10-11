CREATE DATABASE IF NOT EXISTS preptrack CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE preptrack;

CREATE TABLE users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(100) NOT NULL,
  role ENUM('STUDENT','FACULTY','ADMIN') NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE students (
  student_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL UNIQUE,
  roll_no VARCHAR(40) NOT NULL UNIQUE,
  department VARCHAR(100) NOT NULL,
  semester INT NOT NULL,
  section VARCHAR(30),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE faculty (
  faculty_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL UNIQUE,
  department VARCHAR(100) NOT NULL,
  max_duties INT DEFAULT 4,
  active BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE rooms (
  room_id INT PRIMARY KEY AUTO_INCREMENT,
  room_name VARCHAR(100) NOT NULL,
  building VARCHAR(100) NOT NULL,
  floor_no INT DEFAULT 1,
  room_capacity INT NOT NULL,
  rows_count INT DEFAULT 5,
  cols_count INT DEFAULT 8,
  active BOOLEAN DEFAULT TRUE
);

CREATE TABLE courses (
  course_id INT PRIMARY KEY AUTO_INCREMENT,
  course_code VARCHAR(30) NOT NULL UNIQUE,
  course_name VARCHAR(150) NOT NULL,
  department VARCHAR(100) NOT NULL
);

CREATE TABLE exams (
  exam_id INT PRIMARY KEY AUTO_INCREMENT,
  course_id INT NOT NULL,
  exam_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  status ENUM('DRAFT','PUBLISHED','COMPLETED') DEFAULT 'DRAFT',
  FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE registrations (
  registration_id INT PRIMARY KEY AUTO_INCREMENT,
  exam_id INT NOT NULL,
  student_id INT NOT NULL,
  UNIQUE KEY uq_registration(exam_id, student_id),
  FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

CREATE TABLE seats (
  seat_id INT PRIMARY KEY AUTO_INCREMENT,
  room_id INT NOT NULL,
  row_label VARCHAR(10) NOT NULL,
  col_no INT NOT NULL,
  UNIQUE KEY uq_seat(room_id,row_label,col_no),
  FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE
);

CREATE TABLE seating_allocations (
  allocation_id INT PRIMARY KEY AUTO_INCREMENT,
  exam_id INT NOT NULL,
  student_id INT NOT NULL,
  room_id INT NOT NULL,
  seat_id INT NOT NULL,
  UNIQUE KEY uq_exam_student(exam_id,student_id),
  UNIQUE KEY uq_exam_seat(exam_id,seat_id),
  FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (room_id) REFERENCES rooms(room_id),
  FOREIGN KEY (seat_id) REFERENCES seats(seat_id)
);

CREATE TABLE invigilation_duties (
  duty_id INT PRIMARY KEY AUTO_INCREMENT,
  exam_id INT NOT NULL,
  faculty_id INT NOT NULL,
  room_id INT NOT NULL,
  UNIQUE KEY uq_faculty_exam_room(exam_id,faculty_id,room_id),
  FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE,
  FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id),
  FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

CREATE TABLE faculty_unavailability (
  id INT PRIMARY KEY AUTO_INCREMENT,
  faculty_id INT NOT NULL,
  unavailable_date DATE NOT NULL,
  UNIQUE KEY uq_unavailability(faculty_id,unavailable_date),
  FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id) ON DELETE CASCADE
);

-- BCrypt hashes for the demo accounts.
INSERT INTO users(name,email,password_hash,role) VALUES
('System Admin','admin@preptrack.com','$2a$10$7EqJtq98hPqEX7fNZaFWoO8j1YkV5Jm9o4l1w8a1Yy3p1yHfZ0d6u','ADMIN'),
('Demo Student','student@preptrack.com','$2a$10$LQv3c1y7s5d3h2b1a0Zf8eQx5Pq6rT9uVwXyZaBcDeFgHiJkLmNoP','STUDENT'),
('Demo Faculty','faculty@preptrack.com','$2a$10$LQv3c1y7s5d3h2b1a0Zf8eQx5Pq6rT9uVwXyZaBcDeFgHiJkLmNoP','FACULTY');

-- For a fresh demo database, replace the placeholder student/faculty hashes by
-- registering through the application, or use the same password after setting
-- BCrypt hashes in your environment.

INSERT INTO students(user_id,roll_no,department,semester,section)
SELECT user_id,'221-15-001','CSE',8,'A' FROM users WHERE email='student@preptrack.com';

INSERT INTO faculty(user_id,department,max_duties)
SELECT user_id,'CSE',4 FROM users WHERE email='faculty@preptrack.com';

INSERT INTO courses(course_code,course_name,department)
VALUES ('CSE315','Data Science','CSE'),('CSE324','Operating Systems','CSE');

INSERT INTO rooms(room_name,building,floor_no,room_capacity,rows_count,cols_count)
VALUES ('Room 301','Academic Building',3,40,5,8),
       ('Room 302','Academic Building',3,40,5,8),
       ('Room 401','Academic Building',4,40,5,8);

INSERT INTO seats(room_id,row_label,col_no)
SELECT r.room_id, CHAR(64+n.r), c.c
FROM rooms r
JOIN (
  SELECT 1 r UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
) n
JOIN (
  SELECT 1 c UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
  SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
) c
WHERE r.room_name IN ('Room 301','Room 302','Room 401');
