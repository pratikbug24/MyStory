<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log in — Daybook</title>
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
                <p class="auth-sheet-date">This morning</p>
                <p class="auth-hand">One page a day,<br>kept quietly yours.</p>
                <div class="auth-sheet-lines">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
            </div>

            <p class="auth-quote">Your entries are waiting exactly where you left them.</p>
        </div>
    </aside>

    <main class="auth-main">
        <div class="auth-card">

            <p class="auth-eyebrow">Welcome back</p>
            <h1 class="auth-title">Log in to your Daybook</h1>
            <p class="auth-lede">Pick up where you left off.</p>

            <c:if test="${not empty error}">
                <div class="auth-alert" role="alert">${error}</div>
            </c:if>
            <c:if test="${not empty message}">
                <div class="auth-alert auth-alert-ok" role="status">${message}</div>
            </c:if>

            <form class="auth-form" action="/login" method="post">
                <div class="auth-field">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" placeholder="your username"
                           autocomplete="username" required autofocus>
                </div>

                <div class="auth-field">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="your password"
                           autocomplete="current-password" required>
                </div>

                <button class="auth-submit" type="submit">Log in</button>
            </form>

            <p class="auth-switch">
                New to Daybook? <a href="/register">Create an account</a>
            </p>
            <p class="auth-back"><a href="/">&larr; Back to home</a></p>

        </div>
    </main>

</div>

</body>
</html>
