package net.engineeringdigest.journalApp.controller;

import net.engineeringdigest.journalApp.entity.JournalEntry;
import net.engineeringdigest.journalApp.entity.User;
import net.engineeringdigest.journalApp.security.AuthConstants;
import net.engineeringdigest.journalApp.Service.JournalEntryService;
import net.engineeringdigest.journalApp.Service.ProfileImageService;
import net.engineeringdigest.journalApp.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.multipart.support.MissingServletRequestPartException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class PageController {

    @Autowired
    private JournalEntryService journalEntryService;

    @Autowired
    private UserService userService;

    @Autowired
    private ProfileImageService profileImageService;

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {

        // ❌ Not logged in
        if (session.getAttribute(AuthConstants.SESSION_USER) == null) {
            return "redirect:/login";
        }

        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        List<JournalEntry> entries = journalEntryService.getJournalEntriesByUser(user.getId());
        model.addAttribute("entries", entries);

        return "dashboard";   // dashboard.jsp
    }

    // Kept so old bookmarks and links keep working
    @GetMapping("/home")
    public String home(HttpSession session) {

        if (session.getAttribute(AuthConstants.SESSION_USER) == null) {
            return "redirect:/login";
        }

        return "redirect:/dashboard";
    }

    // Create new journal entry (JSP form)
    @PostMapping("/journal/create")
    public String createEntry(@RequestParam String title,
                              @RequestParam String content,
                              HttpSession session,
                              Model model) {
        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        JournalEntry entry = new JournalEntry();
        entry.setTitle(title);
        entry.setContent(content);
        entry.setUser(user);

        journalEntryService.saveEntry(entry);

        return "redirect:/dashboard";
    }

    // Delete journal entry (JSP form)
    @PostMapping("/journal/delete/{id}")
    public String deleteEntry(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        JournalEntry entry = journalEntryService.getById(id);
        if (entry != null && entry.getUser() != null
                && entry.getUser().getId().equals(user.getId())) {
            journalEntryService.delete(id);
        }

        return "redirect:/dashboard";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session) {
        if (session.getAttribute(AuthConstants.SESSION_USER) == null) {
            return "redirect:/login";
        }
        return "profile";
    }

    // 👉 PROFILE PHOTO (JSP form)
    @PostMapping("/profile/photo")
    public String uploadProfilePhoto(@RequestParam("file") MultipartFile file,
                                     HttpSession session,
                                     RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        try {
            User freshUser = userService.findById(user.getId());
            profileImageService.store(freshUser, file);
            userService.updateUser(freshUser);
            session.setAttribute(AuthConstants.SESSION_USER, freshUser);
            redirectAttributes.addFlashAttribute("success", "Profile photo updated!");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to save the photo.");
        }

        // Redirect rather than forward so a refresh does not re-upload the file
        return "redirect:/profile";
    }

    /**
     * The multipart resolver rejects an oversized upload or a request with no file
     * part before the handler runs, so those never reach the try/catch above. Send
     * the user back to the page with a message instead of an error page.
     */
    @ExceptionHandler({MaxUploadSizeExceededException.class, MultipartException.class,
            MissingServletRequestPartException.class})
    public String handleBadUpload(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("error",
                "That upload could not be accepted. Use an image under 5 MB.");
        return "redirect:/profile";
    }

    @PostMapping("/profile/photo/delete")
    public String deleteProfilePhoto(HttpSession session,
                                     RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        try {
            User freshUser = userService.findById(user.getId());
            boolean removed = profileImageService.remove(freshUser);
            userService.updateUser(freshUser);
            session.setAttribute(AuthConstants.SESSION_USER, freshUser);
            redirectAttributes.addFlashAttribute("success",
                    removed ? "Profile photo removed!" : "There was no photo to remove.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to remove the photo.");
        }

        return "redirect:/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam String fullName,
                                @RequestParam String email,
                                @RequestParam String bio,
                                HttpSession session,
                                Model model) {
        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        try {
            User freshUser = userService.findById(user.getId());
            freshUser.setFullName(fullName);
            freshUser.setEmail(email);
            freshUser.setBio(bio);
            userService.updateUser(freshUser);
            session.setAttribute(AuthConstants.SESSION_USER, freshUser);
            model.addAttribute("success", "Profile updated successfully!");
        } catch (Exception e) {
            model.addAttribute("error", "Failed to update profile: " + e.getMessage());
        }

        return "profile";
    }

    @PostMapping("/profile/password")
    public String changePassword(@RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 @RequestParam String confirmPassword,
                                 HttpSession session,
                                 Model model) {
        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "New passwords do not match!");
            return "profile";
        }

        try {
            User freshUser = userService.findById(user.getId());
            if (!freshUser.getPassword().equals(currentPassword)) {
                model.addAttribute("error", "Current password is incorrect!");
                return "profile";
            }

            freshUser.setPassword(newPassword);
            userService.updateUser(freshUser);
            model.addAttribute("success", "Password updated successfully!");
        } catch (Exception e) {
            model.addAttribute("error", "Failed to update password!");
        }

        return "profile";
    }

    @GetMapping("/settings")
    public String settings(HttpSession session) {
        if (session.getAttribute(AuthConstants.SESSION_USER) == null) {
            return "redirect:/login";
        }
        return "settings";
    }

    @PostMapping("/settings/theme")
    public String toggleTheme(@RequestParam(required = false) Boolean darkTheme,
                              @RequestParam(required = false, defaultValue = "/settings") String redirectTo,
                              HttpSession session,
                              Model model) {
        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        try {
            User freshUser = userService.findById(user.getId());
            freshUser.setDarkTheme(darkTheme != null && darkTheme);
            userService.updateUser(freshUser);
            session.setAttribute(AuthConstants.SESSION_USER, freshUser);
        } catch (Exception e) {
            model.addAttribute("error", "Failed to update theme");
        }

        // Only ever bounce back to a path on this site
        if (!redirectTo.startsWith("/") || redirectTo.startsWith("//")) {
            redirectTo = "/settings";
        }
        return "redirect:" + redirectTo;
    }

    @PostMapping("/settings/delete")
    public String deleteAccount(HttpSession session) {
        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        if (user == null) {
            return "redirect:/login";
        }

        try {
            userService.deleteUser(user.getId());
            session.invalidate();
        } catch (Exception e) {
            // Handle error
        }

        return "redirect:/";
    }
}