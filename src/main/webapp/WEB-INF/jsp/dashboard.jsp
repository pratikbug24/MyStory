<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard · Daybook</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,400;9..144,600;9..144,700&family=Karla:wght@400;500;600&family=Caveat:wght@500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/dashboard.css">
</head>
<body class="${sessionScope.user.darkTheme ? 'dark-theme' : ''}">

<header class="db-top">
    <a class="db-brand" href="/">
        <img class="db-brand-logo" src="/images/logo.png" alt="" width="38" height="38">
        <span class="db-brand-name">Daybook</span>
    </a>

    <div class="db-top-actions">
        <div class="db-who">
            <span class="db-avatar" id="userInitial" aria-hidden="true"></span>
            <span id="usernameDisplay">${sessionScope.user.username}</span>
        </div>

        <button class="db-icon-btn db-theme-toggle" type="button" onclick="toggleTheme()"
                title="Toggle theme" aria-label="Toggle dark theme">
            <svg class="sun-icon" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zM2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1zm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1zM11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1zm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1zM5.99 4.58c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0s.39-1.03 0-1.41L5.99 4.58zm12.37 12.37c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0 .39-.39.39-1.03 0-1.41l-1.06-1.06zm1.06-10.96c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06zM7.05 18.36c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06z"/>
            </svg>
            <svg class="moon-icon" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M12 3c-4.97 0-9 4.03-9 9s4.03 9 9 9 9-4.03 9-9c0-.46-.04-.92-.1-1.36-.98 1.37-2.58 2.26-4.4 2.26-2.98 0-5.4-2.42-5.4-5.4 0-1.81.89-3.42 2.26-4.4-.44-.06-.9-.1-1.36-.1z"/>
            </svg>
        </button>

        <a class="db-icon-btn" href="/profile" title="Profile" aria-label="Profile">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
            </svg>
        </a>

        <a class="db-icon-btn" href="/settings" title="Settings" aria-label="Settings">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M19.14 12.94c.04-.31.06-.63.06-.94 0-.31-.02-.63-.06-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.04.31-.06.63-.06.94s.02.63.06.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/>
            </svg>
        </a>

        <a class="db-logout" href="/logout">Log out</a>
    </div>
</header>

<main class="db-wrap">

    <div class="db-head">
        <p class="db-eyebrow">Your journal</p>
        <h1 class="db-title" id="greeting">Welcome back</h1>
        <p class="db-lede" id="todayLine">A quiet place to put today's thoughts.</p>
    </div>

    <section class="db-stats" aria-label="Journal summary">
        <div class="db-stat">
            <span class="db-stat-value" id="totalEntries">0</span>
            <span class="db-stat-label">Entries</span>
        </div>
        <div class="db-stat">
            <span class="db-stat-value" id="statWords">0</span>
            <span class="db-stat-label">Words written</span>
        </div>
        <div class="db-stat">
            <span class="db-stat-value" id="statStreak">0</span>
            <span class="db-stat-label">Day streak</span>
        </div>
        <div class="db-stat">
            <span class="db-stat-value" id="statThisMonth">0</span>
            <span class="db-stat-label">This month</span>
        </div>
    </section>

    <div class="db-compose">
        <button class="db-compose-bar" type="button" onclick="openModal()">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
            </svg>
            What's on your mind today?
        </button>
    </div>

    <div class="db-toolbar">
        <div class="db-search">
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
            </svg>
            <input type="text" id="searchInput" placeholder="Search your entries…"
                   oninput="filterEntries()" aria-label="Search entries">
        </div>

        <label class="db-sort-label" for="sortSelect" hidden>Sort entries</label>
        <select class="db-sort" id="sortSelect" onchange="sortEntries()" aria-label="Sort entries">
            <option value="newest">Newest first</option>
            <option value="oldest">Oldest first</option>
            <option value="title">By title</option>
        </select>
    </div>

    <div id="entries" class="db-grid"></div>

    <div id="emptyState" class="db-empty" style="display: none;">
        <svg viewBox="0 0 24 24" aria-hidden="true">
            <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
        </svg>
        <h3 id="emptyTitle">Nothing here yet</h3>
        <p id="emptyText">Every journal starts with a single page. Write your first entry to begin.</p>
    </div>

</main>

<div id="modal" class="db-modal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
    <div class="db-modal-card">
        <div class="db-modal-head">
            <h2 id="modalTitle">New entry</h2>
            <span class="db-modal-date" id="modalDate"></span>
        </div>

        <div class="db-form-error" id="formError" role="alert" hidden></div>

        <div class="db-field">
            <label for="title">Title</label>
            <input type="text" id="title" placeholder="Give this page a title">
        </div>

        <div class="db-field">
            <label for="content">Entry</label>
            <textarea id="content" placeholder="Write freely — only you will read this."></textarea>
        </div>

        <div class="db-modal-actions">
            <button class="db-btn db-btn-primary" type="button" id="saveBtn" onclick="addEntry()">Save entry</button>
            <button class="db-btn db-btn-ghost" type="button" onclick="closeModal()">Cancel</button>
        </div>
    </div>
</div>

<script src="/js/script.js"></script>
</body>
</html>