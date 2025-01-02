// Backend/controllers/documentController.js

const { Document, TaskDocument, User } = require('../models');
const logger = require('../logger');
const fs = require('fs');
const path = require('path');

/**
 * Upload a new document (file + optional tags).
 * The file is handled by Multer (see documentRoutes.js).
 */
exports.uploadDocument = async (req, res) => {
  try {
    const userId = req.user.id;

    if (!req.file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }

    // This is the hashed/extended filename we produced in the Multer storage function
    const fileNameOnDisk = req.file.filename;  
    // The user’s original name, e.g. "mydoc.pdf"
    const originalName = req.file.originalname; 

    // Build a full URL, so the front-end knows where to fetch/preview
    // e.g. "http://localhost:5001/uploads/abc123.pdf"
    const fileUrl = `http://localhost:5001/uploads/${fileNameOnDisk}`;

    // Convert tags to an array if user sends one vs. multiple
    const tags = req.body.tags
      ? Array.isArray(req.body.tags) ? req.body.tags : [req.body.tags]
      : [];

    // Optionally fetch the user’s name for "uploaded_by"
    const user = await User.findByPk(userId);
    const userFullName = user
      ? `${user.first_name || ''} ${user.last_name || ''}`.trim() || `User#${user.user_id}`
      : `User#${userId}`;

    // Create the Document record in DB
    const doc = await Document.create({
      owner_id: userId,
      file_name: fileNameOnDisk,      // e.g. "abc123.pdf"
      original_filename: originalName, // The user’s real filename
      file_url: fileUrl, 
      tags,
      uploaded_by: userFullName,
      uploaded_date: new Date(),
    });

    res.status(201).json(doc);
  } catch (error) {
    logger.error(`Error uploading document: ${error.message}`, error);
    res.status(500).json({ error: 'Error uploading document' });
  }
};

/**
 * List all documents belonging to the current user.
 */
exports.getAllDocuments = async (req, res) => {
  try {
    const userId = req.user.id;
    const docs = await Document.findAll({
      where: { owner_id: userId },
      order: [['created_at', 'DESC']],
    });
    res.status(200).json(docs);
  } catch (error) {
    logger.error(`Error fetching documents: ${error.message}`, error);
    res.status(500).json({ error: 'Failed to fetch documents' });
  }
};

/**
 * Update a document's metadata (tags, original_filename, etc.).
 * We do NOT re-upload the file in this route.
 */
exports.updateDocument = async (req, res) => {
  try {
    const userId = req.user.id;
    const { document_id } = req.params;
    logger.info(`User ${userId} updating doc_id=${document_id} with data: ${JSON.stringify(req.body)}`);

    // Attempt to find the doc
    const doc = await Document.findOne({
      where: { document_id, owner_id: userId },
    });
    if (!doc) {
      logger.warn(`Doc not found or not owned by user: doc_id=${document_id}, user_id=${userId}`);
      return res.status(404).json({ error: 'Document not found or not yours' });
    }

    // Extract fields user can update
    const { tags, original_filename } = req.body;

    if (tags !== undefined) {
      let tagsArray = tags;
      if (!Array.isArray(tags)) {
        tagsArray = [tags];
      }
      doc.tags = tagsArray;
    }

    if (original_filename !== undefined) {
      doc.original_filename = original_filename.trim();
    }

    await doc.save();
    logger.info(`Document updated successfully: doc_id=${document_id}`);
    res.status(200).json(doc);
  } catch (error) {
    logger.error(`Error updating document: ${error.message}`, error);
    res.status(500).json({ error: 'Error updating document' });
  }
};

/**
 * Delete a document. Also removes references from TaskDocument.
 */
exports.deleteDocument = async (req, res) => {
  try {
    const userId = req.user.id;
    const { document_id } = req.params;
    logger.info(`User ${userId} deleting doc_id=${document_id}`);

    // Check if doc belongs to the user
    const doc = await Document.findOne({
      where: { document_id, owner_id: userId },
    });
    if (!doc) {
      logger.warn(`Doc not found or not owned by user: doc_id=${document_id}, user_id=${userId}`);
      return res.status(404).json({ error: 'Document not found or not yours' });
    }

    // Optionally remove the file from disk
    // if your "file_name" is e.g. "abc123.pdf"
    // const filePath = path.join(__dirname, '..', 'uploads', doc.file_name);
    // if (fs.existsSync(filePath)) fs.unlinkSync(filePath);

    // Remove references in TaskDocument, if any
    await TaskDocument.destroy({ where: { document_id: doc.document_id } });

    // Finally remove the doc record
    await doc.destroy();
    logger.info(`Document doc_id=${document_id} deleted successfully by user ${userId}`);
    res.status(200).json({ message: 'Document deleted successfully' });
  } catch (error) {
    logger.error(`Error deleting document: ${error.message}`, error);
    res.status(500).json({ error: 'Error deleting document' });
  }
};