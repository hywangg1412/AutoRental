package Model;

public class Location {
    private String pickuplocation;
    private String returnLocation;

    public Location() {
    }

    public Location(String pickuplocation, String returnLocation) {
        this.pickuplocation = pickuplocation;
        this.returnLocation = returnLocation;
    }

    public String getPickuplocation() {
        return pickuplocation;
    }

    public void setPickuplocation(String pickuplocation) {
        this.pickuplocation = pickuplocation;
    }

    public String getReturnLocation() {
        return returnLocation;
    }

    public void setReturnLocation(String returnLocation) {
        this.returnLocation = returnLocation;
    }

    @Override
    public String toString() {
        return "Location{" + "pickuplocation=" + pickuplocation + ", returnLocation=" + returnLocation + '}';
    }
    
}
