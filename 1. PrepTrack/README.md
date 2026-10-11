# PrepTrack — Exam Seat & Invigilation Duty Allocator

A Java web application for managing examinations, generating student seating plans, allocating invigilation duties, and allowing students/faculty to view their schedules.

## Stack
- Eclipse IDE for Enterprise Java and Web Developers
- Java 17
- Jakarta Servlet 6 / JSP
- Apache Tomcat 10.1
- MySQL 8+
- JDBC
- HTML/CSS/Vanilla JavaScript
- Maven

## Import into Eclipse
1. Install JDK 17.
2. Install Eclipse IDE for Enterprise Java and Web Developers.
3. Install/configure Tomcat 10.1 in Eclipse.
4. Install MySQL Server and MySQL Workbench.
5. Import this project with **File → Import → Maven → Existing Maven Projects**.
6. Open `src/main/java/com/preptrack/util/DBConnection.java` and change the MySQL username/password.
7. Run `database/preptrack.sql` in MySQL.
8. Right-click project → Maven → Update Project.
9. Right-click project → Run As → Run on Server.
10. Open `http://localhost:8080/PrepTrack/`.

## Demo accounts
After importing the SQL:
- Admin: admin@preptrack.com / admin123
- Student: student@preptrack.com / student123
- Faculty: faculty@preptrack.com / faculty123

Passwords are BCrypt hashes in the seed data.

## Current starter features
- Role-based login
- Student dashboard
- Faculty duty dashboard
- Admin dashboard
- Student/faculty/exam/room management tables
- Basic seating allocation engine
- Basic workload-aware invigilation allocation engine
- Conflict checks
- MySQL persistence

## Next expansion
Add CSV import, visual room layout, notifications, printable reports/PDF, QR exam cards, audit logs, and advanced allocation strategies.
