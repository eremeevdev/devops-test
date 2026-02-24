# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a DevOps test assignment containing a simple distributed application with a Go backend API and a static HTML frontend. The goal is to deploy both services using Nginx as a web server and reverse proxy.

**Key Characteristics**:
- **Backend**: Simple HTTP API server written in Go (port 8090)
- **Frontend**: Static HTML/CSS/JavaScript single-page application
- **No external dependencies**: Backend uses only Go stdlib; frontend is pure HTML/JS
- **No database**: Application is stateless with in-memory data generation

## Architecture

### Directory Structure

```
.
├── backend/              # Go HTTP server
│   ├── main.go          # Main application code
│   ├── go.mod           # Go module definition (go 1.25.0)
│   ├── Makefile         # Build and run targets
│   └── backend-app-linux # Prebuilt Linux binary
│
├── frontend/            # Static web application
│   ├── index.html       # Main HTML page
│   └── static/          # Static assets (SVG, CSS, etc.)
│
└── README.md            # Original task specification (in Russian)
```

### Backend (`/backend`)

**Purpose**: HTTP API server that responds to `/api/v1/text` with random JSON text responses.

**Key Endpoints**:
- `GET /api/v1/text` - Returns JSON with structure: `{"text": "random text string"}`

**How it Works**:
- Single endpoint handler `textHandler()` returns one of four hardcoded text strings randomly
- Uses `math/rand` seeded with current Unix timestamp
- No graceful shutdown or signal handling implemented

**Building**:
- Local: `make build` or `make` (produces `backend-app`)
- Linux amd64: `make build-linux` (produces `backend-app-linux`)
- Direct: `go build -o backend-app main.go`

**Running**:
- `make run` - Starts server on port 8090
- Direct: `go run main.go`
- Binary: `./backend-app-linux` (ensure executable permissions)

### Frontend (`/frontend`)

**Purpose**: Static single-page application that loads a logo and displays text from the backend API.

**Key Files**:
- `index.html` - Embedded HTML, CSS, and JavaScript (no build step needed)
  - Displays a centered container with logo and API response text
  - Makes fetch request to `/api/v1/text` on page load
  - Expects Nginx to proxy `/api/*` requests to backend

**Static Assets**:
- Located in `static/` directory (currently just `placeholder.svg`)
- Served as-is by Nginx

**Important**: The frontend expects the backend API to be accessible at `/api/v1/text` (not `http://localhost:8090/api/v1/text`). This requires Nginx reverse proxy configuration.

## Common Commands

### Backend Development

```bash
# Build for current OS
cd backend && make build

# Build for Linux deployment
cd backend && make build-linux

# Run locally during development
cd backend && make run

# Clean build artifacts
cd backend && make clean

# Direct Go commands (useful for debugging)
cd backend && go run main.go
cd backend && go build -o backend-app main.go
```

### Frontend Development

No build step required. Simply open `frontend/index.html` in a browser or serve via Nginx.

## Deployment Overview

The task requires:
1. Serve the frontend (static files from `/frontend` directory) on the root path `/`
2. Proxy API requests from `/api/*` to the backend running on `localhost:8090`
3. Use Nginx as the web server and reverse proxy

**Typical Nginx Configuration**:
```nginx
server {
    listen 80;
    server_name _;

    # Serve frontend static files
    location / {
        root /path/to/frontend;
        try_files $uri $uri/ /index.html;
    }

    # Proxy API requests to backend
    location /api/ {
        proxy_pass http://localhost:8090;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## Important Notes

- **Backend**: Go 1.25.0 is required (check with `go version`)
- **Prebuilt binary**: `backend-app-linux` already exists in the backend directory for immediate deployment
- **No tests**: The codebase has no existing test files (add as needed for validation)
- **Error handling**: Frontend gracefully shows error messages if backend is unreachable
- **CORS**: Not configured; Nginx proxy handles all requests so CORS is not needed
