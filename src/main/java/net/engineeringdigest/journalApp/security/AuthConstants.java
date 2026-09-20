package net.engineeringdigest.journalApp.security;

/** Names shared between the JWT filter and the controllers that read the authenticated user. */
public final class AuthConstants {

    /** Session attribute holding the authenticated {@link net.engineeringdigest.journalApp.entity.User}. */
    public static final String SESSION_USER = "user";

    private AuthConstants() {
    }
}