package Model.Entity.Contract;

import java.time.LocalDate;
import java.util.UUID;

public class ContractDocument {
    private UUID documentId;
    private UUID contractId;
    private String driverLicenseImageUrl;
    private String driverLicenseNumber;
    private String citizenIdFrontImageUrl;
    private String citizenIdBackImageUrl;
    private String citizenIdNumber;
    private LocalDate citizenIdIssuedDate;
    private String citizenIdIssuedPlace;
    private String driverLicenseImageHash;
    private String citizenIdFrontImageHash;
    private String citizenIdBackImageHash;

    public ContractDocument() {}

    public ContractDocument(UUID documentId, UUID contractId, String driverLicenseImageUrl, String driverLicenseNumber, String citizenIdFrontImageUrl, String citizenIdBackImageUrl, String citizenIdNumber, LocalDate citizenIdIssuedDate, String citizenIdIssuedPlace, String driverLicenseImageHash, String citizenIdFrontImageHash, String citizenIdBackImageHash) {
        this.documentId = documentId;
        this.contractId = contractId;
        this.driverLicenseImageUrl = driverLicenseImageUrl;
        this.driverLicenseNumber = driverLicenseNumber;
        this.citizenIdFrontImageUrl = citizenIdFrontImageUrl;
        this.citizenIdBackImageUrl = citizenIdBackImageUrl;
        this.citizenIdNumber = citizenIdNumber;
        this.citizenIdIssuedDate = citizenIdIssuedDate;
        this.citizenIdIssuedPlace = citizenIdIssuedPlace;
        this.driverLicenseImageHash = driverLicenseImageHash;
        this.citizenIdFrontImageHash = citizenIdFrontImageHash;
        this.citizenIdBackImageHash = citizenIdBackImageHash;
    }

    public UUID getDocumentId() {
        return documentId;
    }

    public void setDocumentId(UUID documentId) {
        this.documentId = documentId;
    }

    public UUID getContractId() {
        return contractId;
    }

    public void setContractId(UUID contractId) {
        this.contractId = contractId;
    }

    public String getDriverLicenseImageUrl() {
        return driverLicenseImageUrl;
    }

    public void setDriverLicenseImageUrl(String driverLicenseImageUrl) {
        this.driverLicenseImageUrl = driverLicenseImageUrl;
    }

    public String getDriverLicenseNumber() {
        return driverLicenseNumber;
    }

    public void setDriverLicenseNumber(String driverLicenseNumber) {
        this.driverLicenseNumber = driverLicenseNumber;
    }

    public String getCitizenIdFrontImageUrl() {
        return citizenIdFrontImageUrl;
    }

    public void setCitizenIdFrontImageUrl(String citizenIdFrontImageUrl) {
        this.citizenIdFrontImageUrl = citizenIdFrontImageUrl;
    }

    public String getCitizenIdBackImageUrl() {
        return citizenIdBackImageUrl;
    }

    public void setCitizenIdBackImageUrl(String citizenIdBackImageUrl) {
        this.citizenIdBackImageUrl = citizenIdBackImageUrl;
    }

    public String getCitizenIdNumber() {
        return citizenIdNumber;
    }

    public void setCitizenIdNumber(String citizenIdNumber) {
        this.citizenIdNumber = citizenIdNumber;
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

    public String getDriverLicenseImageHash() {
        return driverLicenseImageHash;
    }

    public void setDriverLicenseImageHash(String driverLicenseImageHash) {
        this.driverLicenseImageHash = driverLicenseImageHash;
    }

    public String getCitizenIdFrontImageHash() {
        return citizenIdFrontImageHash;
    }

    public void setCitizenIdFrontImageHash(String citizenIdFrontImageHash) {
        this.citizenIdFrontImageHash = citizenIdFrontImageHash;
    }

    public String getCitizenIdBackImageHash() {
        return citizenIdBackImageHash;
    }

    public void setCitizenIdBackImageHash(String citizenIdBackImageHash) {
        this.citizenIdBackImageHash = citizenIdBackImageHash;
    }
    
   
}
