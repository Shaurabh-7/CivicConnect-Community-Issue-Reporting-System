package civicconnect.utils;

import java.util.regex.Pattern;

/**
 * Helper class to validate input parameters (like names, emails, phone numbers, and passwords).
 */
public class Validator {

    private static final Pattern NAME_PATTERN = Pattern.compile("^[a-zA-Z\\s]{2,}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(97|98)\\d{8}$");
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$");

    /**
     * Checks if a name is valid. It must contain only letters and spaces, and be at least 2 characters long.
     *
     * @param name The name text to validate.
     * @return True if the name is valid, false otherwise.
     */
    public static boolean isValidName(String name) {
        if (name == null) return false;
        return NAME_PATTERN.matcher(name.trim()).matches();
    }

    /**
     * Checks if an email address is valid and has a proper email format.
     *
     * @param email The email text to validate.
     * @return True if the email is valid, false otherwise.
     */
    public static boolean isValidEmail(String email) {
        if (email == null) return false;
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    /**
     * Checks if a phone number is valid. It must start with 97 or 98 and be exactly 10 digits long.
     *
     * @param phone The phone text to validate.
     * @return True if the phone number is valid, false otherwise.
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null) return false;
        return PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    /**
     * Checks if a password is secure. It must be at least 8 characters long and contain at least one lowercase letter, one uppercase letter, and one number.
     *
     * @param password The password text to validate.
     * @return True if secure, false otherwise.
     */
    public static boolean isValidPassword(String password) {
        if (password == null) return false;
        return PASSWORD_PATTERN.matcher(password).matches();
    }

    /**
     * Checks if a string is not empty and not null.
     *
     * @param str The string to check.
     * @return True if it has text content, false if null or blank.
     */
    public static boolean isNotNullOrEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }

    /**
     * Checks if a ward number is valid. It must be a valid number between 1 and 33.
     *
     * @param wardStr The ward string representation to check.
     * @return True if it is a valid ward number, false otherwise.
     */
    public static boolean isValidWardNumber(String wardStr) {
        if (!isNotNullOrEmpty(wardStr)) return false;
        try {
            int ward = Integer.parseInt(wardStr);
            return ward >= 1 && ward <= 33;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
