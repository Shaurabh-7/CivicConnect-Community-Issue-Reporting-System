package civicconnect.utils;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Handles secure password encryption and matching using BCrypt.
 */
public class PasswordUtil {

    private static final int WORK_FACTOR = 12;

    /**
     * Secures a plain-text password by encrypting it with BCrypt.
     *
     * @param plainTextPassword The raw password entered by the user.
     * @return The encrypted (hashed) password string.
     * @throws IllegalArgumentException If the given password is empty or null.
     */
    public static String hashPassword(String plainTextPassword) {
        if (plainTextPassword == null || plainTextPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be empty");
        }
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt(WORK_FACTOR));
    }

    /**
     * Compares a raw plain-text password against an encrypted password stored in the database.
     * Used mainly during login to check if the password is correct.
     *
     * @param plainTextPassword The raw password entered by the user in the login form.
     * @param storedHash        The encrypted password stored in the database.
     * @return True if they match perfectly, false otherwise.
     */
    public static boolean checkPassword(String plainTextPassword, String storedHash) {
        if (plainTextPassword == null || storedHash == null || storedHash.isEmpty()) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainTextPassword, storedHash);
        } catch (IllegalArgumentException e) {
            return false;
        }
    }
}
