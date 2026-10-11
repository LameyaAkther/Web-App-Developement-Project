package com.preptrack.model;

public class Room {

    private int roomId;
    private String roomName;
    private String building;
    private int floorNo;
    private int roomCapacity;
    private int rowsCount;
    private int colsCount;
    private boolean active;

    public Room() {
    }

    public Room(int roomId, String roomName, String building,
                int floorNo, int roomCapacity,
                int rowsCount, int colsCount, boolean active) {

        this.roomId = roomId;
        this.roomName = roomName;
        this.building = building;
        this.floorNo = floorNo;
        this.roomCapacity = roomCapacity;
        this.rowsCount = rowsCount;
        this.colsCount = colsCount;
        this.active = active;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getBuilding() {
        return building;
    }

    public void setBuilding(String building) {
        this.building = building;
    }

    public int getFloorNo() {
        return floorNo;
    }

    public void setFloorNo(int floorNo) {
        this.floorNo = floorNo;
    }

    public int getRoomCapacity() {
        return roomCapacity;
    }

    public void setRoomCapacity(int roomCapacity) {
        this.roomCapacity = roomCapacity;
    }

    public int getRowsCount() {
        return rowsCount;
    }

    public void setRowsCount(int rowsCount) {
        this.rowsCount = rowsCount;
    }

    public int getColsCount() {
        return colsCount;
    }

    public void setColsCount(int colsCount) {
        this.colsCount = colsCount;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}