<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create your Daybook</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,400;9..144,600;9..144,700&family=Karla:wght@400;500;600&family=Caveat:wght@500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/auth.css">
</head>
<body class="auth">

<div class="auth-shell">

    <aside class="auth-aside">
        <a class="auth-brand" href="/">
            <img class="auth-brand-logo" src="/images/logo.png" alt="" width="44" height="44">
            <span class="auth-brand-name">Daybook</span>
        </a>

        <div class="auth-aside-body">
            <div class="auth-sheet">
                <p class="auth-sheet-date">Day one</p>
                <p class="auth-hand">Start anywhere.<br>Just start.</p>
                <div class="auth-sheet-lines">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
            </div>

            <ul class="auth-points">
                <li>One page a day, in your own words</li>
                <li>Private by default &mdash; yours alone</li>
                <li>Search, tags and mood, when you want them</li>
            </ul>
        </div>
    </aside>

    <main class="auth-main">
        <div class="auth-card">

            <p class="auth-eyebrow">Get started</p>
            <h1 class="auth-title">Create your Daybook</h1>
            <p class="auth-lede">A quiet place to write. It takes a moment to set up.</p>

            <c:if test="${not empty error}">
                <div class="auth-alert" role="alert">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="auth-alert auth-alert-ok" role="status">${message}</div>
            </c:if>

            <form class="auth-form" action="/register" method="post">
                <div class="auth-field">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" placeholder="pick a username"
                           autocomplete="username" required autofocus>
                </div>

                <div class="auth-field">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="choose a password"
                           autocomplete="new-password" required>
                    <span class="auth-hint">At least 6 characters.</span>
                </div>

                <div class="auth-field">
                    <label for="confirmPassword">Confirm password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           placeholder="repeat your password"
                           autocomplete="new-password" required>
                </div>

                <button class="auth-submit" type="submit">Create account</button>
            </form>

            <p class="auth-switch">
                Already have an account? <a href="/login">Log in</a>
            </p>
            <p class="auth-back"><a href="/">&larr; Back to home</a></p>

        </div>
    </main>

</div>

</body>
</html>
