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

        // Save the file to deployed folder
        String absoluteFilePath = uploadPath + File.separator + uniqueFileName;
        filePart.write(absoluteFilePath);

        // Also save to source directory in development so it survives restarts/wipes
        try {
            String sourceRealPath = appRealPath.replace("target" + File.separator + "CivicConnect-1.0-SNAPSHOT", "src" + File.separator + "main" + File.separator + "webapp");
            sourceRealPath = sourceRealPath.replace("target" + File.separator + "classes", "src" + File.separator + "main" + File.separator + "webapp");
            File sourceDir = new File(sourceRealPath + File.separator + uploadDirName);
            if (sourceDir.getParentFile().exists()) {
                if (!sourceDir.exists()) {
                    sourceDir.mkdirs();
                }
                File sourceFile = new File(sourceDir, uniqueFileName);
                java.nio.file.Files.copy(
                    new File(absoluteFilePath).toPath(),
                    sourceFile.toPath(),
                    java.nio.file.StandardCopyOption.REPLACE_EXISTING
                );
            }
        } catch (Exception ignored) {
            // Ignore if we can't write to source path
        }

        // Return relative path for database storage
        return uploadDirName + "/" + uniqueFileName;
    }
}
