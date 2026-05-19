package civicconnect.model;

import java.time.LocalDateTime;

public class Votes {
    private int id;
    private int userId;
    private int complaintId;
    private LocalDateTime createdAt;

    public Votes() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getComplaintId() {
        return complaintId;
    }

    public void setComplaintId(int complaintId) {
        this.complaintId = complaintId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Votes(int userId, int complaintId) {
        this.userId = userId;
        this.complaintId = complaintId;
    }

    public Votes(int id, int userId, int complaintId, LocalDateTime createdAt) {
        this.id = id;
        this.userId = userId;
        this.complaintId = complaintId;
        this.createdAt = createdAt;
    }
}
