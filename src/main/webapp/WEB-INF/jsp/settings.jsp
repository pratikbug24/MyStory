<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settings · Daybook</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,400;9..144,600;9..144,700&family=Karla:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/settings.css">
</head>
<body class="${sessionScope.user.darkTheme ? 'dark-theme' : ''}">

<header class="st-top">
    <a class="st-brand" href="/">
        <img class="st-brand-logo" src="/images/logo.png" alt="" width="38" height="38">
        <span class="st-brand-name">MyStory</span>
    </a>

    <div class="st-top-actions">
        <button class="st-icon-btn st-theme-toggle" type="button" onclick="toggleTheme()"
                title="Toggle theme" aria-label="Toggle dark theme">
            <svg class="sun-icon" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zM2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1zm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1zM11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1zm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1zM5.99 4.58c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0s.39-1.03 0-1.41L5.99 4.58zm12.37 12.37c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0 .39-.39.39-1.03 0-1.41l-1.06-1.06zm1.06-10.96c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06zM7.05 18.36c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06z"/>
            </svg>
            <svg class="moon-icon" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M12 3c-4.97 0-9 4.03-9 9s4.03 9 9 9 9-4.03 9-9c0-.46-.04-.92-.1-1.36-.98 1.37-2.58 2.26-4.4 2.26-2.98 0-5.4-2.42-5.4-5.4 0-1.81.89-3.42 2.26-4.4-.44-.06-.9-.1-1.36-.1z"/>
            </svg>
        </button>

        <a class="st-icon-btn" href="/dashboard" title="Dashboard" aria-label="Dashboard">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
            </svg>
        </a>

        <a class="st-icon-btn" href="/profile" title="Profile" aria-label="Profile">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
            </svg>
        </a>

        <a class="st-logout" href="/logout">Log out</a>
    </div>
</header>

<main class="st-wrap">

    <div class="st-head">
        <p class="st-eyebrow">Your account</p>
        <h1 class="st-title">Settings</h1>
        <p class="st-lede">Adjust how your journal looks and behaves.</p>
    </div>

    <c:if test="${not empty success}">
        <div class="st-alert st-alert-success" role="status">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M9 16.17 4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
            </svg>
            <span><c:out value="${success}"/></span>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="st-alert st-alert-error" role="alert">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/>
            </svg>
            <span><c:out value="${error}"/></span>
        </div>
    </c:if>

    <section class="st-card">
        <div class="st-card-head">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M12 3a9 9 0 0 0 0 18c.83 0 1.5-.67 1.5-1.5 0-.39-.15-.74-.39-1-.24-.27-.39-.62-.39-1 0-.83.67-1.5 1.5-1.5H16a5 5 0 0 0 5-5c0-4.42-4.03-8-9-8zm-5.5 9c-.83 0-1.5-.67-1.5-1.5S5.67 9 6.5 9 8 9.67 8 10.5 7.33 12 6.5 12zm3-4C8.67 8 8 7.33 8 6.5S8.67 5 9.5 5s1.5.67 1.5 1.5S10.33 8 9.5 8zm5 0c-.83 0-1.5-.67-1.5-1.5S13.67 5 14.5 5s1.5.67 1.5 1.5S15.33 8 14.5 8zm3 4c-.83 0-1.5-.67-1.5-1.5S16.67 9 17.5 9s1.5.67 1.5 1.5-.67 1.5-1.5 1.5z"/>
            </svg>
            <h2>Appearance</h2>
        </div>

        <div class="st-row">
            <div>
                <span class="st-row-title">Dark mode</span>
                <p class="st-row-desc">Switch between the light and dark paper themes.</p>
            </div>
            <div class="st-row-control">
                <form action="/settings/theme" method="post">
                    <input type="hidden" name="redirectTo" value="/settings">
                    <label class="st-switch">
                        <input type="checkbox" name="darkTheme" value="true"
                               <c:if test="${sessionScope.user.darkTheme}">checked</c:if>
                               onchange="this.form.submit()">
                        <span class="st-switch-track"><span class="st-switch-thumb"></span></span>
                        <span class="st-sr-only">Enable dark mode</span>
                    </label>
                </form>
            </div>
        </div>
    </section>

    <section class="st-card">
        <div class="st-card-head">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M3.9 12c0-1.71 1.39-3.1 3.1-3.1h4V7H7c-2.76 0-5 2.24-5 5s2.24 5 5 5h4v-1.9H7c-1.71 0-3.1-1.39-3.1-3.1zM8 13h8v-2H8v2zm9-6h-4v1.9h4c1.71 0 3.1 1.39 3.1 3.1s-1.39 3.1-3.1 3.1h-4V17h4c2.76 0 5-2.24 5-5s-2.24-5-5-5z"/>
            </svg>
            <h2>Quick links</h2>
        </div>
        <p class="st-card-note">Jump to the parts of your journal you use most.</p>

        <div class="st-tiles">
            <a class="st-tile" href="/dashboard">
                <span class="st-tile-icon">
                    <svg viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z"/>
                    </svg>
                </span>
                <span class="st-tile-body">
                    <span class="st-tile-title">Journal</span>
                    <span class="st-tile-desc">Write today's entry</span>
                </span>
                <svg class="st-tile-arrow" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M8.59 16.59 13.17 12 8.59 7.41 10 6l6 6-6 6z"/>
                </svg>
            </a>

            <a class="st-tile" href="/profile">
                <span class="st-tile-icon">
                    <svg viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                    </svg>
                </span>
                <span class="st-tile-body">
                    <span class="st-tile-title">Profile</span>
                    <span class="st-tile-desc">Photo, details, password</span>
                </span>
                <svg class="st-tile-arrow" viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M8.59 16.59 13.17 12 8.59 7.41 10 6l6 6-6 6z"/>
                </svg>
            </a>
        </div>
    </section>

    <section class="st-card">
        <div class="st-card-head">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 15c-.55 0-1-.45-1-1v-4c0-.55.45-1 1-1s1 .45 1 1v4c0 .55-.45 1-1 1zm1-8h-2V7h2v2z"/>
            </svg>
            <h2>Account</h2>
        </div>

        <div class="st-row">
            <div>
                <span class="st-row-title">Delete account</span>
                <p class="st-row-desc">Permanently remove your account and every journal entry. This cannot be undone.</p>
            </div>
            <div class="st-row-control">
                <form action="/settings/delete" method="post"
                      onsubmit="return confirm('Delete your account and all journal entries? This cannot be undone.');">
                    <button type="submit" class="st-btn st-btn-danger">
                        <svg viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                        </svg>
                        Delete
                    </button>
                </form>
            </div>
        </div>
    </section>

    <p class="st-foot">MyStory · Version 1.0.0</p>

</main>

<script>
    // Inline because this is the only script the page needs. It posts to the same
    // endpoint the profile and dashboard pages use, so the theme stays a single
    // server-side source of truth. On failure the class is rolled back, so the UI
    // never claims a theme the server did not save.
    async function toggleTheme() {
        const isDark = !document.body.classList.contains('dark-theme');
        document.body.classList.toggle('dark-theme', isDark);

        try {
            const body = new URLSearchParams({ darkTheme: isDark, redirectTo: '/settings' });
            const res = await fetch('/settings/theme', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                credentials: 'include',
                body
            });
            if (!res.ok) throw new Error('Request failed: ' + res.status);
        } catch (error) {
            console.error('Error saving theme:', error);
            document.body.classList.toggle('dark-theme', !isDark);
        }
    }
</script>

</body>
</html>
