<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.preptrack.model.Room" %>

<%
    List<Room> rooms =
            (List<Room>) request.getAttribute("rooms");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Room Management - PrepTrack</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f4f6f9;
        }

        .navbar {
            height: 65px;
            background: #1e293b;
            color: white;

            display: flex;
            align-items: center;
            justify-content: space-between;

            padding: 0 35px;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
        }

        .back {
            text-decoration: none;
            color: white;
            background: #2563eb;
            padding: 9px 16px;
            border-radius: 6px;
        }

        .container {
            padding: 35px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;

            margin-bottom: 25px;
        }

        .header h1 {
            color: #1e293b;
        }

        .header p {
            color: #64748b;
            margin-top: 6px;
        }

        .room-count {
            background: white;
            padding: 15px 22px;
            border-radius: 8px;

            box-shadow: 0 3px 10px rgba(0,0,0,0.08);

            color: #334155;
        }

        .table-container {
            background: white;
            border-radius: 10px;
            overflow-x: auto;

            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #1e293b;
            color: white;

            padding: 14px;
            text-align: left;
        }

        td {
            padding: 14px;
            border-bottom: 1px solid #e2e8f0;
            color: #334155;
        }

        tr:hover {
            background: #f8fafc;
        }

        .empty {
            text-align: center;
            padding: 40px;
            color: #64748b;
        }
        .add-btn {
    text-decoration: none;
    color: white;
    background: #16a34a;
    padding: 10px 18px;
    border-radius: 6px;
    font-weight: bold;
}

    </style>

</head>

<body>

    <!-- Navbar -->

    <div class="navbar">

        <div class="logo">
            PrepTrack
        </div>

        <a class="back"
           href="<%= request.getContextPath() %>/admin/dashboard">
            ← Dashboard
        </a>

    </div>


    <!-- Main Content -->

    <div class="container">

        <div class="header">

            <div>

                <h1>🏫 Room Management</h1>

                <p>
                    Examination Rooms
                </p>

            </div>

           <div style="display:flex; align-items:center; gap:15px;">

    <a class="add-btn"
       href="<%= request.getContextPath() %>/admin/add-room.jsp">
        + Add Room
    </a>

    <div class="room-count">

        Total Rooms:
        <strong>
            <%= rooms.size() %>
        </strong>

    </div>

</div>

        </div>


        <!-- Room Table -->

        <div class="table-container">

            <table>

                <thead>

                    <tr>

                        <th>#</th>
                        <th>Room ID</th>
                       <th>Room Name</th>
<th>Building</th>
<th>Floor</th>
<th>Capacity</th>
<th>Rows</th>
<th>Columns</th>
<th>Status</th>

                    </tr>

                </thead>

                <tbody>

                <%
                    if (rooms.isEmpty()) {
                %>

                    <tr>

                       <td colspan="9" class="empty">
    No examination rooms found.
</td>

                    </tr>

                <%
                    } else {

                        int count = 1;

                        for (Room room : rooms) {
                %>

                    <tr>
    <td><%= count++ %></td>

    <td><%= room.getRoomId() %></td>

    <td><%= room.getRoomName() %></td>

    <td><%= room.getBuilding() %></td>

    <td><%= room.getFloorNo() %></td>

    <td><%= room.getRoomCapacity() %> seats</td>

    <td><%= room.getRowsCount() %></td>

    <td><%= room.getColsCount() %></td>

    <td>
        <%= room.isActive() ? "Active" : "Inactive" %>
    </td>
</tr>

                <%
                        }
                    }
                %>

                </tbody>

            </table>

        </div>

    </div>

</body>

</html>