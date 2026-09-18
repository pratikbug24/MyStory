<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MyStory — a quiet place to write every day</title>
    <meta name="description" content="Daybook is a personal daily diary. Write one honest page a day, keep it private, and watch your thoughts add up.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,400;9..144,600;9..144,700&family=Karla:wght@400;500;600&family=Caveat:wght@500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="/css/home.css">
</head>
<body class="landing">

<div class="lp-grain" aria-hidden="true"></div>

<header class="lp-nav">
    <a class="lp-brand" href="/">
         <img class="lp-brand-logo" src="/images/logo.png" alt="" width="34" height="34">
        <span class="lp-brand-name">MyStory</span>
    </a>
    <nav class="lp-nav-links" aria-label="Primary">
        <a href="#features">Features</a>
        <a href="#why">Why Daybook</a>
        <a href="#start">Get started</a>
    </nav>
    <div class="lp-nav-actions">
        <c:choose>
            <c:when test="${sessionScope.user != null}">
                <a class="lp-btn lp-btn-solid" href="/dashboard">Go to Dashboard</a>
            </c:when>
            <c:otherwise>
                <a class="lp-link-quiet" href="/login">Log in</a>
                <a class="lp-btn lp-btn-solid" href="/register">Start writing</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>

<main>

    <!-- Hero -->
    <section class="lp-hero">
        <div class="lp-hero-copy">
            <p class="lp-eyebrow">A personal daily diary</p>
            <h1 class="lp-title">
                One page a day,<br>
                <em>kept quietly yours.</em>
            </h1>
            <p class="lp-lede">
                Most journals die in a drawer. Daybook asks for a single honest
                page, then keeps every one of them in order — private, searchable,
                and waiting for you tomorrow.
            </p>
            <div class="lp-cta-row">
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <a class="lp-btn lp-btn-solid lp-btn-lg" href="/dashboard">Go to Dashboard</a>
                    </c:when>
                    <c:otherwise>
                        <a class="lp-btn lp-btn-solid lp-btn-lg" href="/register">Start your diary</a>
                        <a class="lp-btn lp-btn-ghost lp-btn-lg" href="/login">I have an account</a>
                    </c:otherwise>
                </c:choose>
            </div>
            <p class="lp-note">
                <span class="lp-note-hand">No feed, no followers, no noise.</span>
                <span class="lp-note-sub">Just you and the page.</span>
            </p>
        </div>

        <!-- Layered diary page visual -->
        <div class="lp-hero-art" aria-hidden="true">
            <div class="lp-sheet lp-sheet-back"></div>
            <div class="lp-sheet lp-sheet-mid"></div>
            <article class="lp-sheet lp-sheet-front">
                <header class="lp-sheet-head">
                    <span class="lp-sheet-date">Tuesday, 15 September</span>
                    <span class="lp-sheet-mood" title="Mood">calm</span>
                </header>
                <div class="lp-ruled">
                    <p class="lp-entry-hand">Woke before the alarm. Walked the long way
                        to the market and finally finished the chapter I've been
                        circling for a week.</p>
                </div>
                <footer class="lp-sheet-foot">
                    <span>Day 128</span>
                    <span class="lp-streak">🔥 12 day streak</span>
                </footer>
            </article>
        </div>
    </section>

    <!-- Features -->
    <section class="lp-section" id="features">
        <header class="lp-section-head">
            <p class="lp-eyebrow">What's inside</p>
            <h2 class="lp-h2">Everything a daily habit needs</h2>
            <p class="lp-section-sub">
                Small enough to open every night. Deep enough to hold years of them.
            </p>
        </header>

        <div class="lp-grid">
            <article class="lp-card lp-card-wide">
                <span class="lp-card-glyph">✎</span>
                <h3>Today's page, always ready</h3>
                <p>
                    Open the app and today's entry is already there, dated for you.
                    No filing, no naming files, no deciding where things go.
                </p>
            </article>

            <article class="lp-card">
                <span class="lp-card-glyph">◐</span>
                <h3>Mood &amp; weather</h3>
                <p>Tag how the day felt. See the shape of a month at a glance.</p>
            </article>

            <article class="lp-card">
                <span class="lp-card-glyph">❋</span>
                <h3>Streaks</h3>
                <p>A gentle count of consecutive days. Encouragement, not guilt.</p>
            </article>

            <article class="lp-card">
                <span class="lp-card-glyph">⌕</span>
                <h3>Search everything</h3>
                <p>Find the entry about the new job, the trip, the name you forgot.</p>
            </article>

            <article class="lp-card">
                <span class="lp-card-glyph">▤</span>
                <h3>Calendar view</h3>
                <p>
                    Every day you wrote, laid out as a grid. Gaps are honest,
                    not a failure.
                </p>
            </article>

            <article class="lp-card">
                <span class="lp-card-glyph">⤓</span>
                <h3>Yours to take</h3>
                <p>Export the whole diary any time. Your words shouldn't be locked in.</p>
            </article>

            <article class="lp-card lp-card-wide">
                <span class="lp-card-glyph">⌂</span>
                <h3>Private by default</h3>
                <p>
                    No public feed, no sharing prompts. Entries belong to the account
                    that wrote them and nothing else.
                </p>
            </article>
        </div>
    </section>

    <!-- Why -->
    <section class="lp-section lp-why" id="why">
        <div class="lp-why-copy">
            <p class="lp-eyebrow">Why a daily diary</p>
            <h2 class="lp-h2">Writing daily changes what you notice</h2>
            <p>
                A diary isn't a record of your life so much as a habit of paying
                attention. Ten minutes a night is enough to catch the things that
                would otherwise slide past — what actually wore you out, what
                quietly made the day better.
            </p>
            <p>
                Daybook is built around that one commitment: show up, write a page,
                close it. Everything else in the app is in service of making that
                easy to keep doing.
            </p>
        </div>
        <ul class="lp-why-list">
            <li>
                <span class="lp-why-num">01</span>
                <div>
                    <h4>Lower the bar</h4>
                    <p>A dated blank page beats a blank screen. Start, don't plan.</p>
                </div>
            </li>
            <li>
                <span class="lp-why-num">02</span>
                <div>
                    <h4>Make it visible</h4>
                    <p>Streaks and a calendar turn private effort into momentum.</p>
                </div>
            </li>
            <li>
                <span class="lp-why-num">03</span>
                <div>
                    <h4>Keep it yours</h4>
                    <p>No audience. Honest writing needs a locked door.</p>
                </div>
            </li>
        </ul>
    </section>

    <!-- Start -->
    <section class="lp-start" id="start">
        <div class="lp-start-inner">
            <h2 class="lp-h2">Tonight's page is waiting</h2>
            <p class="lp-start-sub">
                Create an account and write the first entry in under a minute.
            </p>
            <div class="lp-cta-row lp-cta-center">
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <a class="lp-btn lp-btn-solid lp-btn-lg" href="/dashboard">Open my Dashboard</a>
                    </c:when>
                    <c:otherwise>
                        <a class="lp-btn lp-btn-solid lp-btn-lg" href="/register">Create your diary</a>
                        <a class="lp-btn lp-btn-ghost lp-btn-lg" href="/login">Log in</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </section>

</main>

<footer class="lp-footer">
    <span class="lp-brand-name">Daybook</span>
    <span class="lp-footer-sep">·</span>
    <span>A personal daily diary</span>
    <span class="lp-footer-right">Written one day at a time.</span>
</footer>

</body>
</html>
