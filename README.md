📓 MyStory (Spring Boot + JSP + SQLite)

A full-stack Journal Management Application built using Spring Boot, JSP, and SQLite.
Users can register, log in, and manage their personal journal entries.

------------

🚀 Features

📝 Create, view, and delete journal entries

👤 User registration and login system

🔗 REST API + JSP-based UI

💾 SQLite database integration (via JPA/Hibernate)

🎨 Clean frontend using HTML, CSS, and JavaScript

-----------

🛠️ Tech Stack

Backend
- Java 17

* Spring Boot 2.7

- Spring Data JPA (Hibernate)

Frontend
- HTML5

- CSS3

- JavaScript (Fetch API)

- JSP (Java Server Pages)

Database

- SQLite (file-based, no server)
---------


📁 Project Structure
```
journalApp/
│
├── src/main/java/net/engineeringdigest/journalApp/
│   ├── controller/
│   ├── service/
│   ├── repository/
│   ├── entity/
│
├── src/main/webapp/WEB-INF/jsp/
│   ├── index.jsp
│   ├── add.jsp
│
├── src/main/resources/
│   └── application.properties
│
├── pom.xml
```

-----------------
📦 API Endpoints
```
Auth APIs
POST   /api/auth/register   → Create account
POST   /api/auth/login      → Log in (sets JWT cookie)
GET    /api/auth/check      → Check current session
POST   /api/auth/logout     → Log out (clears JWT cookie)

Journal APIs
GET    /api/journal        → Get all entries
POST   /api/journal        → Create entry
DELETE /api/journal/{id}   → Delete entry
```
-------

<p align="center">
  <h4>Home</h4>
  <img src="images/Home.png" />
  <h4>Dashboard</h4>
  <img src="images/dashboard.png" />
   <h4>Profile</h4>
  <img src="images/profile.png" />
</p>
-------



🔐 Authentication (JWT)

Authentication is backed by JSON Web Tokens (HS256, via [jjwt](https://github.com/jwtk/jjwt)).

How it works:

1. `POST /api/auth/login` (and the JSP `POST /login`) verifies the credentials and returns a
   signed token in an `HttpOnly`, `SameSite=Lax` cookie.
2. `JwtAuthFilter` reads that cookie — or an `Authorization: Bearer <token>` header — on every
   request, verifies the signature and expiry, and loads the matching user.
3. Tokens carry only the username (`sub`) and user id (`uid`), so nothing about the user can
   go stale. An invalid, tampered, or expired token authenticates nobody.
4. `POST /api/auth/logout` and `GET /logout` expire the cookie.

Relevant configuration in `application.properties`:
```
jwt.secret=${JWT_SECRET:dev-only-secret-change-me-8f2b1c4d9e6a7b3f5c0d2e4a6b8c1d3f}
jwt.expiration-ms=86400000
jwt.cookie-name=journal_jwt
jwt.cookie-secure=false
```

> ⚠️ **Set `JWT_SECRET` in production.** The bundled default is a development placeholder —
> anyone who knows it can mint valid tokens. Also set `jwt.cookie-secure=true` when serving
> over HTTPS so the cookie is only sent on encrypted connections.

The standalone pages in `frantend/` run on a different origin and authenticate with
credentials, so `WebConfig` enables credentialed CORS for the local dev origins.
-------
⚙️ Setup Instructions

1️⃣ Clone Repository
```
git clone https://github.com/pratikbug24/MyStory.git
cd MyStory
```
---------
2️⃣ Configure Database

No database server is required — the app uses an embedded SQLite file. The
database (`journal.db`) and uploads (`uploads/`) are created automatically on
first run, so there is nothing to configure.

------
3️⃣ Update application.properties (optional)

Defaults live in `src/main/resources/application.properties`. Override the JWT
secret in production, for example:
```
jwt.secret=${JWT_SECRET:dev-only-secret-change-me-8f2b1c4d9e6a7b3f5c0d2e4a6b8c1d3f}
```

4️⃣ Build Project
```
mvn clean install
```
5️⃣ Run Application
```
mvn spring-boot:run
```
OR
```
java -jar target/journalApp-0.0.1-SNAPSHOT.war
```
--------

Docker
------
The app is packaged as an executable WAR (JSP requires WAR packaging) and ships
with a multi-stage `Dockerfile` and a `docker-compose.yml`.

Run without cloning (prebuilt image)

Every push to `main` publishes the image to GitHub Container Registry, so anyone
can pull and run it directly:
```
docker run -d --name mystory -p 8081:8081 \
  -e JWT_SECRET=replace-with-a-long-random-string \
  -v mystory-data:/app/data \
  -v mystory-uploads:/app/uploads \
  ghcr.io/pratikbug24/mystory:latest
```
Then open http://localhost:8081. (If the package is private, run
`docker login ghcr.io` first.)

Build the image:
```
docker build -t mystory:latest .
```

Run with Compose (recommended). Provide the JWT secret via a `.env` file next to
`docker-compose.yml` (Compose reads it automatically, on every OS):
```
# .env
JWT_SECRET=replace-with-a-long-random-string
```
```
docker compose up -d --build
```
The app is then available on http://localhost:8081. The SQLite database and
uploaded photos persist in the `mystory-data` and `mystory-uploads` volumes.

Setting the secret inline differs per shell:
```
# bash / zsh
JWT_SECRET="$(openssl rand -hex 32)" docker compose up -d --build

# Windows PowerShell
$env:JWT_SECRET = openssl rand -hex 32
docker compose up -d --build

# Windows cmd.exe
set JWT_SECRET=replace-with-a-long-random-string
docker compose up -d --build
```

Run with plain Docker:
```
docker run -d --name mystory -p 8081:8081 \
  -e JWT_SECRET=replace-with-a-long-random-string \
  -v mystory-data:/app/data \
  -v mystory-uploads:/app/uploads \
  mystory:latest
```

Notes:
- The container listens on 8081. The SQLite file lives at `/app/data/journal.db`
  and uploads at `/app/uploads`; mount both so they survive restarts.
- Set `JWT_SECRET` to a strong random value, and `JWT_COOKIE_SECURE=true` when
  serving over HTTPS.
- Health check endpoint: `GET /health_check`.

--------

🧠 How It Works

- User interacts via JSP or frontend UI
- Request goes to Spring Boot Controller
- Service layer processes logic
- Repository communicates with database using JPA
- Hibernate converts Java objects → SQL queries

-------------------

🤝 Contributing

Feel free to fork this repo and improve the project!

--------
⭐ If you like this project, give it a star!
