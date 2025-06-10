package Model.Entity.Car;

import java.util.UUID;

public class TransmissionType {
    private UUID tranmissionTypeId;
    private String tranmissionName;

    public TransmissionType() {
    }

    public TransmissionType(UUID tranmissionTypeId, String tranmissionName) {
        this.tranmissionTypeId = tranmissionTypeId;
        this.tranmissionName = tranmissionName;
    }

    public UUID getTranmissionTypeId() {
        return tranmissionTypeId;
    }

    public void setTranmissionTypeId(UUID tranmissionTypeId) {
        this.tranmissionTypeId = tranmissionTypeId;
    }

    public String getTranmissionName() {
        return tranmissionName;
    }

    public void setTranmissionName(String tranmissionName) {
        this.tranmissionName = tranmissionName;
    }

    @Override
    public String toString() {
        return "TranmissionType{" + "tranmissionTypeId=" + tranmissionTypeId + ", tranmissionName=" + tranmissionName + '}';
    }
}
