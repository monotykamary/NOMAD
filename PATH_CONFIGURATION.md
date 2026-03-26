# Path Configuration Changes

## Overview

All file paths are now centralized in `server/src/config/paths.js` and can be configured via environment variables.

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DATA_DIR` | `/app/data` | Directory for database, backups, tmp files, JWT secret |
| `UPLOADS_DIR` | `/app/uploads` | Directory for user uploads (photos, files, covers, avatars) |

## Usage Options

### Option 1: Keep Separate Directories (Default / Backward Compatible)

This is the existing behavior - nothing changes unless you set the environment variables.

```yaml
# docker-compose.yml
volumes:
  - ./data:/app/data
  - ./uploads:/app/uploads
```

### Option 2: Consolidated Structure (Uploads inside Data)

To move uploads inside `/app/data/uploads`, set the `UPLOADS_DIR` environment variable:

```yaml
# docker-compose.yml
services:
  app:
    image: mauriceboe/nomad:latest
    environment:
      - DATA_DIR=/app/data
      - UPLOADS_DIR=/app/data/uploads   # <-- Key change
    volumes:
      - ./data:/app/data   # Single volume mount covers both
```

Or with `docker run`:

```bash
docker run -d --name nomad \
  -p 3000:3000 \
  -e DATA_DIR=/app/data \
  -e UPLOADS_DIR=/app/data/uploads \
  -v /opt/nomad/data:/app/data \
  --restart unless-stopped \
  mauriceboe/nomad:latest
```

## Directory Structure

### Default (Separate)
```
/app/
├── data/           # Database, backups, tmp, JWT secret
│   ├── travel.db
│   ├── backups/
│   ├── tmp/
│   └── .jwt_secret
└── uploads/        # User uploads
    ├── photos/
    ├── files/
    ├── covers/
    └── avatars/
```

### Consolidated
```
/app/
└── data/             # Everything
    ├── travel.db
    ├── backups/
    ├── tmp/
    ├── .jwt_secret
    └── uploads/      # User uploads inside data
        ├── photos/
        ├── files/
        ├── covers/
        └── avatars/
```

## Migration Guide

To migrate from separate directories to consolidated:

1. **Stop the container:**
   ```bash
   docker stop nomad
   ```

2. **Move uploads into data:**
   ```bash
   mv /opt/nomad/uploads /opt/nomad/data/uploads
   ```

3. **Update docker-compose.yml** (see Option 2 above)

4. **Start the container:**
   ```bash
   docker-compose up -d
   ```

## Files Modified

- `server/src/config/paths.js` (NEW) - Centralized path configuration
- `server/src/index.js` - Uses new path config
- `server/src/config.js` - Uses new path config
- `server/src/db/database.js` - Uses new path config
- `server/src/scheduler.js` - Uses new path config
- `server/src/routes/photos.js` - Uses new path config
- `server/src/routes/files.js` - Uses new path config
- `server/src/routes/trips.js` - Uses new path config
- `server/src/routes/auth.js` - Uses new path config
- `server/src/routes/collab.js` - Uses new path config
- `server/src/routes/backup.js` - Uses new path config
- `Dockerfile` - Updated comments about env vars
- `docker-compose.yml` - Shows both options

## Backward Compatibility

- Default paths remain unchanged (`/app/data` and `/app/uploads`)
- Existing installations continue to work without changes
- Only users who explicitly set `UPLOADS_DIR=/app/data/uploads` will use the consolidated structure
