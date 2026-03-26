# Stage 1: React Client bauen
FROM node:22-alpine AS client-builder
WORKDIR /app/client
COPY client/package*.json ./
RUN npm ci
COPY client/ ./
RUN npm run build

# Stage 2: Produktions-Server
FROM node:22-alpine

WORKDIR /app

# Server-Dependencies installieren (better-sqlite3 braucht Build-Tools)
COPY server/package*.json ./
RUN apk add --no-cache python3 make g++ && \
    npm ci --production && \
    apk del python3 make g++

# Server-Code kopieren
COPY server/ ./

# Gebauten Client kopieren
COPY --from=client-builder /app/client/dist ./public

# Fonts für PDF-Export kopieren
COPY --from=client-builder /app/client/public/fonts ./public/fonts

# Verzeichnisse erstellen (support both old and new structure via env vars)
RUN mkdir -p /app/data /app/data/uploads/files /app/data/uploads/covers /app/data/uploads/photos /app/data/uploads/avatars

# Umgebung setzen - can override UPLOADS_DIR to use /app/data/uploads
ENV NODE_ENV=production
ENV PORT=3000
ENV DATA_DIR=/app/data
# Default: use /app/uploads for backward compatibility
# To consolidate, set: UPLOADS_DIR=/app/data/uploads

EXPOSE 3000

CMD ["node", "src/index.js"]
