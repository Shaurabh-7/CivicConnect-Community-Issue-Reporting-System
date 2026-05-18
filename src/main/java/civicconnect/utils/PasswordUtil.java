package civicconnect.utils;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    private static final int WORK_FACTOR = 12;

    /**
     * Hashes a plaintext password using BCrypt with a salt.
     *
     * @param plainTextPassword The plaintext password
     * @return The BCrypt hashed password
     */
    public static String hashPassword(String plainTextPassword) {
        if (plainTextPassword == null || plainTextPassword.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be empty");
        }
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt(WORK_FACTOR));
    }

    /**
     * Checks if a plaintext password matches a stored BCrypt hash.
     *
     * @param plainTextPassword The plaintext password entered by the user
     * @param storedHash        The BCrypt hash stored in the database
     * @return true if the passwords match, false otherwise
     */
    public static boolean checkPassword(String plainTextPassword, String storedHash) {
        if (plainTextPassword == null || storedHash == null || storedHash.isEmpty()) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainTextPassword, storedHash);
        } catch (IllegalArgumentException e) {
            // This happens if storedHash is not a valid BCrypt hash
            return false;
        }
    }
}
