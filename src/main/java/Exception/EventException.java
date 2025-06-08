package Exception;

public class EventException extends Exception{
    public EventException(String message) {
        super(message);
    }

    public EventException(Throwable cause) {
        super(cause);
    }
}
