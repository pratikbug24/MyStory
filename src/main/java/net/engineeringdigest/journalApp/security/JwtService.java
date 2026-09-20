package net.engineeringdigest.journalApp.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import net.engineeringdigest.journalApp.entity.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseCookie;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.security.MessageDigest;
import java.time.Duration;
import java.util.Date;

/**
 * Issues and verifies the JWTs that back user sessions.
 *
 * <p>Tokens are signed with HS256 using {@code jwt.secret}. A token carries the
 * username as its subject and the user id as a custom claim; nothing else about
 * the user is embedded, so a token can never go stale against the database.
 */
@Component
public class JwtService {

    private final Key signingKey;
    private final long expirationMs;
    private final String cookieName;
    private final boolean cookieSecure;

    public JwtService(@Value("${jwt.secret}") String secret,
                      @Value("${jwt.expiration-ms}") long expirationMs,
                      @Value("${jwt.cookie-name:journal_jwt}") String cookieName,
                      @Value("${jwt.cookie-secure:false}") boolean cookieSecure) {
        this.signingKey = buildKey(secret);
        this.expirationMs = expirationMs;
        this.cookieName = cookieName;
        this.cookieSecure = cookieSecure;
    }

    /**
     * HMAC-SHA256 needs at least 256 bits of key material. A shorter configured
     * secret is stretched with SHA-256 rather than rejected, so a weak dev value
     * still produces a usable key instead of failing at startup.
     */
    private static Key buildKey(String secret) {
        byte[] raw = secret.getBytes(StandardCharsets.UTF_8);
        if (raw.length < 32) {
            try {
                raw = MessageDigest.getInstance("SHA-256").digest(raw);
            } catch (Exception e) {
                throw new IllegalStateException("Unable to derive JWT signing key", e);
            }
        }
        return Keys.hmacShaKeyFor(raw);
    }

    public String generateToken(User user) {
        Date now = new Date();
        return Jwts.builder()
                .setSubject(user.getUsername())
                .claim("uid", user.getId())
                .setIssuedAt(now)
                .setExpiration(new Date(now.getTime() + expirationMs))
                .signWith(signingKey, SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * @return the username carried by a valid, unexpired, correctly signed token,
     *         or {@code null} if the token is missing, malformed, expired, or forged.
     */
    public String extractUsername(String token) {
        if (token == null || token.isBlank()) {
            return null;
        }
        try {
            Jws<Claims> claims = Jwts.parserBuilder()
                    .setSigningKey(signingKey)
                    .build()
                    .parseClaimsJws(token);
            return claims.getBody().getSubject();
        } catch (Exception e) {
            return null;
        }
    }

    public String getCookieName() {
        return cookieName;
    }

    /** HttpOnly so scripts cannot read it; Lax still allows top-level navigation. */
    public ResponseCookie createCookie(String token) {
        return ResponseCookie.from(cookieName, token)
                .httpOnly(true)
                .secure(cookieSecure)
                .path("/")
                .sameSite("Lax")
                .maxAge(Duration.ofMillis(expirationMs))
                .build();
    }

    /** Same attributes as {@link #createCookie} but with an immediate expiry, so the browser drops it. */
    public ResponseCookie clearCookie() {
        return ResponseCookie.from(cookieName, "")
                .httpOnly(true)
                .secure(cookieSecure)
                .path("/")
                .sameSite("Lax")
                .maxAge(0)
                .build();
    }
}