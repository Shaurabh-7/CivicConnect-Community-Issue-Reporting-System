package civicconnect.utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DateUtil {

    private static final DateTimeFormatter STANDARD_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    /**
     * Get the current date and time.
     * @return LocalDateTime representing now.
     */
    public static LocalDateTime now() {
        return LocalDateTime.now();
    }

    /**
     * Returns the date exactly n days ago.
     * @param days Number of days
     * @return LocalDateTime
     */
    public static LocalDateTime daysAgo(int days) {
        return LocalDateTime.now().minusDays(days);
    }

    /**
     * Formats a LocalDateTime into standard string format.
     * @param dateTime The date time to format
     * @return formatted string
     */
    public static String format(LocalDateTime dateTime) {
        if (dateTime == null) return "";
        return dateTime.format(STANDARD_FORMAT);
    }
}
