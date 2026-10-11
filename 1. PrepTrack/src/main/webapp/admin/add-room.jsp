<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Add Room - PrepTrack</title>

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
            max-width: 650px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .form-card {
            background: white;
            padding: 35px;
            border-radius: 10px;

            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
        }

        h1 {
            color: #1e293b;
            margin-bottom: 8px;
        }

        .subtitle {
            color: #64748b;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            color: #334155;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 12px;

            border: 1px solid #cbd5e1;
            border-radius: 6px;

            font-size: 15px;
        }

        input:focus {
            outline: none;
            border-color: #2563eb;
        }

        .row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        button {
            width: 100%;
            padding: 12px;

            border: none;
            border-radius: 6px;

            background: #16a34a;
            color: white;

            font-size: 16px;
            font-weight: bold;

            cursor: pointer;
            margin-top: 10px;
        }

        button:hover {
            background: #15803d;
        }

        .note {
            margin-top: 15px;
            padding: 12px;

            background: #eff6ff;
            color: #1e40af;

            border-radius: 6px;

            font-size: 14px;
        }

    </style>

</head>

<body>

<div class="navbar">

    <div class="logo">
        PrepTrack
    </div>

    <a class="back"
       href="<%= request.getContextPath() %>/admin/rooms">
        ← Room List
    </a>

</div>


<div class="container">

    <div class="form-card">

        <h1>🏫 Add Examination Room</h1>

        <p class="subtitle">
            Add a new examination room.
        </p>

        <form
            action="<%= request.getContextPath() %>/admin/rooms/add"
            method="post">

            <div class="form-group">

                <label>
                    Room Name
                </label>

                <input
                    type="text"
                    name="roomName"
                    placeholder="Example: ICT-101"
                    required>

            </div>


            <div class="form-group">

                <label>
                    Building
                </label>

                <input
                    type="text"
                    name="building"
                    placeholder="Example: Main Building"
                    required>

            </div>


            <div class="row">

                <div class="form-group">

                    <label>
                        Floor No
                    </label>

                    <input
                        type="number"
                        name="floorNo"
                        value="1"
                        min="0"
                        required>

                </div>


                <div class="form-group">

                    <label>
                        Room Capacity
                    </label>

                    <input
                        type="number"
                        name="roomCapacity"
                        placeholder="40"
                        min="1"
                        required>

                </div>

            </div>


            <div class="row">

                <div class="form-group">

                    <label>
                        Rows
                    </label>

                    <input
                        type="number"
                        name="rowsCount"
                        value="5"
                        min="1"
                        required>

                </div>


                <div class="form-group">

                    <label>
                        Columns
                    </label>

                    <input
                        type="number"
                        name="colsCount"
                        value="8"
                        min="1"
                        required>

                </div>

            </div>


            <button type="submit">
                Add Room
            </button>

        </form>


        <div class="note">

            💡 Rows × Columns = possible seat positions.
            Make sure the capacity matches your room setup.

        </div>

    </div>

</div>

</body>

</html>