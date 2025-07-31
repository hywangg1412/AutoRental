package Model.Constants;

/**
 * Constants for Surcharge types and amounts
 */
public class SurchargeConstants {
    
    // Surcharge Types
    public static final String LATE_RETURN = "LateReturn";
    public static final String FUEL_SHORTAGE = "FuelShortage";
    public static final String TRAFFIC_VIOLATIONS = "TrafficViolations";
    public static final String EXCESSIVE_CLEANING = "ExcessiveCleaning";
    public static final String MINOR_DAMAGE = "MinorDamage";
    public static final String EXCESS_MILEAGE = "ExcessMileage";
    
    // Surcharge Categories
    public static final String CATEGORY_PENALTY = "Penalty";
    public static final String CATEGORY_DAMAGE = "Damage";
    public static final String CATEGORY_CLEANING = "Cleaning";
    public static final String CATEGORY_FUEL = "Fuel";
    public static final String CATEGORY_TRAFFIC = "Traffic";
    
    // Fixed Amounts (in VND)
    public static final double LATE_RETURN_RATE_PER_HOUR = 50000.0; // 50,000 VND/hour
    public static final double FUEL_SHORTAGE_FEE = 20000.0; // 20,000 VND + fuel price
    public static final double TRAFFIC_VIOLATIONS_FEE = 100000.0; // 100,000 VND + authority fine
    public static final double EXCESSIVE_CLEANING_FEE = 200000.0; // 200,000 VND
    public static final double MINOR_DAMAGE_MIN = 100000.0; // 100,000 VND
    public static final double MINOR_DAMAGE_MAX = 500000.0; // 500,000 VND
    public static final double EXCESS_MILEAGE_RATE_PER_KM = 5000.0; // 5,000 VND/km
    
    // Surcharge Descriptions
    public static final String LATE_RETURN_DESC = "Late return fee";
    public static final String FUEL_SHORTAGE_DESC = "Fuel shortage fee";
    public static final String TRAFFIC_VIOLATIONS_DESC = "Traffic violation fee";
    public static final String EXCESSIVE_CLEANING_DESC = "Car cleaning fee";
    public static final String MINOR_DAMAGE_DESC = "Minor damage repair fee";
    public static final String EXCESS_MILEAGE_DESC = "Excess mileage fee";
} 