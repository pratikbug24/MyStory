package net.engineeringdigest.journalApp.Service;

import net.engineeringdigest.journalApp.entity.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.UUID;

/**
 * Stores user profile photos on disk and keeps {@link User#getProfileImage()} in sync.
 *
 * <p>Anything a user uploads is treated as hostile: the declared content type and
 * filename are ignored, the bytes must decode as a real raster image, the result is
 * re-encoded to a fresh PNG (which strips any embedded payload such as a script in
 * an otherwise valid image), and the stored name is a random UUID. That makes it
 * impossible to land an attacker-controlled filename or an executable file in the
 * served directory.
 */
@Service
public class ProfileImageService {

    private static final long MAX_BYTES = 5L * 1024 * 1024;
    private static final int MAX_DIMENSION = 512;

    private final Path uploadDir;

    public ProfileImageService(@Value("${app.upload-dir:uploads}") String uploadDir) {
        this.uploadDir = Paths.get(uploadDir).toAbsolutePath().normalize();
    }

    public Path getUploadDir() {
        return uploadDir;
    }

    /**
     * Validates, downscales and stores the image, then points the user at it.
     *
     * @return the new stored filename, so the caller can persist the user.
     * @throws IllegalArgumentException if the upload is empty, too large, or not a decodable image.
     * @throws IOException if the file cannot be written.
     */
    public String store(User user, MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Please choose an image to upload.");
        }
        if (file.getSize() > MAX_BYTES) {
            throw new IllegalArgumentException("Image is too large. Maximum size is 5 MB.");
        }

        BufferedImage decoded = decode(file.getBytes());
        if (decoded == null) {
            throw new IllegalArgumentException("That file is not a valid image.");
        }

        BufferedImage normalized = normalize(decoded);
        Files.createDirectories(uploadDir);

        String filename = UUID.randomUUID().toString().replace("-", "") + ".png";
        Path target = uploadDir.resolve(filename).normalize();
        // The generated name cannot escape, but never write outside the directory.
        if (!target.startsWith(uploadDir)) {
            throw new IllegalStateException("Refusing to write outside the upload directory");
        }

        if (!ImageIO.write(normalized, "png", target.toFile())) {
            throw new IOException("Failed to write image");
        }

        String previous = user.getProfileImage();
        user.setProfileImage(filename);
        deleteQuietly(previous);

        return filename;
    }

    /**
     * Removes the user's current photo from disk and clears the field.
     *
     * @return true if a photo was present and removed.
     */
    public boolean remove(User user) {
        String current = user.getProfileImage();
        if (current == null || current.isBlank()) {
            user.setProfileImage(null);
            return false;
        }
        user.setProfileImage(null);
        deleteQuietly(current);
        return true;
    }

    /**
     * Decodes bytes into an image, returning {@code null} for anything that is not a
     * readable raster format. This is the real content check — the extension and the
     * client-supplied content type are never trusted.
     */
    private BufferedImage decode(byte[] bytes) {
        try {
            return ImageIO.read(new ByteArrayInputStream(bytes));
        } catch (IOException e) {
            return null;
        }
    }

    /**
     * Re-encodes into a known-good {@code TYPE_INT_RGB} image, shrinking to fit
     * {@link #MAX_DIMENSION}. Copying every pixel through a fresh buffer is what
     * strips any appended or embedded payload.
     */
    private BufferedImage normalize(BufferedImage source) {
        int width = source.getWidth();
        int height = source.getHeight();

        double scale = Math.min(1.0, (double) MAX_DIMENSION / Math.max(width, height));
        int targetWidth = Math.max(1, (int) Math.round(width * scale));
        int targetHeight = Math.max(1, (int) Math.round(height * scale));

        BufferedImage result = new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = result.createGraphics();
        try {
            graphics.setRenderingHint(RenderingHints.KEY_INTERPOLATION,
                    RenderingHints.VALUE_INTERPOLATION_BILINEAR);
            graphics.setRenderingHint(RenderingHints.KEY_RENDERING,
                    RenderingHints.VALUE_RENDER_QUALITY);
            graphics.drawImage(source, 0, 0, targetWidth, targetHeight, null);
        } finally {
            graphics.dispose();
        }
        return result;
    }

    /**
     * Deletes a previously stored file, ignoring failures so a missing file never
     * blocks an upload. The name is reduced to its base component and resolved
     * against the upload directory, so a corrupted or tampered stored value cannot
     * delete a file elsewhere on the system.
     */
    private void deleteQuietly(String filename) {
        if (filename == null || filename.isBlank()) {
            return;
        }
        try {
            String base = Paths.get(filename).getFileName().toString();
            if (base.isEmpty() || base.equals(".") || base.equals("..")) {
                return;
            }
            Path target = uploadDir.resolve(base).normalize();
            if (!target.startsWith(uploadDir)) {
                return;
            }
            Files.deleteIfExists(target);
        } catch (IOException | RuntimeException ignored) {
            // A leftover file is harmless; surfacing it would fail an otherwise good save.
        }
    }

    /** True when the stored name looks like something this service could have produced. */
    public boolean isManagedFilename(String filename) {
        return filename != null && filename.toLowerCase(Locale.ROOT).matches("[0-9a-f]{32}\\.png");
    }
}