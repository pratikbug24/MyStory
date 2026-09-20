// Relative URL: works on any host/port and avoids cross-origin requests entirely
const API_URL = "/api/journal";

let allEntries = [];
let currentFilter = '';

document.addEventListener('DOMContentLoaded', () => {
    initGreeting();
    renderModalDate();
    initModalKeys();
    loadEntries();
});

/* ---------- THEME ---------- */
// The theme lives on the User record (see the settings page). The dashboard
// posts the same endpoint so the two never disagree, and applies the change
// immediately rather than waiting for the redirect.
async function toggleTheme() {
    const isDark = !document.body.classList.contains('dark-theme');
    document.body.classList.toggle('dark-theme', isDark);

    try {
        const body = new URLSearchParams({ darkTheme: isDark, redirectTo: '/dashboard' });
        const res = await fetch('/settings/theme', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            credentials: 'include',
            body
        });
        if (!res.ok) throw new Error(`Request failed: ${res.status}`);
    } catch (error) {
        console.error('Error saving theme:', error);
        document.body.classList.toggle('dark-theme', !isDark);
    }
}

/* ---------- GREETING ---------- */
function initGreeting() {
    const name = document.getElementById('usernameDisplay').textContent.trim();
    const hour = new Date().getHours();

    let part = 'Good evening';
    if (hour < 12) part = 'Good morning';
    else if (hour < 18) part = 'Good afternoon';

    document.getElementById('greeting').textContent =
        name ? `${part}, ${name}` : part;

    // Only fall back to the initial when the server did not render a photo,
    // otherwise this would replace the user's uploaded avatar.
    const avatar = document.getElementById('userInitial');
    if (avatar && !avatar.querySelector('img')) {
        avatar.textContent = name ? name.charAt(0).toUpperCase() : '·';
    }

    document.getElementById('todayLine').textContent =
        new Date().toLocaleDateString('en-US', {
            weekday: 'long', month: 'long', day: 'numeric'
        });
}

/* ---------- DATE HELPERS ---------- */
function formatDate(date) {
    return date.toLocaleDateString('en-US', {
        month: 'short', day: 'numeric', year: 'numeric'
    });
}

function startOfDay(date) {
    return new Date(date.getFullYear(), date.getMonth(), date.getDate());
}

// "Today" / "Yesterday" read better than a bare date for recent entries
function relativeDay(date) {
    const days = Math.round((startOfDay(new Date()) - startOfDay(date)) / 86400000);
    if (days === 0) return 'Today';
    if (days === 1) return 'Yesterday';
    return null;
}

