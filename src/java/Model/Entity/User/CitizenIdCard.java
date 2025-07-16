package Model.Entity.User;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;
import java.util.UUID;

public class CitizenIdCard {

    private UUID id;
    private UUID userId;
    private String citizenIdNumber;
    private String fullName;
    private LocalDate dob;
    private String citizenIdImageUrl;
    private String citizenIdBackImageUrl;
    private LocalDate citizenIdIssuedDate;
    private String citizenIdIssuedPlace;
    private LocalDateTime createdDate;

    public CitizenIdCard() {
    }

    public CitizenIdCard(UUID id, UUID userId, String citizenIdNumber, String fullName, LocalDate dob,
            String citizenIdImageUrl, String citizenIdBackImageUrl, LocalDate citizenIdIssuedDate,
            String citizenIdIssuedPlace, LocalDateTime createdDate) {
        this.id = id;
        this.userId = userId;
        this.citizenIdNumber = citizenIdNumber;
        this.fullName = fullName;
        this.dob = dob;
        this.citizenIdImageUrl = citizenIdImageUrl;
        this.citizenIdBackImageUrl = citizenIdBackImageUrl;
        this.citizenIdIssuedDate = citizenIdIssuedDate;
        this.citizenIdIssuedPlace = citizenIdIssuedPlace;
        this.createdDate = createdDate;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public String getCitizenIdNumber() {
        return citizenIdNumber;
    }

    public void setCitizenIdNumber(String citizenIdNumber) {
        this.citizenIdNumber = citizenIdNumber;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public LocalDate getDob() {
        return dob;
    }

    public void setDob(LocalDate dob) {
        this.dob = dob;
    }

    public String getCitizenIdImageUrl() {
        return citizenIdImageUrl;
    }

    public void setCitizenIdImageUrl(String citizenIdImageUrl) {
        this.citizenIdImageUrl = citizenIdImageUrl;
    }

    public String getCitizenIdBackImageUrl() {
        return citizenIdBackImageUrl;
    }

    public void setCitizenIdBackImageUrl(String citizenIdBackImageUrl) {
        this.citizenIdBackImageUrl = citizenIdBackImageUrl;
    }

    public LocalDate getCitizenIdIssuedDate() {
        return citizenIdIssuedDate;
    }

    public void setCitizenIdIssuedDate(LocalDate citizenIdIssuedDate) {
        this.citizenIdIssuedDate = citizenIdIssuedDate;
    }

    public String getCitizenIdIssuedPlace() {
        return citizenIdIssuedPlace;
    }

    public void setCitizenIdIssuedPlace(String citizenIdIssuedPlace) {
        this.citizenIdIssuedPlace = citizenIdIssuedPlace;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    @Override
    public String toString() {
        return "CitizenIdCard{"
                + "id=" + id
                + ", userId=" + userId
                + ", citizenIdNumber='" + citizenIdNumber + '\''
                + ", fullName='" + fullName + '\''
                + ", dob=" + dob
                + ", citizenIdImageUrl='" + citizenIdImageUrl + '\''
                + ", citizenIdBackImageUrl='" + citizenIdBackImageUrl + '\''
                + ", citizenIdIssuedDate=" + citizenIdIssuedDate
                + ", citizenIdIssuedPlace='" + citizenIdIssuedPlace + '\''
                + ", createdDate=" + createdDate
                + '}';
    }
}
