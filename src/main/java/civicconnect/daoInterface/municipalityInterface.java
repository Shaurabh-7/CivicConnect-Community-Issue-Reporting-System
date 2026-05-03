package civicconnect.daoInterface;

import civicconnect.model.Municipality;
import java.util.ArrayList;

public interface municipalityInterface {
    // Basic CRUD
    boolean addMunicipality(Municipality municipality);
    boolean updateMunicipality(Municipality municipality);
    Municipality getMunicipalityById(int id);
    ArrayList<Municipality> getAllMunicipalities();
    ArrayList<Municipality> getActiveMunicipalities(); // Used for Registration dropdown
    boolean updateMunicipalityStatus(int id, String status); // Activate/Deactivate

}
