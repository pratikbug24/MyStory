package net.engineeringdigest.journalApp.security;

import net.engineeringdigest.journalApp.entity.User;
import net.engineeringdigest.journalApp.Service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Establishes the authenticated user for each request from a JWT.
 *
 * <p>The token is read from the JWT cookie (what the browser clients use) or an
 * {@code Authorization: Bearer} header (what API clients use). A valid token
 * populates the same {@code user} session attribute the existing controllers and
 * JSPs already read, so no other code needs to understand JWT. When a token is
 * present but invalid or expired, any previously stored user is cleared so the
 * session cannot outlive the token.
 */
@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    private static final String BEARER_PREFIX = "Bearer ";

    private final JwtService jwtService;
    private final UserService userService;

    @Autowired
    public JwtAuthFilter(JwtService jwtService, UserService userService) {
        this.jwtService = jwtService;
        this.userService = userService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        String token = resolveToken(request);

        if (token != null) {
            String username = jwtService.extractUsername(token);
            User user = username == null ? null : userService.findByUsername(username);

            HttpSession session = request.getSession(false);
            if (user != null) {
                request.setAttribute(AuthConstants.SESSION_USER, user);
                session = request.getSession(true);
                session.setAttribute(AuthConstants.SESSION_USER, user);
            } else if (session != null) {
                session.removeAttribute(AuthConstants.SESSION_USER);
            }
        }

        filterChain.doFilter(request, response);
    }

    private String resolveToken(HttpServletRequest request) {
        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith(BEARER_PREFIX)) {
            return header.substring(BEARER_PREFIX.length()).trim();
        }

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            String cookieName = jwtService.getCookieName();
            for (Cookie cookie : cookies) {
                if (cookieName.equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }

        return null;
    }
}