package civicconnect.utils;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

/**
 * Helper class to save uploaded files (like complaint evidence images) to the server disk.
 */
public class FileUploadUtil {

    /**
     * Saves an uploaded image file on the server's disk storage and returns its relative file path.
     * It generates a random unique name for each image to prevent overwriting older files.
     * It also mirrors the file to the project's source directory in development so uploads are not lost during server restarts.
     *
     * @param filePart       The file data container from the HTTP request.
     * @param appRealPath    The absolute real directory path of the running web application on the server.
     * @param uploadDirName  The relative directory folder name where files should be stored (e.g., "uploads/complaints").
     * @return The relative web path to the saved file (e.g., "uploads/complaints/random-uuid.jpg"), or null if no file was uploaded.
     * @throws IOException If there is an error writing the file to disk.
     */
    public static String saveImage(Part filePart, String appRealPath, String uploadDirName) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String submittedFileName = filePart.getSubmittedFileName();
        if (submittedFileName == null || submittedFileName.trim().isEmpty()) {
            return null;
        }

        String uploadPath = appRealPath + File.separator + uploadDirName;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        String extension = "";
        int dotIndex = submittedFileName.lastIndexOf('.');
        if (dotIndex > 0) {
            extension = submittedFileName.substring(dotIndex);
        }
        String uniqueFileName = UUID.randomUUID().toString() + extension;

        String absoluteFilePath = uploadPath + File.separator + uniqueFileName;
        filePart.write(absoluteFilePath);

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
        }

        return uploadDirName + "/" + uniqueFileName;
    }
}
