package civicconnect.dto.municipality;

import java.time.LocalDateTime;

public class MunicipalityDTO {
    private int id;
    private String name;
    private String district;
    private String province;
    private String status;
    private LocalDateTime createdAt;

    private String adminName;
    private String adminEmail;
    private String adminPhone;
    private int citizenCount;
    private int complaintCount;

    public MunicipalityDTO() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }

    public String getAdminEmail() {
        return adminEmail;
    }

    public void setAdminEmail(String adminEmail) {
        this.adminEmail = adminEmail;
    }

    public String getAdminPhone() {
        return adminPhone;
    }

    public void setAdminPhone(String adminPhone) {
        this.adminPhone = adminPhone;
    }

    public int getCitizenCount() {
        return citizenCount;
    }

    public void setCitizenCount(int citizenCount) {
        this.citizenCount = citizenCount;
    }

    public int getComplaintCount() {
        return complaintCount;
    }

    public void setComplaintCount(int complaintCount) {
        this.complaintCount = complaintCount;
    }
}
