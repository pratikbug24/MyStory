<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="net.engineeringdigest.journalApp.entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("/");
        return;
    }
    boolean isDarkTheme = user.isDarkTheme();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Settings - Journal App</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .settings-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
        }

        .settings-section {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 4px 20px var(--shadow-light);
        }

        .settings-section h2 {
            font-size: 1.2rem;
            color: var(--card-text);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .setting-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid var(--input-border);
        }

        .setting-item:last-child {
            border-bottom: none;
        }

        .setting-info h3 {
            font-size: 1rem;
            color: var(--card-text);
            margin-bottom: 4px;
        }

        .setting-info p {
            font-size: 0.85rem;
            color: var(--card-subtext);
        }

        .toggle-switch {
            position: relative;
            width: 50px;
            height: 26px;
        }

        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: 0.3s;
            border-radius: 26px;
        }

        .toggle-slider:before {
            position: absolute;
            content: "";
            height: 20px;
            width: 20px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: 0.3s;
            border-radius: 50%;
        }

        input:checked + .toggle-slider {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        input:checked + .toggle-slider:before {
            transform: translateX(24px);
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

        .btn-danger {
            background: #dc3545;
        }

        .btn-danger:hover {
            background: #c82333;
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.4);
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

        @media (max-width: 500px) {
            .setting-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
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
                <a href="/profile" class="top-link"><i class="fas fa-user"></i> Profile</a>
                <a href="/logout" class="top-link"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>

        <div class="settings-container">

            <% if (request.getAttribute("success") != null) { %>
                <div class="success-msg"><%= request.getAttribute("success") %></div>
            <% } %>

            <!-- Theme Settings -->
            <div class="settings-section">
                <h2><i class="fas fa-palette"></i> Appearance</h2>

                <div class="setting-item">
                    <div class="setting-info">
                        <h3>Dark Mode</h3>
                        <p>Switch between light and dark theme</p>
                    </div>
                    <form action="/settings/theme" method="post" style="display: inline;">
                        <label class="toggle-switch">
                            <input type="checkbox" name="darkTheme" <%= isDarkTheme ? "checked" : "" %> onchange="this.form.submit()">
                            <span class="toggle-slider"></span>
                        </label>
                    </form>
                </div>
            </div>

            <!-- Quick Links -->
            <div class="settings-section">
                <h2><i class="fas fa-link"></i> Quick Links</h2>

                <div class="setting-item">
                    <div class="setting-info">
                        <h3>My Profile</h3>
                        <p>View and edit your profile</p>
                    </div>
                    <a href="/profile" class="btn">
                        <i class="fas fa-user"></i> View
                    </a>
                </div>

                <div class="setting-item">
                    <div class="setting-info">
                        <h3>Journal Dashboard</h3>
                        <p>Go to your journal entries</p>
                    </div>
                    <a href="/dashboard" class="btn">
                        <i class="fas fa-book"></i> View
                    </a>
                </div>
            </div>

            <!-- Account -->
            <div class="settings-section">
                <h2><i class="fas fa-user-cog"></i> Account</h2>

                <div class="setting-item">
                    <div class="setting-info">
                        <h3>Delete Account</h3>
                        <p>Permanently delete your account and data</p>
                    </div>
                    <form action="/settings/delete" method="post" onsubmit="return confirm('Are you sure you want to delete your account? This cannot be undone.');">
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </form>
                </div>
            </div>

            <!-- About -->
            <div class="settings-section">
                <h2><i class="fas fa-info-circle"></i> About</h2>

                <div class="setting-item">
                    <div class="setting-info">
                        <h3>Journal App</h3>
                        <p>Version 1.0.0</p>
                    </div>
                </div>
            </div>

        </div>
    </div>

</body>
</html>