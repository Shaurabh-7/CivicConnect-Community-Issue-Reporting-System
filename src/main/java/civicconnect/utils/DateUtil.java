package civicconnect.utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Helper class for handling and formatting dates and times in the application.
 */
public class DateUtil {

    private static final DateTimeFormatter STANDARD_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    /**
     * Gets the current system date and time.
     *
     * @return A LocalDateTime object representing the current moment.
     */
    public static LocalDateTime now() {
        return LocalDateTime.now();
    }

    /**
     * Calculates the date and time from a certain number of days ago.
     * Used mainly for searching complaints within the last 7 days.
     *
     * @param days The number of days to subtract from today.
     * @return A LocalDateTime object representing that past date.
     */
    public static LocalDateTime daysAgo(int days) {
        return LocalDateTime.now().minusDays(days);
    }

    /**
     * Formats a LocalDateTime object into a standard string ("YYYY-MM-DD HH:MM:SS").
     *
     * @param dateTime The date time object to format.
     * @return The formatted date string, or an empty string if the input is null.
     */
    public static String format(LocalDateTime dateTime) {
        if (dateTime == null) return "";
        return dateTime.format(STANDARD_FORMAT);
    }
}
