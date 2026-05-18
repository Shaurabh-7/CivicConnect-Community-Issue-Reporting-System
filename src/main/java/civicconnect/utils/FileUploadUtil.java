package civicconnect.utils;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

public class FileUploadUtil {

    /**
     * Saves an uploaded file part to a specified directory and returns the relative path.
     *
     * @param filePart       The file part from the HTTP request
     * @param appRealPath    The real path of the web application (from ServletContext)
     * @param uploadDirName  The relative directory name to store the file (e.g., "uploads/complaints")
     * @return The relative path to the saved file (e.g., "uploads/complaints/xyz123.jpg"), or null if no file was uploaded
     * @throws IOException If a file writing error occurs
     */
    public static String saveImage(Part filePart, String appRealPath, String uploadDirName) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null; // No file uploaded
        }

        String submittedFileName = filePart.getSubmittedFileName();
        if (submittedFileName == null || submittedFileName.trim().isEmpty()) {
            return null;
        }

        // Create the absolute directory path
        String uploadPath = appRealPath + File.separator + uploadDirName;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); // Create directory if it doesn't exist
        }

        // Generate a unique file name to prevent overwriting
        String extension = "";
        int dotIndex = submittedFileName.lastIndexOf('.');
        if (dotIndex > 0) {
            extension = submittedFileName.substring(dotIndex);
        }
        String uniqueFileName = UUID.randomUUID().toString() + extension;

        // Save the file
        String absoluteFilePath = uploadPath + File.separator + uniqueFileName;
        filePart.write(absoluteFilePath);

        // Return relative path for database storage
        return uploadDirName + "/" + uniqueFileName;
    }
}
