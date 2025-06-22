package Model.Entity.Car;

import java.util.UUID;

public class TransmissionType {
    private UUID transmissionTypeId;
    private String transmissionName;

    public TransmissionType() {
    }

    public TransmissionType(UUID transmissionTypeId, String transmissionName) {
        this.transmissionTypeId = transmissionTypeId;
        this.transmissionName = transmissionName;
    }

    public UUID getTransmissionTypeId() {
        return transmissionTypeId;
    }

    public void setTransmissionTypeId(UUID transmissionTypeId) {
        this.transmissionTypeId = transmissionTypeId;
    }

    public String getTransmissionName() {
        return transmissionName;
    }

    public void setTransmissionName(String transmissionName) {
        this.transmissionName = transmissionName;
    }

    @Override
    public String toString() {
        return "TranmissionType{" + "tranmissionTypeId=" + transmissionTypeId + ", tranmissionName=" + transmissionName + '}';
    }
}
