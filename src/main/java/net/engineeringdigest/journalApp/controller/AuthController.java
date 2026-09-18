package net.engineeringdigest.journalApp.controller;

import net.engineeringdigest.journalApp.entity.User;
import net.engineeringdigest.journalApp.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    // 👉 HOME PAGE / LANDING
    @GetMapping("/")
    public String landingPage(HttpSession session) {
        // The landing page itself decides to show "Go to dashboard" when logged in
        return "home";
    }

    // 👉 LOGIN PAGE
    @GetMapping("/login")
    public String loginPage(HttpSession session) {

        // ✅ If already logged in → go to dashboard
        if (session.getAttribute("user") != null) {
            return "redirect:/dashboard";
        }

        return "login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register(@RequestParam String username,
                           @RequestParam String password,
                           Model model) {

        if (userService.findByUsername(username) != null) {
            model.addAttribute("error", "Username already exists");
            return "register";
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);

        userService.register(user);

        return "redirect:/login";
    }

    // 👉 LOGIN
    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        HttpSession session) {

        User user = userService.login(username, password);

        if (user != null) {
            session.setAttribute("user", user);  // ✅ save session
            return "redirect:/dashboard";
        } else {
            return "login";
        }
    }

    // 👉 LOGOUT
    @GetMapping("/logout")
    public String logout(HttpSession session) {

        session.invalidate();   // ✅ destroy session

        return "redirect:/";
    }
}