package Exception;

public class InvalidDataException extends Exception{
    public InvalidDataException(String message) {
        super(message);
    }

    public InvalidDataException(Throwable cause) {
        super(cause);
    }
}
