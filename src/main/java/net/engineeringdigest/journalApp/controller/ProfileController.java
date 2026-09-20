package net.engineeringdigest.journalApp.controller;

import net.engineeringdigest.journalApp.entity.User;
import net.engineeringdigest.journalApp.security.AuthConstants;
import net.engineeringdigest.journalApp.Service.ProfileImageService;
import net.engineeringdigest.journalApp.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.support.MissingServletRequestPartException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/user")
public class ProfileController {

    @Autowired
    private UserService userService;

    @Autowired
    private ProfileImageService profileImageService;

    // GET /api/user/profile - Get user profile
    @GetMapping("/profile")
    public ResponseEntity<Map<String, Object>> getProfile(HttpSession session) {
        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);

        if (user == null) {
            return ResponseEntity.status(401).body(Map.of("error", "Not authenticated"));
        }

        // Get fresh user from database
        User freshUser = userService.findById(user.getId());

        Map<String, Object> profile = new HashMap<>();
        profile.put("id", freshUser.getId());
        profile.put("username", freshUser.getUsername());
        profile.put("fullName", freshUser.getFullName());
        profile.put("email", freshUser.getEmail());
        profile.put("bio", freshUser.getBio());
        profile.put("profileImage", freshUser.getProfileImage());
        profile.put("profileImageUrl", profileImageUrl(freshUser.getProfileImage()));
        profile.put("darkTheme", freshUser.isDarkTheme());
        profile.put("language", freshUser.getLanguage());

        return ResponseEntity.ok(profile);
    }

    // POST /api/user/photo - Upload or replace the profile photo
    @PostMapping("/photo")
    public ResponseEntity<Map<String, Object>> uploadPhoto(
            @RequestParam("file") MultipartFile file,
            HttpSession session) {

        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        Map<String, Object> response = new HashMap<>();

        if (user == null) {
            response.put("success", false);
            response.put("message", "Not authenticated");
            return ResponseEntity.status(401).body(response);
        }

        try {
            User freshUser = userService.findById(user.getId());
            profileImageService.store(freshUser, file);
            userService.updateUser(freshUser);
            session.setAttribute(AuthConstants.SESSION_USER, freshUser);

            response.put("success", true);
            response.put("message", "Profile photo updated");
            response.put("profileImage", freshUser.getProfileImage());
            response.put("profileImageUrl", profileImageUrl(freshUser.getProfileImage()));
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            // Bad input from the user, not a server fault
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to save the photo");
            return ResponseEntity.status(500).body(response);
        }
    }

    // DELETE /api/user/photo - Remove the profile photo
    @DeleteMapping("/photo")
    public ResponseEntity<Map<String, Object>> deletePhoto(HttpSession session) {
        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        Map<String, Object> response = new HashMap<>();

        if (user == null) {
            response.put("success", false);
            response.put("message", "Not authenticated");
            return ResponseEntity.status(401).body(response);
        }

        try {
            User freshUser = userService.findById(user.getId());
            profileImageService.remove(freshUser);
            userService.updateUser(freshUser);
            session.setAttribute(AuthConstants.SESSION_USER, freshUser);

            response.put("success", true);
            response.put("message", "Profile photo removed");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to remove the photo");
            return ResponseEntity.status(500).body(response);
        }
    }

    private static String profileImageUrl(String filename) {
        return filename == null || filename.isBlank() ? null : "/uploads/" + filename;
    }

    /**
     * The multipart resolver rejects an oversized upload or a request with no file
     * part before any controller method runs, so these cannot be caught in the
     * handler itself. Mapping them to 400 keeps a bad upload a client error rather
     * than a 500, and gives the caller a message it can display.
     */
    @ExceptionHandler({MaxUploadSizeExceededException.class, MultipartException.class,
            MissingServletRequestPartException.class})
    public ResponseEntity<Map<String, Object>> handleBadUpload(Exception e) {
        String message;
        if (e instanceof MaxUploadSizeExceededException) {
            message = "Image is too large. Maximum size is 5 MB.";
        } else {
            message = "Please choose an image to upload.";
        }
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        return ResponseEntity.badRequest().body(response);
    }

    // PUT /api/user/profile - Update user profile
    @PutMapping("/profile")
    public ResponseEntity<Map<String, Object>> updateProfile(
            @RequestBody Map<String, String> profileData,
            HttpSession session) {

        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        Map<String, Object> response = new HashMap<>();

        if (user == null) {
            response.put("success", false);
            response.put("message", "Not authenticated");
            return ResponseEntity.status(401).body(response);
        }

        try {
            user.setFullName(profileData.get("fullName"));
            user.setEmail(profileData.get("email"));
            user.setBio(profileData.get("bio"));

            userService.updateUser(user);

            response.put("success", true);
            response.put("message", "Profile updated successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to update profile: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    // PUT /api/user/password - Change password
    @PutMapping("/password")
    public ResponseEntity<Map<String, Object>> changePassword(
            @RequestBody Map<String, String> passwordData,
            HttpSession session) {

        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        Map<String, Object> response = new HashMap<>();

        if (user == null) {
            response.put("success", false);
            response.put("message", "Not authenticated");
            return ResponseEntity.status(401).body(response);
        }

        String currentPassword = passwordData.get("currentPassword");
        String newPassword = passwordData.get("newPassword");

        // Verify current password
        User freshUser = userService.findById(user.getId());
        if (!freshUser.getPassword().equals(currentPassword)) {
            response.put("success", false);
            response.put("message", "Current password is incorrect");
            return ResponseEntity.status(400).body(response);
        }

        try {
            freshUser.setPassword(newPassword);
            userService.updateUser(freshUser);

            response.put("success", true);
            response.put("message", "Password updated successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to update password");
            return ResponseEntity.status(500).body(response);
        }
    }

    // PUT /api/user/preferences - Update preferences
    @PutMapping("/preferences")
    public ResponseEntity<Map<String, Object>> updatePreferences(
            @RequestBody Map<String, Object> prefs,
            HttpSession session) {

        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        Map<String, Object> response = new HashMap<>();

        if (user == null) {
            response.put("success", false);
            response.put("message", "Not authenticated");
            return ResponseEntity.status(401).body(response);
        }

        try {
            User freshUser = userService.findById(user.getId());

            if (prefs.containsKey("darkTheme")) {
                freshUser.setDarkTheme((Boolean) prefs.get("darkTheme"));
            }
            if (prefs.containsKey("language")) {
                freshUser.setLanguage((String) prefs.get("language"));
            }

            userService.updateUser(freshUser);

            response.put("success", true);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to update preferences");
            return ResponseEntity.status(500).body(response);
        }
    }

    // DELETE /api/user - Delete account
    @DeleteMapping
    public ResponseEntity<Map<String, Object>> deleteAccount(HttpSession session) {
        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        Map<String, Object> response = new HashMap<>();

        if (user == null) {
            response.put("success", false);
            response.put("message", "Not authenticated");
            return ResponseEntity.status(401).body(response);
        }

        try {
            userService.deleteUser(user.getId());
            session.invalidate();

            response.put("success", true);
            response.put("message", "Account deleted successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to delete account");
            return ResponseEntity.status(500).body(response);
        }
    }
}