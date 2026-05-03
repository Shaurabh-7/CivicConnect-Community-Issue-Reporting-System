package civicconnect.daoInterface;

import civicconnect.model.Users;
import civicconnect.dto.user.UserDTO;
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
    ArrayList<Users> getUsersByMunicipality(int municipalityId);
    ArrayList<Users> searchUsers(int municipalityId, String query);

    // Super Admin methods
    int getActiveAdminsCount();
    int getTotalCitizensCount();
    ArrayList<UserDTO> getAllMunicipalityAdmins();
}
