<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard · Daybook</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>

<div class="wrapper">

    <!-- Top Bar with User Info -->
    <div class="top-bar">
        <div class="user-info" id="userInfo">
            👤 <span id="usernameDisplay">${sessionScope.user.username}</span>
        </div>
        <div class="top-bar-actions">
            <button class="theme-toggle" onclick="toggleTheme()" title="Toggle Theme">
                <svg class="sun-icon" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 7c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5zM2 13h2c.55 0 1-.45 1-1s-.45-1-1-1H2c-.55 0-1 .45-1 1s.45 1 1 1zm18 0h2c.55 0 1-.45 1-1s-.45-1-1-1h-2c-.55 0-1 .45-1 1s.45 1 1 1zM11 2v2c0 .55.45 1 1 1s1-.45 1-1V2c0-.55-.45-1-1-1s-1 .45-1 1zm0 18v2c0 .55.45 1 1 1s1-.45 1-1v-2c0-.55-.45-1-1-1s-1 .45-1 1zM5.99 4.58c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0s.39-1.03 0-1.41L5.99 4.58zm12.37 12.37c-.39-.39-1.03-.39-1.41 0-.39.39-.39 1.03 0 1.41l1.06 1.06c.39.39 1.03.39 1.41 0 .39-.39.39-1.03 0-1.41l-1.06-1.06zm1.06-10.96c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06zM7.05 18.36c.39-.39.39-1.03 0-1.41-.39-.39-1.03-.39-1.41 0l-1.06 1.06c-.39.39-.39 1.03 0 1.41s1.03.39 1.41 0l1.06-1.06z"/>
                </svg>
                <svg class="moon-icon" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M12 3c-4.97 0-9 4.03-9 9s4.03 9 9 9 9-4.03 9-9c0-.46-.04-.92-.1-1.36-.98 1.37-2.58 2.26-4.4 2.26-2.98 0-5.4-2.42-5.4-5.4 0-1.81.89-3.42 2.26-4.4-.44-.06-.9-.1-1.36-.1z"/>
                </svg>
            </button>
            <button class="settings-btn" onclick="window.location.href='/settings'" title="Settings">
                <svg viewBox="0 0 24 24" fill="currentColor">
                    <path d="M19.14 12.94c.04-.31.06-.63.06-.94 0-.31-.02-.63-.06-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.04.31-.06.63-.06.94s.02.63.06.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z"/>
                </svg>
            </button>
            <a href="/profile" class="profile-link">
                <button class="profile-btn" title="Profile">
                    <svg viewBox="0 0 24 24" fill="currentColor">
                        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                    </svg>
                </button>
            </a>
            <a href="/logout" class="logout-link">
                <button class="logout-btn">Logout</button>
            </a>
        </div>
    </div>

    <div class="header">
        <h1>📔 Journal Dashboard</h1>
        <p>Capture your thoughts and ideas</p>
    </div>

    <!-- Search and Filter Bar -->
    <div class="toolbar">
        <div class="search-box">
            <svg viewBox="0 0 24 24" fill="currentColor">
                <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
            </svg>
            <input type="text" id="searchInput" placeholder="Search entries..." oninput="filterEntries()">
        </div>
        <div class="sort-dropdown">
            <select id="sortSelect" onchange="sortEntries()">
                <option value="newest">Newest First</option>
                <option value="oldest">Oldest First</option>
                <option value="title">By Title</option>
            </select>
        </div>
    </div>

    <!-- Stats Bar -->
    <div class="stats-bar">
        <div class="stat-item">
            <span class="stat-icon">📊</span>
            <span class="stat-label">Total Entries:</span>
            <span class="stat-value" id="totalEntries">0</span>
        </div>
        <div class="stat-item">
            <span class="stat-icon">📅</span>
            <span class="stat-label">Latest:</span>
            <span class="stat-value" id="latestDate">-</span>
        </div>
    </div>

    <!-- Google Keep Style Trigger -->
    <div class="note-trigger" onclick="openModal()">
        <span>📝</span>
        Take a note...
    </div>

    <!-- Floating Action Button for Mobile -->
    <button class="fab" onclick="openModal()">
        <svg viewBox="0 0 24 24">
            <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
        </svg>
    </button>

    <!-- Entries Grid -->
    <div id="entries" class="grid"></div>

    <!-- Empty State (hidden by default) -->
    <div id="emptyState" class="empty-state" style="display: none;">
        <svg viewBox="0 0 24 24" fill="currentColor">
            <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
        </svg>
        <h3>No entries yet</h3>
        <p>Click "Take a note..." to create your first journal entry</p>
    </div>

</div>

<!-- Modal -->
<div id="modal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>New Entry</h2>
        </div>
        <div class="input-container">
            <input type="text" id="title" placeholder="Title">
            <textarea id="content" placeholder="Take a note..."
                      oninput="autoExpand(this)"></textarea>
            <input type="text" id="tags" placeholder="Tags (comma separated)">
        </div>
        <div class="modal-actions">
            <button onclick="addEntry()">Add Entry</button>
            <button onclick="closeModal()">Close</button>
        </div>
    </div>
</div>

<!-- Settings Modal -->
<div id="settingsModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>⚙️ Settings</h2>
        </div>
        <div class="input-container">
            <label>Display Name</label>
            <input type="text" id="settingsUsername" placeholder="Enter your name" value="${sessionScope.user.username}">
        </div>
        <div class="modal-actions">
            <button onclick="saveSettings()">Save</button>
            <button onclick="closeSettings()">Close</button>
        </div>
    </div>
</div>

<script src="/js/script.js"></script>
</body>
</html>