function escapeHtml(value) {
    return String(value == null ? '' : value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

function pluralize(count, word) {
    return `${count} ${word}${count === 1 ? '' : 's'}`;
}

/* ---------- LOAD ENTRIES ---------- */
async function loadEntries() {
    try {
        const res = await fetch(API_URL, { credentials: 'include' });
        if (!res.ok) throw new Error(`Request failed: ${res.status}`);

        const data = await res.json();
        allEntries = Array.isArray(data) ? data : [];

        applyView();
    } catch (error) {
        console.error('Error loading entries:', error);
        allEntries = [];
        showEmptyState('Could not load your entries',
            'Something went wrong reaching the server. Try refreshing the page.');
    }
}

/* Sort + filter, then render. Keeps the two controls from fighting
   over which set of entries is on screen. */
function applyView() {
    const sortBy = document.getElementById('sortSelect').value;
    const term = currentFilter.trim().toLowerCase();

    let view = term
        ? allEntries.filter(entry =>
            (entry.title || '').toLowerCase().includes(term) ||
            (entry.content || '').toLowerCase().includes(term))
        : [...allEntries];

    switch (sortBy) {
        case 'oldest':
            view.sort((a, b) => new Date(a.date) - new Date(b.date));
            break;
        case 'title':
            view.sort((a, b) => (a.title || '').localeCompare(b.title || ''));
            break;
        default:
            view.sort((a, b) => new Date(b.date) - new Date(a.date));
    }

    renderEntries(view);
    updateStats();
}

/* ---------- STATS ---------- */
function updateStats() {
    document.getElementById('totalEntries').textContent = allEntries.length;

    const words = allEntries.reduce((sum, entry) => {
        const text = `${entry.title || ''} ${entry.content || ''}`.trim();
        return sum + (text ? text.split(/\s+/).length : 0);
    }, 0);
    document.getElementById('statWords').textContent = words.toLocaleString();

    const now = new Date();
    const thisMonth = allEntries.filter(entry => {
        const d = new Date(entry.date);
        return d.getFullYear() === now.getFullYear() && d.getMonth() === now.getMonth();
    }).length;
    document.getElementById('statThisMonth').textContent = thisMonth;

    document.getElementById('statStreak').textContent = computeStreak();
}

/* Consecutive days written, counting back from today. An entry yesterday
   but none today keeps the streak alive until the day is over. */
function computeStreak() {
    if (allEntries.length === 0) return 0;

    const days = new Set(allEntries.map(entry => startOfDay(new Date(entry.date)).getTime()));
    const day = 86400000;
    const today = startOfDay(new Date()).getTime();

    let cursor = days.has(today) ? today : today - day;
    if (!days.has(cursor)) return 0;

    let streak = 0;
    while (days.has(cursor)) {
        streak++;
        cursor -= day;
    }
    return streak;
}

/* ---------- RENDER ---------- */
function showEmptyState(title, text) {
    document.getElementById('entries').innerHTML = '';
    document.getElementById('emptyTitle').textContent = title;
    document.getElementById('emptyText').textContent = text;
    document.getElementById('emptyState').style.display = 'block';
}

function renderEntries(entries) {
    const container = document.getElementById('entries');
    container.innerHTML = '';

    if (entries.length === 0) {
        const searching = currentFilter.trim().length > 0;
        showEmptyState(
            searching ? 'No matching entries' : 'Nothing here yet',
            searching
                ? `Nothing matched “${currentFilter.trim()}”. Try a different word.`
                : 'Every journal starts with a single page. Write your first entry to begin.'
        );
        return;
    }

    document.getElementById('emptyState').style.display = 'none';

    entries.forEach((entry, index) => {
        const date = entry.date ? new Date(entry.date) : new Date();
        const stamp = relativeDay(date);
        const words = (entry.content || '').trim().split(/\s+/).filter(Boolean).length;

        const card = document.createElement('article');
        card.className = 'db-entry';
        card.style.animationDelay = `${Math.min(index, 12) * 0.04}s`;

        card.innerHTML = `
            <p class="db-entry-date">${escapeHtml(stamp || formatDate(date))}</p>
            <h3>${escapeHtml(entry.title)}</h3>
            <p class="db-entry-body">${escapeHtml(entry.content)}</p>
            <div class="db-entry-foot">
                <span class="db-entry-meta">${escapeHtml(formatDate(date))} · ${escapeHtml(pluralize(words, 'word'))}</span>
                <button class="db-delete" type="button" onclick="deleteEntry(${entry.id})"
                        aria-label="Delete entry">
                    <svg viewBox="0 0 24 24" aria-hidden="true">
                        <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                    </svg>
                    Delete
                </button>
            </div>
        `;

        container.appendChild(card);
    });
}

/* ---------- SEARCH / SORT ---------- */
function filterEntries() {
    currentFilter = document.getElementById('searchInput').value;
    applyView();
}

function sortEntries() {
    applyView();
}

/* ---------- ADD ENTRY ---------- */
function setFormError(message) {
    const box = document.getElementById('formError');
    box.textContent = message || '';
    box.hidden = !message;
}

async function addEntry() {
    const titleInput = document.getElementById('title');
    const contentInput = document.getElementById('content');
    const title = titleInput.value.trim();
    const content = contentInput.value.trim();

    if (!title || !content) {
        setFormError('Both a title and some words are needed.');
        return;
    }

    const saveBtn = document.getElementById('saveBtn');
    saveBtn.disabled = true;
    saveBtn.textContent = 'Saving…';

    try {
        const res = await fetch(API_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            credentials: 'include',
            body: JSON.stringify({ title, content })
        });

        if (!res.ok) throw new Error(`Request failed: ${res.status}`);

        titleInput.value = '';
        contentInput.value = '';
        setFormError('');
        closeModal();
        await loadEntries();
    } catch (error) {
        console.error('Error saving entry:', error);
        setFormError('Could not save that entry. Please try again.');
    } finally {
        saveBtn.disabled = false;
        saveBtn.textContent = 'Save entry';
    }
}

/* ---------- DELETE ENTRY ---------- */
async function deleteEntry(id) {
    if (!confirm('Delete this entry? This cannot be undone.')) return;

    try {
        const res = await fetch(`${API_URL}/${id}`, {
            method: 'DELETE',
            credentials: 'include'
        });
        if (!res.ok) throw new Error(`Request failed: ${res.status}`);
        await loadEntries();
    } catch (error) {
        console.error('Error deleting entry:', error);
        alert('Could not delete that entry. Please try again.');
    }
}

/* ---------- MODAL ---------- */
function renderModalDate() {
    document.getElementById('modalDate').textContent =
        new Date().toLocaleDateString('en-US', {
            weekday: 'long', month: 'long', day: 'numeric'
        });
}

function openModal() {
    setFormError('');
    document.getElementById('modal').classList.add('active');
    document.getElementById('title').focus();
}

function closeModal() {
    document.getElementById('modal').classList.remove('active');
}

// Esc closes, Cmd/Ctrl+Enter saves — both are expected in a writing surface
function initModalKeys() {
    const modal = document.getElementById('modal');
    const content = document.getElementById('content');

    document.addEventListener('keydown', event => {
        if (!modal.classList.contains('active')) return;

        if (event.key === 'Escape') {
            closeModal();
        } else if (event.key === 'Enter' && (event.metaKey || event.ctrlKey)) {
            event.preventDefault();
            addEntry();
        }
    });

    content.addEventListener('keydown', event => {
        if (event.key === 'Enter' && (event.metaKey || event.ctrlKey)) {
            event.preventDefault();
            addEntry();
        }
    });
}
