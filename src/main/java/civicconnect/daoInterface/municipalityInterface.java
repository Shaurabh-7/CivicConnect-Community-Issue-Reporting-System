package civicconnect.daoInterface;

import civicconnect.model.Municipality;
import civicconnect.dto.municipality.MunicipalityDTO;
import java.util.ArrayList;

public interface municipalityInterface {
    // Basic CRUD
    boolean addMunicipality(Municipality municipality);
    boolean updateMunicipality(Municipality municipality);
    Municipality getMunicipalityById(int id);
    ArrayList<MunicipalityDTO> getAllMunicipalities();
    ArrayList<Municipality> getActiveMunicipalities(); // Used for Registration dropdown
    boolean updateMunicipalityStatus(int id, String status); // Activate/Deactivate

    // Dashboard & Stats
    int getTotalMunicipalitiesCount();
    ArrayList<MunicipalityDTO> getRecentMunicipalities(int limit);
}
