// Backend/controllers/documentController.js

const db = require('../models');
const {
  Document,
  TaskDocument,
  User,
  Task,
  Project,
  ProjectCollaborator,
} = db;
const logger = require('../logger');
const fs = require('fs');
const path = require('path');

/**
 * Upload a new document (file + optional tags).
 * If you pass a singleTag in req.body, we push it to doc.tags
 */
exports.uploadDocument = async (req, res) => {
  try {
    const userId = req.user.id;

    if (!req.file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }

    // The hashed filename on disk
    const fileNameOnDisk = req.file.filename;
    // Original name from user
    const originalName = req.file.originalname;

    // Full URL for the doc
    const fileUrl = `http://localhost:5001/uploads/${fileNameOnDisk}`;

    // Convert tags from body.tags or singleTag
    let tags = [];
    if (req.body.tags) {
      // If multiple or single
      tags = Array.isArray(req.body.tags) ? req.body.tags : [req.body.tags];
    }
    if (req.body.singleTag && req.body.singleTag.trim() !== '') {
      tags.push(req.body.singleTag.trim());
    }

    // Determine who uploaded it
    const user = await User.findByPk(userId);
    const userFullName = user
      ? `${user.first_name || ''} ${user.last_name || ''}`.trim() || `User#${user.user_id}`
      : `User#${userId}`;

    // Create Document
    const doc = await Document.create({
      owner_id: userId,
      file_name: fileNameOnDisk,
      original_filename: originalName,
      file_url: fileUrl,
      tags,
      uploaded_by: userFullName,
      uploaded_date: new Date(),
    });

    logger.info(`User ${userId} uploaded document: doc_id=${doc.document_id}`);
    res.status(201).json(doc);
  } catch (error) {
    logger.error(`Error uploading document: ${error.message}`, error);
    res.status(500).json({ error: 'Error uploading document' });
  }
};

/**
 * Retrieve all documents the user can "see":
 * 1) Documents the user owns, and
 * 2) Documents attached to tasks the user can view (project owner or assigned with can_view).
 * If you prefer *only* the doc your user owns, revert to the old logic.
 */
exports.getAllDocuments = async (req, res) => {
  try {
    const userId = req.user.id;
    logger.info(`Fetching all docs visible to user ${userId}`);

    // 1) docs the user owns
    const userOwnedDocs = await Document.findAll({
      where: { owner_id: userId },
    });

    // 2) docs attached to tasks 
    //    - user is project owner or collaborator with awaiting_approval=false
    //    - user is assigned with can_view (and presumably awaiting_approval=false)
    const docsViaTasks = await Document.findAll({
      include: [
        {
          model: Task,
          as: 'tasks',
          required: true,
          include: [
            {
              model: Project,
              as: 'project',
              required: true,
              include: [
                {
                  model: ProjectCollaborator,
                  as: 'collaborators',
                  required: false,
                  where: {
                    user_id: userId,
                    awaiting_approval: false,
                  },
                },
              ],
            },
            {
              model: User,
              as: 'assigned_users',
              required: false,
              where: { user_id: userId },
              through: {
                where: {
                  can_view: true,
                  awaiting_approval: false,
                },
              },
            },
          ],
        },
      ],
    });

    // Merge the two arrays, remove duplicates
    const allDocs = [...userOwnedDocs, ...docsViaTasks];
    const uniqueMap = new Map();
    allDocs.forEach((doc) => {
      uniqueMap.set(doc.document_id, doc);
    });
    const results = Array.from(uniqueMap.values());

    res.status(200).json(results);
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
    logger.info(
      `User ${userId} updating doc_id=${document_id} with data: ${JSON.stringify(req.body)}`
    );

    // Find the doc
    const doc = await Document.findOne({
      where: { document_id, owner_id: userId },
    });
    if (!doc) {
      logger.warn(`Doc not found or not owned: doc_id=${document_id}, user_id=${userId}`);
      return res.status(404).json({ error: 'Document not found or not yours' });
    }

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
    logger.info(`Document updated: doc_id=${document_id}`);
    res.status(200).json(doc);
  } catch (error) {
    logger.error(`Error updating document: ${error.message}`, error);
    res.status(500).json({ error: 'Error updating document' });
  }
};

/**
 * Delete a document from the user's account entirely.
 * Also removes references from TaskDocument.
 */
exports.deleteDocument = async (req, res) => {
  try {
    const userId = req.user.id;
    const { document_id } = req.params;
    logger.info(`User ${userId} deleting doc_id=${document_id}`);

    // Check doc ownership
    const doc = await Document.findOne({
      where: { document_id, owner_id: userId },
    });
    if (!doc) {
      logger.warn(`Doc not found or not owned: doc_id=${document_id}, user_id=${userId}`);
      return res.status(404).json({ error: 'Document not found or not yours' });
    }

    // (Optional) remove file from disk
    // const filePath = path.join(__dirname, '..', 'uploads', doc.file_name);
    // if (fs.existsSync(filePath)) fs.unlinkSync(filePath);

    // Remove references in TaskDocument
    await TaskDocument.destroy({ where: { document_id: doc.document_id } });

    await doc.destroy();
    logger.info(`Document doc_id=${document_id} deleted from user ${userId}`);
    res.status(200).json({ message: 'Document deleted successfully' });
  } catch (error) {
    logger.error(`Error deleting document: ${error.message}`, error);
    res.status(500).json({ error: 'Error deleting document' });
  }
};

/**
 * Remove a document from a specific Task (without deleting the Document from the account).
 * Endpoint: DELETE /api/documents/:document_id/tasks/:task_id
 */
exports.removeDocumentFromTask = async (req, res) => {
  try {
    const userId = req.user.id;
    const { document_id, task_id } = req.params;
    logger.info(`User ${userId} removing doc_id=${document_id} from task_id=${task_id}`);

    // Find the doc
    const doc = await Document.findByPk(document_id);
    if (!doc) {
      logger.warn(`Document not found: doc_id=${document_id}`);
      return res.status(404).json({ error: 'Document not found' });
    }

    // Find the task (include project so we can verify ownership or assignment)
    const task = await Task.findByPk(task_id, {
      include: [
        {
          model: Project,
          as: 'project',
        },
      ],
    });
    if (!task) {
      logger.warn(`Task not found: task_id=${task_id}`);
      return res.status(404).json({ error: 'Task not found' });
    }

    // Must be the project owner OR have can_edit on this task
    let isAuthorized = false;

    if (task.project && task.project.owner_id === userId) {
      // project owner
      isAuthorized = true;
    } else {
      // check if user has can_edit in TaskAssignment
      const assignment = await task.getTaskAssignments({
        where: { user_id: userId, can_edit: true },
      });
      if (assignment && assignment.length > 0) {
        isAuthorized = true;
      }
    }

    if (!isAuthorized) {
      logger.warn(`User ${userId} not authorized to remove doc from task ${task_id}`);
      return res.status(403).json({ error: 'Insufficient permissions to remove document' });
    }

    // Remove from TaskDocument
    await TaskDocument.destroy({
      where: { task_id, document_id },
    });

    logger.info(`Document doc_id=${document_id} removed from task_id=${task_id}`);
    res.status(200).json({ message: 'Document removed from task' });
  } catch (error) {
    logger.error(`Error removing document from task: ${error.message}`, error);
    res.status(500).json({ error: 'Error removing document from task' });
  }
};