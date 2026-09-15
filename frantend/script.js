const API_URL = "http://localhost:8080/api/journal";

let allEntries = [];

// Initialize on load
document.addEventListener('DOMContentLoaded', () => {
    loadThemeFromStorage();
    loadEntries();
});

/* LOAD THEME FROM STORAGE */
function loadThemeFromStorage() {
    const isDark = localStorage.getItem('journalDarkTheme') === 'true';
    if (isDark) {
        document.body.classList.add('dark-theme');
    }
}

/* THEME TOGGLE */
function toggleTheme() {
    document.body.classList.toggle('dark-theme');
    const isDark = document.body.classList.contains('dark-theme');
    localStorage.setItem('journalDarkTheme', isDark);
}

/* SETTINGS MODAL */
function showSettings() {
    window.location.href = "settings.html";
}



/* LOAD ENTRIES */
async function loadEntries() {
    try {
        const res = await fetch(API_URL, { credentials: 'include' });
        const data = await res.json();

        // Sort by newest first by default
        allEntries = data.sort((a, b) => new Date(b.date) - new Date(a.date));

        renderEntries(allEntries);
        updateStats();
    } catch (error) {
        console.error("Error loading entries:", error);
        document.getElementById("emptyState").style.display = "block";
    }
}

/* UPDATE STATS */
function updateStats() {
    document.getElementById('totalEntries').textContent = allEntries.length;

    if (allEntries.length > 0) {
        const latestDate = new Date(allEntries[0].date);
        document.getElementById('latestDate').textContent = formatDate(latestDate);
    } else {
        document.getElementById('latestDate').textContent = '-';
    }
}

/* FORMAT DATE */
function formatDate(date) {
    const options = { month: 'short', day: 'numeric', year: 'numeric' };
    return date.toLocaleDateString('en-US', options);
}

/* RENDER ENTRIES */
function renderEntries(entries) {
    const container = document.getElementById("entries");
    const emptyState = document.getElementById("emptyState");

    container.innerHTML = "";

    if (entries.length === 0) {
        emptyState.style.display = "block";
        return;
    }

    emptyState.style.display = "none";

    entries.forEach((entry, index) => {
        const div = document.createElement("div");
        div.className = "entry";
        div.style.animationDelay = `${index * 0.05}s`;

        const date = entry.date ? new Date(entry.date) : new Date();

        div.innerHTML = `
            <h3>${entry.title}</h3>
            <p>${entry.content}</p>
            <div class="entry-footer">${formatDate(date)}</div>
            <button class="delete-btn" onclick="deleteEntry(${entry.id})">
                <svg viewBox="0 0 24 24" fill="currentColor">
                    <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                </svg>
                Delete
            </button>
        `;

        container.appendChild(div);
    });
}

/* FILTER ENTRIES (Search) */
function filterEntries() {
    const searchTerm = document.getElementById('searchInput').value.toLowerCase();

    const filtered = allEntries.filter(entry => {
        return entry.title.toLowerCase().includes(searchTerm) ||
               entry.content.toLowerCase().includes(searchTerm);
    });

    renderEntries(filtered);
}

/* SORT ENTRIES */
function sortEntries() {
    const sortBy = document.getElementById('sortSelect').value;

    let sorted = [...allEntries];

    switch (sortBy) {
        case 'newest':
            sorted.sort((a, b) => new Date(b.date) - new Date(a.date));
            break;
        case 'oldest':
            sorted.sort((a, b) => new Date(a.date) - new Date(b.date));
            break;
        case 'title':
            sorted.sort((a, b) => a.title.localeCompare(b.title));
            break;
    }

    renderEntries(sorted);
}

/* ADD ENTRY */
async function addEntry() {
    const title = document.getElementById("title").value;
    const content = document.getElementById("content").value;

    if (!title || !content) {
        alert("Please fill all fields");
        return;
    }

    await fetch(API_URL, {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        credentials: 'include',
        body: JSON.stringify({ title, content })
    });

    document.getElementById("title").value = "";
    document.getElementById("content").value = "";

    closeModal();
    loadEntries();
}

/* DELETE ENTRY */
async function deleteEntry(id) {
    if (confirm('Are you sure you want to delete this entry?')) {
        await fetch(`${API_URL}/${id}`, {
            method: "DELETE",
            credentials: 'include'
        });
        loadEntries();
    }
}

/* MODAL FUNCTIONS */
function openModal() {
    document.getElementById("modal").classList.add("active");
}

function closeModal() {
    document.getElementById("modal").classList.remove("active");
}

/* AUTO EXPAND TEXTAREA */
function autoExpand(textarea) {
    textarea.style.height = "auto";
    textarea.style.height = textarea.scrollHeight + "px";
}

/* INIT */
loadEntries();