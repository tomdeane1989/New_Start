// Backend/routes/documentRoutes.js
const express = require('express');
const router = express.Router();
const { 
  uploadDocument, 
  getAllDocuments, 
  updateDocument, 
  deleteDocument 
} = require('../controllers/documentController');
const authMiddleware = require('../middleware/authMiddleware');

// Import Multer and additional modules
const multer = require('multer');
const path = require('path');
const crypto = require('crypto');

// Multer: custom diskStorage
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    // Save to the 'uploads/' folder (relative to your server root).
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    // Derive the extension from the original file name
    const ext = path.extname(file.originalname).toLowerCase(); 
    // Create a random 16-byte hex string
    const base = crypto.randomBytes(16).toString('hex'); 
    // Combine them. e.g. "abc123... .pdf"
    const finalFilename = base + ext; 
    cb(null, finalFilename);
  },
});

// Initialize the Multer middleware with our custom storage
const upload = multer({ storage });

/**
 * All these routes are behind authMiddleware
 */
router.use(authMiddleware);

/**
 * POST /api/documents
 * => upload a new document with correct extension
 */
router.post('/', upload.single('file'), uploadDocument);

/**
 * GET /api/documents
 * => list the user's documents
 */
router.get('/', getAllDocuments);

/**
 * PUT /api/documents/:document_id
 * => update doc's metadata (tags, original_filename, etc)
 */
router.put('/:document_id', updateDocument);

/**
 * DELETE /api/documents/:document_id
 * => permanently remove the doc
 */
router.delete('/:document_id', deleteDocument);

module.exports = router;