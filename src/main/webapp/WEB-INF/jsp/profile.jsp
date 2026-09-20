<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile · Daybook</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,400;9..144,600;9..144,700&family=Karla:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/profile.css">
</head>
<body class="${sessionScope.user.darkTheme ? 'dark-theme' : ''}">

<header class="pf-top">
    <a class="pf-brand" href="/">
        <img class="pf-brand-logo" src="/images/logo.png" alt="" width="38" height="38">
        <span class="pf-brand-name">MyStory</span>
    </a>

    <div class="pf-top-actions">
        <button class="pf-icon-btn pf-theme-toggle" type="button" onclick="toggleTheme()"
                title="Toggle theme" aria-label="Toggle dark theme">
            <svg class="sun-icon" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zM2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1zm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1zM11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1zm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1zM5.99 4.58c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0s.39-1.03 0-1.41L5.99 4.58zm12.37 12.37c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0 .39-.39.39-1.03 0-1.41l-1.06-1.06zm1.06-10.96c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06zM7.05 18.36c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06z"/>
            </svg>
            <svg class="moon-icon" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M12 3c-4.97 0-9 4.03-9 9s4.03 9 9 9 9-4.03 9-9c0-.46-.04-.92-.1-1.36-.98 1.37-2.58 2.26-4.4 2.26-2.98 0-5.4-2.42-5.4-5.4 0-1.81.89-3.42 2.26-4.4-.44-.06-.9-.1-1.36-.1z"/>
            </svg>
        </button>

        <a class="pf-icon-btn" href="/dashboard" title="Dashboard" aria-label="Dashboard">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/>
            </svg>
        </a>

        <a class="pf-icon-btn" href="/settings" title="Settings" aria-label="Settings">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M19.14 12.94c.04-.31.06-.63.06-.94 0-.31-.02-.63-.06-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.04.31-.06.63-.06.94s.02.63.06.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/>
            </svg>
        </a>

        <a class="pf-logout" href="/logout">Log out</a>
    </div>
</header>

