# Stage 1: Build
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app
# Copy the POM first so dependency resolution is cached until the POM changes.
COPY pom.xml .
RUN mvn -B dependency:go-offline
COPY src ./src
RUN mvn -B clean package -DskipTests

# Stage 2: Run
FROM eclipse-temurin:17-jdk-jammy

# Runtime tools: wget for the healthcheck, and a non-root account to run the app.
RUN apt-get update \
    && apt-get install -y --no-install-recommends wget \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --system app \
    && useradd --system --gid app --home-dir /app app

WORKDIR /app
COPY --from=build /app/target/*.war app.war

# SQLite database and uploaded photos are mutable state, so keep them under
# directories that are owned by the app user and meant to be mounted as volumes.
RUN mkdir -p /app/data /app/uploads && chown -R app:app /app

USER app

# Store the SQLite file on the data volume and uploads on their own volume.
ENV SPRING_DATASOURCE_URL="jdbc:sqlite:/app/data/journal.db" \
    APP_UPLOAD_DIR="/app/uploads" \
    JAVA_OPTS="-XX:MaxRAMPercentage=75"

EXPOSE 8081

HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
    CMD wget -qO- http://localhost:8081/health_check || exit 1

ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar app.war"]