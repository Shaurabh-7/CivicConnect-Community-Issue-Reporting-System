package civicconnect.daoInterface;

import civicconnect.model.Users;
import java.util.ArrayList;

public interface userInterface {
    boolean registerUser(Users user);
    Users getUserByEmail(String email);
    Users getUserById(int id);
    boolean updateUserProfile(Users user);
    boolean changePassword(int userId, String newPasswordHash);
    ArrayList<Users> getAllUsers();
    ArrayList<Users> getUsersByRole(String role);
    boolean updateUserStatus(int userId, String status);
}