<main class="pf-wrap">

    <div class="pf-head">
        <p class="pf-eyebrow">Your account</p>
        <h1 class="pf-title">Profile</h1>
        <p class="pf-lede">How your journal sees you.</p>
    </div>

    <c:if test="${not empty success}">
        <div class="pf-alert pf-alert-success" role="status">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M9 16.17 4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
            </svg>
            <span><c:out value="${success}"/></span>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="pf-alert pf-alert-error" role="alert">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"/>
            </svg>
            <span><c:out value="${error}"/></span>
        </div>
    </c:if>

    <section class="pf-hero">
        <div class="pf-avatar" aria-hidden="true">
            <c:choose>
                <c:when test="${not empty sessionScope.user.profileImage}">
                    <img src="/uploads/<c:out value='${sessionScope.user.profileImage}'/>"
                         alt="" width="92" height="92">
                </c:when>
                <c:otherwise><c:out value="${fn:substring(sessionScope.user.username, 0, 1)}"/></c:otherwise>
            </c:choose>
        </div>

        <div class="pf-hero-body">
            <h2 class="pf-hero-name">
                <c:choose>
                    <c:when test="${not empty sessionScope.user.fullName}"><c:out value="${sessionScope.user.fullName}"/></c:when>
                    <c:otherwise><c:out value="${sessionScope.user.username}"/></c:otherwise>
                </c:choose>
            </h2>
            <p class="pf-hero-username">@<c:out value="${sessionScope.user.username}"/></p>

            <p class="pf-hero-contact">
                <span>
                    <svg viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M20 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4-8 5-8-5V6l8 5 8-5v2z"/>
                    </svg>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.email}"><c:out value="${sessionScope.user.email}"/></c:when>
                        <c:otherwise>No email added</c:otherwise>
                    </c:choose>
                </span>
            </p>

            <c:choose>
                <c:when test="${not empty sessionScope.user.bio}">
                    <p class="pf-hero-bio"><c:out value="${sessionScope.user.bio}"/></p>
                </c:when>
                <c:otherwise>
                    <p class="pf-hero-bio is-empty">No bio yet. Add a line or two about yourself below.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <section class="pf-stats" aria-label="Journal summary">
        <div class="pf-stat">
            <span class="pf-stat-value"><c:out value="${entryCount}" default="0"/></span>
            <span class="pf-stat-label">Entries</span>
        </div>
        <div class="pf-stat">
            <span class="pf-stat-value"><c:out value="${wordCount}" default="0"/></span>
            <span class="pf-stat-label">Words written</span>
        </div>
        <div class="pf-stat">
            <span class="pf-stat-value"><c:out value="${daysActive}" default="0"/></span>
            <span class="pf-stat-label">Days active</span>
        </div>
        <div class="pf-stat">
            <span class="pf-stat-value"><c:out value="${monthCount}" default="0"/></span>
            <span class="pf-stat-label">This month</span>
        </div>
    </section>

    <div class="pf-grid">

        <section class="pf-card">
            <div class="pf-card-head">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M9 2 7.17 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2h-3.17L15 2H9zm3 15c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5z"/>
                </svg>
                <h2>Profile photo</h2>
            </div>
            <p class="pf-card-note">PNG, JPG or GIF, up to 5 MB. Large images are resized automatically.</p>

            <div class="pf-photo-row">
                <div class="pf-photo-preview" aria-hidden="true">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user.profileImage}">
                            <img id="photoPreview"
                                 src="/uploads/<c:out value='${sessionScope.user.profileImage}'/>" alt="">
                        </c:when>
                        <c:otherwise>
                            <img id="photoPreview" src="" alt="" hidden>
                            <span id="photoPreviewInitial"><c:out value="${fn:substring(sessionScope.user.username, 0, 1)}"/></span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="pf-photo-actions">
                    <form action="/profile/photo" method="post" enctype="multipart/form-data" class="pf-photo-form">
                        <input type="file" id="photoFile" name="file" accept="image/*" hidden
                               onchange="this.form.submit()">
                        <label for="photoFile" class="pf-btn pf-btn-primary">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.profileImage}">Replace photo</c:when>
                                <c:otherwise>Upload photo</c:otherwise>
                            </c:choose>
                        </label>
                    </form>

                    <c:if test="${not empty sessionScope.user.profileImage}">
                        <form action="/profile/photo/delete" method="post"
                              onsubmit="return confirm('Remove your profile photo?');">
                            <button type="submit" class="pf-btn pf-btn-ghost">Remove</button>
                        </form>
                    </c:if>
                </div>
            </div>
        </section>

        <section class="pf-card">
            <div class="pf-card-head">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                </svg>
                <h2>Edit profile</h2>
            </div>
            <p class="pf-card-note">Your name and bio appear on your profile.</p>

            <form action="/profile/update" method="post">
                <div class="pf-field">
                    <label for="fullName">Full name</label>
                    <input type="text" id="fullName" name="fullName"
                           value="<c:out value='${sessionScope.user.fullName}'/>"
                           placeholder="e.g. Maya Rivera" maxlength="80" autocomplete="name">
                </div>

                <div class="pf-field">
                    <label for="email">Email address</label>
                    <input type="email" id="email" name="email"
                           value="<c:out value='${sessionScope.user.email}'/>"
                           placeholder="you@example.com" maxlength="120" autocomplete="email">
                </div>

                <div class="pf-field">
                    <label for="bio">Bio</label>
                    <textarea id="bio" name="bio" maxlength="400"
                              placeholder="A line or two about yourself…"><c:out value="${sessionScope.user.bio}"/></textarea>
                    <span class="pf-hint">Up to 400 characters.</span>
                </div>

                <div class="pf-actions">
                    <button type="submit" class="pf-btn pf-btn-primary">Save changes</button>
                </div>
            </form>
        </section>

        <section class="pf-card">
            <div class="pf-card-head">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zM9 8V6c0-1.66 1.34-3 3-3s3 1.34 3 3v2H9z"/>
                </svg>
                <h2>Change password</h2>
            </div>
            <p class="pf-card-note">Pick something you have not used elsewhere.</p>

            <form action="/profile/password" method="post">
                <div class="pf-field">
                    <label for="currentPassword">Current password</label>
                    <input type="password" id="currentPassword" name="currentPassword"
                           placeholder="Your current password" required autocomplete="current-password">
                </div>

                <div class="pf-field">
                    <label for="newPassword">New password</label>
                    <input type="password" id="newPassword" name="newPassword"
                           placeholder="Choose a new password" required autocomplete="new-password">
                </div>

                <div class="pf-field">
                    <label for="confirmPassword">Confirm new password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           placeholder="Repeat the new password" required autocomplete="new-password">
                    <span class="pf-hint">Both entries must match.</span>
                </div>

                <div class="pf-actions">
                    <button type="submit" class="pf-btn pf-btn-primary">Update password</button>
                </div>
            </form>
        </section>

    </div>
</main>

<script>
    // Inline because this is the only script the page needs. It posts to the same
    // endpoint the dashboard and settings pages use, so the theme stays a single
    // server-side source of truth.
    async function toggleTheme() {
        const isDark = !document.body.classList.contains('dark-theme');
        document.body.classList.toggle('dark-theme', isDark);

        try {
            const body = new URLSearchParams({ darkTheme: isDark, redirectTo: '/profile' });
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