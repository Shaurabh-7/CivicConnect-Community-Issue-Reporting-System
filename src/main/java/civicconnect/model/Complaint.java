package civicconnect.model;

import java.time.LocalDateTime;

public class Complaint {
    private int id;
    private int userId;
    private int municipalityId;
    private int categoryId;
    private String title;
    private String description;
    private int wardNumber;
    private String location;
    private String imagePath;
    private boolean isAnonymous;
    private String status;
    private int voteCount;
    private String contactEmail;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

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

    public int getMunicipalityId() {
        return municipalityId;
    }

    public void setMunicipalityId(int municipalityId) {
        this.municipalityId = municipalityId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getWardNumber() {
        return wardNumber;
    }

    public void setWardNumber(int wardNumber) {
        this.wardNumber = wardNumber;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public boolean isAnonymous() {
        return isAnonymous;
    }

    public void setAnonymous(boolean anonymous) {
        isAnonymous = anonymous;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getVoteCount() {
        return voteCount;
    }

    public void setVoteCount(int voteCount) {
        this.voteCount = voteCount;
    }

    public String getContactEmail() {
        return contactEmail;
    }

    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Complaint(int userId, int municipalityId, int categoryId, String title, String description, int wardNumber, String location, String imagePath, boolean isAnonymous, String contactEmail) {
        this.userId = userId;
        this.municipalityId = municipalityId;
        this.categoryId = categoryId;
        this.title = title;
        this.description = description;
        this.wardNumber = wardNumber;
        this.location = location;
        this.imagePath = imagePath;
        this.isAnonymous = isAnonymous;
        this.contactEmail = contactEmail;
    }

    public Complaint(int id, int userId, int municipalityId, int categoryId, String title, String description, int wardNumber, String location, String imagePath, boolean isAnonymous, String status, int voteCount, String contactEmail, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.userId = userId;
        this.municipalityId = municipalityId;
        this.categoryId = categoryId;
        this.title = title;
        this.description = description;
        this.wardNumber = wardNumber;
        this.location = location;
        this.imagePath = imagePath;
        this.isAnonymous = isAnonymous;
        this.status = status;
        this.voteCount = voteCount;
        this.contactEmail = contactEmail;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
}
