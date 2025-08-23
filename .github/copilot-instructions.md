# Copilot Instructions for `cataloguee`

## Project Overview
- **Purpose:** Product catalogue REST API for the "roboshop" project, exposing endpoints for product, category, and search operations.
- **Tech Stack:** Node.js (Express), MongoDB, Docker, Jenkins, AWS ECR, Instana for tracing.
- **Key Files:**
  - `server.js`: Main API server, MongoDB connection, REST endpoints.
  - `package.json`: Declares dependencies and versioning.
  - `Dockerfile`: Multi-stage build, runs as non-root user.
  - `db/master-data.js`: MongoDB seed data and indexes.
  - `Jenkinsfile`: CI/CD pipeline (npm install, Docker build/push, AWS ECR integration).

## Architecture & Patterns
- **API Endpoints:** `/products`, `/product/:sku`, `/products/:cat`, `/categories`, `/search/:text`, `/health`.
- **MongoDB:**
  - Uses `catalogue` DB, `products` collection.
  - Full-text and unique indexes created at seed time.
  - Connection auto-retries on failure.
- **Observability:** Instana tracing is initialized before all other imports.
- **Logging:** Uses `pino` and `express-pino-logger` for structured logs.
- **CORS:** All responses set `Access-Control-Allow-Origin: *`.

## Developer Workflows
- **Build & Run Locally:**
  - `npm install` then `node server.js` (requires MongoDB, default URL: `mongodb://mongodb:27017/catalogue`).
  - Seed DB with `db/master-data.js` (mongo shell).
- **Docker:**
  - Build: `docker build -t cataloguee:dev .`
  - Run: `docker run -e MONGO_URL=... -p 8080:8080 cataloguee:dev`
- **CI/CD:**
  - Jenkins pipeline reads version from `package.json`, builds and pushes Docker image to AWS ECR.
  - Credentials and region are set via environment variables in Jenkins.

## Conventions & Integration
- **Versioning:** Application version is sourced from `package.json` and used for Docker tags.
- **User:** Docker container runs as `roboshop` user for security.
- **Environment Variables:**
  - `MONGO_URL` (MongoDB connection)
  - `CATALOGUE_SERVER_PORT` (default: 8080)
  - `GO_SLOW` (optional, adds delay to product lookup)
- **Dependencies:**
  - Express, MongoDB, Pino, Instana, Body-Parser

## Examples
- To add a new endpoint, follow the pattern in `server.js` (see `/products/:cat`).
- To update DB schema, edit `db/master-data.js` and ensure indexes are created.
- For new CI steps, update `Jenkinsfile` using existing stages as reference.

---
If any section is unclear or missing, please provide feedback for further refinement.
