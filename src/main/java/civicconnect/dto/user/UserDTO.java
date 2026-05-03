package civicconnect.dto.user;

import java.time.LocalDateTime;

public class UserDTO {
    private int id;
    private String fullName;
    private String email;
    private String phone;
    private String role;
    private Integer municipalityId;
    private String municipalityName;
    private Integer wardNumber;
    private String status;
    private LocalDateTime createdAt;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Integer getMunicipalityId() { return municipalityId; }
    public void setMunicipalityId(Integer municipalityId) { this.municipalityId = municipalityId; }

    public String getMunicipalityName() { return municipalityName; }
    public void setMunicipalityName(String municipalityName) { this.municipalityName = municipalityName; }

    public Integer getWardNumber() { return wardNumber; }
    public void setWardNumber(Integer wardNumber) { this.wardNumber = wardNumber; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
