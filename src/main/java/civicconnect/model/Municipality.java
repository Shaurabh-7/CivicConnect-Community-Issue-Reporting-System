package civicconnect.model;

import java.time.LocalDateTime;

public class Municipality {
    private int id;
    private String name;
    private String district;
    private String province;
    private String status;
    private LocalDateTime createdAt;

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

    public Municipality() {}

    public Municipality(int id, String name, String district, String province, String status, LocalDateTime createdAt) {
        this.id = id;
        this.name = name;
        this.district = district;
        this.province = province;
        this.status = status;
        this.createdAt = createdAt;
    }

    public Municipality(String name, String district, String province, String status) {
        this.name = name;
        this.district = district;
        this.province = province;
        this.status = status;
    }

    public Municipality(String name, String district, String province) {
        this.name = name;
        this.district = district;
        this.province = province;
    }
}
