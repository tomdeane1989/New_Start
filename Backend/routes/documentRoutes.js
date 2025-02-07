// Backend/routes/documentRoutes.js

const express = require('express');
const router = express.Router();
const { 
  uploadDocument, 
  getAllDocuments, 
  updateDocument, 
  deleteDocument,
  removeDocumentFromTask,
} = require('../controllers/documentController');
const authMiddleware = require('../middleware/authMiddleware');
const multer = require('multer');
const path = require('path');
const crypto = require('crypto');

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    const ext = path.extname(file.originalname).toLowerCase(); 
    const base = crypto.randomBytes(16).toString('hex'); 
    const finalFilename = base + ext; 
    cb(null, finalFilename);
  },
});
const upload = multer({ storage });

// All routes behind auth
router.use(authMiddleware);

// Upload new doc (with optional singleTag in body)
router.post('/', upload.single('file'), uploadDocument);

// List user’s docs
router.get('/', getAllDocuments);

// Update doc’s metadata
router.put('/:document_id', updateDocument);

// Delete doc from account
router.delete('/:document_id', deleteDocument);

/**
 * Remove doc from a specific task, but do NOT delete the doc from the account
 * DELETE /api/documents/:document_id/tasks/:task_id
 */
router.delete('/:document_id/tasks/:task_id', removeDocumentFromTask);

module.exports = router;