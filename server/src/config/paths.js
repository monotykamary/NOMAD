const path = require('path');

// Base directories - configurable via environment variables
const DATA_DIR = process.env.DATA_DIR || path.join(__dirname, '../data');
const UPLOADS_DIR = process.env.UPLOADS_DIR || path.join(__dirname, '../uploads');

// Subdirectories
const PHOTOS_DIR = path.join(UPLOADS_DIR, 'photos');
const FILES_DIR = path.join(UPLOADS_DIR, 'files');
const COVERS_DIR = path.join(UPLOADS_DIR, 'covers');
const AVATARS_DIR = path.join(UPLOADS_DIR, 'avatars');
const BACKUPS_DIR = path.join(DATA_DIR, 'backups');
const TMP_DIR = path.join(DATA_DIR, 'tmp');

module.exports = {
  DATA_DIR,
  UPLOADS_DIR,
  PHOTOS_DIR,
  FILES_DIR,
  COVERS_DIR,
  AVATARS_DIR,
  BACKUPS_DIR,
  TMP_DIR,
};
