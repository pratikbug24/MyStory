<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="net.engineeringdigest.journalApp.entity.User" %>
<%@ page import="net.engineeringdigest.journalApp.entity.JournalEntry" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("/");
        return;
    }
    List<JournalEntry> entries = (List<JournalEntry>) request.getAttribute("entries");
    int totalEntries = entries != null ? entries.size() : 0;
    int totalWords = 0;
    if (entries != null) {
        for (JournalEntry entry : entries) {
            if (entry.getContent() != null) {
                totalWords += entry.getContent().split("\\s+").length;
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile - Journal App</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .profile-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }

        .profile-header {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 40px;
            text-align: center;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px var(--shadow-light);
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 3rem;
            color: white;
        }

        .profile-name {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--card-text);
            margin-bottom: 5px;
        }

        .profile-username {
            color: var(--card-subtext);
            font-size: 1rem;
        }

        .profile-email {
            color: var(--card-subtext);
            font-size: 0.9rem;
            margin-top: 10px;
        }

        .profile-bio {
            margin-top: 15px;
            color: var(--card-text);
            font-size: 0.95rem;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }

        .profile-section {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 4px 20px var(--shadow-light);
        }

        .profile-section h2 {
            font-size: 1.3rem;
            color: var(--card-text);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--card-subtext);
            font-weight: 500;
            font-size: 0.9rem;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid var(--input-border);
            border-radius: 8px;
            font-size: 14px;
            background: var(--bg-secondary);
            color: var(--card-text);
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--accent-color);
        }

        .btn {
            padding: 12px 24px;
            background: var(--btn-primary);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            text-decoration: none;
            display: inline-block;
        }

        .btn:hover {
            transform: scale(1.02);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        .stat-card {
            background: var(--bg-secondary);
            padding: 20px;
            border-radius: 12px;
            text-align: center;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--accent-color);
        }

        .stat-label {
            color: var(--card-subtext);
            font-size: 0.85rem;
            margin-top: 5px;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 30px;
            background: var(--top-bar-bg);
            border-radius: 12px;
            margin-bottom: 30px;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            color: white;
            font-size: 1.3rem;
            font-weight: 700;
        }

        .logo-icon {
            font-size: 1.5rem;
        }

        .top-links {
            display: flex;
            gap: 15px;
        }

        .top-link {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 8px;
            background: rgba(255,255,255,0.2);
            transition: background 0.2s;
        }

        .top-link:hover {
            background: rgba(255,255,255,0.3);
        }

        .success-msg {
            background: #e6f4ea;
            color: #1e8e3e;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .error-msg {
            background: #fce8e6;
            color: #c5221f;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        @media (max-width: 600px) {
            .stats-grid { grid-template-columns: 1fr; }
            .top-bar { flex-direction: column; gap: 15px; }
        }
    </style>
</head>
<body>

    <!-- Top Bar -->
    <div class="wrapper">
        <div class="top-bar">
            <div class="logo">
                <span class="logo-icon">📔</span>
                <span class="logo-text">Journal App</span>
            </div>
            <div class="top-links">
                <a href="/dashboard" class="top-link"><i class="fas fa-home"></i> Dashboard</a>
                <a href="/settings" class="top-link"><i class="fas fa-cog"></i> Settings</a>
                <a href="/logout" class="top-link"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>

        <div class="profile-container">

            <% if (request.getAttribute("success") != null) { %>
                <div class="success-msg"><%= request.getAttribute("success") %></div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="error-msg"><%= request.getAttribute("error") %></div>
            <% } %>

            <!-- Profile Header -->
            <div class="profile-header">
                <div class="profile-avatar">
                    <%= user.getUsername() != null ? user.getUsername().substring(0, 1).toUpperCase() : "U" %>
                </div>
                <div class="profile-name">
                    <%= user.getFullName() != null ? user.getFullName() : user.getUsername() %>
                </div>
                <div class="profile-username">@<%= user.getUsername() %></div>
                <div class="profile-email">
                    <i class="fas fa-envelope"></i>
                    <%= user.getEmail() != null ? user.getEmail() : "No email added" %>
                </div>
                <div class="profile-bio">
                    <%= user.getBio() != null ? user.getBio() : "No bio added yet. Tell us about yourself!" %>
                </div>
            </div>

            <!-- Stats -->
            <div class="profile-section">
                <h2><i class="fas fa-chart-bar"></i> Your Stats</h2>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number"><%= totalEntries %></div>
                        <div class="stat-label">Total Entries</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><%= totalWords %></div>
                        <div class="stat-label">Total Words</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number"><%= user.getId() != null ? "1" : "0" %></div>
                        <div class="stat-label">Days Active</div>
                    </div>
                </div>
            </div>

            <!-- Edit Profile Form -->
            <div class="profile-section">
                <h2><i class="fas fa-edit"></i> Edit Profile</h2>
                <form action="/profile/update" method="post">
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" name="fullName" value="<%= user.getFullName() != null ? user.getFullName() : "" %>" placeholder="Enter your full name">
                    </div>

                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" placeholder="Enter your email">
                    </div>

                    <div class="form-group">
                        <label for="bio">Bio</label>
                        <textarea id="bio" name="bio" placeholder="Tell us about yourself..."><%= user.getBio() != null ? user.getBio() : "" %></textarea>
                    </div>

                    <button type="submit" class="btn">Save Changes</button>
                </form>
            </div>

            <!-- Change Password -->
            <div class="profile-section">
                <h2><i class="fas fa-lock"></i> Change Password</h2>
                <form action="/profile/password" method="post">
                    <div class="form-group">
                        <label for="currentPassword">Current Password</label>
                        <input type="password" id="currentPassword" name="currentPassword" placeholder="Enter current password" required>
                    </div>

                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" placeholder="Enter new password" required>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm New Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm new password" required>
                    </div>

                    <button type="submit" class="btn">Update Password</button>
                </form>
            </div>

        </div>
    </div>

</body>
</html>