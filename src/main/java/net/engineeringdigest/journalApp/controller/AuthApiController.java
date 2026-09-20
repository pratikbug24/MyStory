package net.engineeringdigest.journalApp.controller;

import net.engineeringdigest.journalApp.entity.User;
import net.engineeringdigest.journalApp.security.AuthConstants;
import net.engineeringdigest.journalApp.security.JwtService;
import net.engineeringdigest.journalApp.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = {"http://localhost:8088", "http://localhost:3000", "http://localhost:8080"})
public class AuthApiController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtService jwtService;

    // POST /api/auth/login
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> credentials, HttpSession session) {
        String username = credentials.get("username");
        String password = credentials.get("password");

        User user = userService.login(username, password);

        Map<String, Object> response = new HashMap<>();

        if (user != null) {
            session.setAttribute(AuthConstants.SESSION_USER, user);
            response.put("success", true);
            response.put("message", "Login successful");
            response.put("username", user.getUsername());

            // The JWT replaces the server-side session as the credential the
            // browser carries; the session attribute above only serves this request.
            String token = jwtService.generateToken(user);
            return ResponseEntity.ok()
                    .header(HttpHeaders.SET_COOKIE, jwtService.createCookie(token).toString())
                    .body(response);
        } else {
            response.put("success", false);
            response.put("message", "Invalid username or password");
            return ResponseEntity.status(401).body(response);
        }
    }

    // POST /api/auth/register
    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@RequestBody Map<String, String> userData) {
        String username = userData.get("username");
        String password = userData.get("password");

        Map<String, Object> response = new HashMap<>();

        // Check if user already exists
        User existingUser = userService.findByUsername(username);
        if (existingUser != null) {
            response.put("success", false);
            response.put("message", "Username already exists");
            return ResponseEntity.status(400).body(response);
        }

        // Create new user
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);

        User savedUser = userService.register(newUser);

        if (savedUser != null) {
            response.put("success", true);
            response.put("message", "Registration successful");
            response.put("username", savedUser.getUsername());
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "Registration failed");
            return ResponseEntity.status(500).body(response);
        }
    }

    // GET /api/auth/check
    @GetMapping("/check")
    public ResponseEntity<Map<String, Object>> checkAuth(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        // Populated by JwtAuthFilter from the JWT on the request.
        User user = (User) session.getAttribute(AuthConstants.SESSION_USER);
        if (user != null) {
            response.put("authenticated", true);
            response.put("username", user.getUsername());
            return ResponseEntity.ok(response);
        } else {
            response.put("authenticated", false);
            return ResponseEntity.status(401).body(response);
        }
    }

    // POST /api/auth/logout
    @PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        session.invalidate();
        response.put("success", true);
        response.put("message", "Logged out successfully");

        // Expire the JWT cookie, otherwise it would keep authenticating the browser.
        return ResponseEntity.ok()
                .header(HttpHeaders.SET_COOKIE, jwtService.clearCookie().toString())
                .body(response);
    }
}