// src/components/TaskForm.js
import React, { useState, useEffect } from 'react';
import {
  Form,
  Button,
  Spinner,
  Modal,
  OverlayTrigger,
  Tooltip,
  InputGroup,
  Badge,
} from 'react-bootstrap';
import axios from 'axios';
import { toast } from 'react-toastify';
import { FaTrash, FaEye, FaTimes } from 'react-icons/fa';

const roleMapping = [
  { value: 0, label: 'Buyer' },
  { value: 1, label: 'Seller' },
  { value: 2, label: 'Buyer Solicitor' },
  { value: 3, label: 'Seller Solicitor' },
  { value: 4, label: 'Estate Agent' },
  { value: 5, label: 'Mortgage Advisor' },
  { value: 6, label: 'Mortgage Vendor' },
  { value: 7, label: 'Deposit Gifter' },
];

function getRoleLabel(roleValue) {
  const found = roleMapping.find(r => r.value === roleValue);
  return found ? found.label : 'Unknown';
}

function TaskForm({
  mode,
  taskData,
  onSubmit,
  onCancel,
  stages,
  initialStageId,
  projectId,
  isModal = true,
  collaborators = [],
}) {
  // Format any existing due_date
  const formattedDueDate = (taskData && taskData.due_date)
    ? new Date(taskData.due_date).toISOString().split('T')[0]
    : '';

  /**
   * We'll store assignedUsers as an array of objects:
   *    { user_id, can_edit }
   * By default, can_edit = true. We'll keep it simple for now.
   */
  const [assignedUsers, setAssignedUsers] = useState(() => {
    if (!taskData || !taskData.assigned_users) return [];
    // If your taskData.assigned_users doesn't have can_edit info yet,
    // we'll default them to { user_id, can_edit: true } just to avoid confusion
    return taskData.assigned_users.map(u => {
      // If your API already returns can_edit, you can read it directly
      const canEdit = (u.TaskAssignment && typeof u.TaskAssignment.can_edit === 'boolean')
        ? u.TaskAssignment.can_edit
        : true; // default fallback

      return {
        user_id: u.user_id,
        can_edit: canEdit,
      };
    });
  });

  // Basic form data
  const [formData, setFormData] = useState({
    task_name: taskData ? taskData.task_name : '',
    description: taskData ? (taskData.description || '') : '',
    due_date: formattedDueDate,
    priority: taskData ? (taskData.priority || 'Medium') : 'Medium',
    is_completed: taskData ? taskData.is_completed : false,
    stage_id: initialStageId || '',
    documents: (taskData && taskData.documents)
      ? taskData.documents.map(d => d.document_id)
      : [],
  });

  const [isSubmitting, setIsSubmitting] = useState(false);
  const [allDocuments, setAllDocuments] = useState([]);

  // For uploading a doc
  const [newFile, setNewFile] = useState(null);
  const [newFileTag, setNewFileTag] = useState('');

  // For adding an existing doc
  const [pendingDocId, setPendingDocId] = useState('');

  // Document preview modal
  const [previewDoc, setPreviewDoc] = useState(null);
  const [showDocPreview, setShowDocPreview] = useState(false);

  // For adding an assignee
  const [candidateUserId, setCandidateUserId] = useState('');

  useEffect(() => {
    fetchAllDocuments();
  }, []);

  const fetchAllDocuments = async () => {
    try {
      const token = localStorage.getItem('jwtToken');
      if (!token) return;
      const response = await axios.get(`${process.env.REACT_APP_API_URL}/documents`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setAllDocuments(response.data);
    } catch (error) {
      console.error('Error fetching documents:', error);
      toast.error('Failed to fetch documents.');
    }
  };

  // Basic field changes
  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    let newValue;
    if (type === 'checkbox') {
      newValue = checked;
    } else {
      newValue = value;
    }
    setFormData(prev => ({ ...prev, [name]: newValue }));
  };

  // Add an assignee (default can_edit = true)
  const handleAddAssignee = () => {
    if (!candidateUserId) {
      toast.warn('Select a user from the dropdown to add.');
      return;
    }
    // Check if already assigned
    const existing = assignedUsers.find(a => String(a.user_id) === candidateUserId);
    if (existing) {
      toast.info('That user is already assigned.');
      return;
    }
    // Find collaborator for display name, if needed
    const collab = collaborators.find(c => String(c.user_id) === candidateUserId);
    if (!collab) {
      toast.error('Could not find collaborator with that user ID.');
      return;
    }
    // We'll just store user_id + can_edit = true
    setAssignedUsers(prev => [
      ...prev,
      {
        user_id: parseInt(candidateUserId, 10),
        can_edit: true, // default to true
      },
    ]);
    setCandidateUserId('');
  };

  const handleRemoveAssignee = (userId) => {
    setAssignedUsers(prev => prev.filter(a => a.user_id !== userId));
  };

  // Handle doc multi-select
  const handleAddExistingDoc = () => {
    if (!pendingDocId) {
      toast.warn('Select a document to add.');
      return;
    }
    const docIdNum = parseInt(pendingDocId, 10);
    if (formData.documents.includes(docIdNum)) {
      toast.info('That document is already attached.');
      return;
    }
    setFormData(prev => ({
      ...prev,
      documents: [...prev.documents, docIdNum],
    }));
    setPendingDocId('');
  };

  const handleRemoveDocument = (docId) => {
    setFormData(prev => ({
      ...prev,
      documents: prev.documents.filter(d => d !== docId),
    }));
  };

  // Document preview
  const showDocumentPreview = (docId) => {
    const doc = allDocuments.find(d => d.document_id === docId);
    if (!doc) {
      toast.error('Document not found.');
      return;
    }
    setPreviewDoc(doc);
    setShowDocPreview(true);
  };
  const closeDocPreview = () => {
    setPreviewDoc(null);
    setShowDocPreview(false);
  };

  // Upload new doc
  const handleFileChange = (e) => {
    if (e.target.files && e.target.files[0]) {
      setNewFile(e.target.files[0]);
    } else {
      setNewFile(null);
    }
  };

  const handleUploadNewDoc = async () => {
    if (!newFile) {
      toast.warn('No file selected.');
      return;
    }
    try {
      setIsSubmitting(true);
      const token = localStorage.getItem('jwtToken');
      if (!token) {
        toast.warn('You must be logged in to upload documents.');
        return;
      }
      const fd = new FormData();
      fd.append('file', newFile);
      if (newFileTag.trim()) {
        fd.append('singleTag', newFileTag.trim());
      }

      const response = await axios.post(`${process.env.REACT_APP_API_URL}/documents`, fd, {
        headers: { Authorization: `Bearer ${token}` },
      });
      const uploadedDoc = response.data;
      setAllDocuments(prev => [...prev, uploadedDoc]);
      setFormData(prev => ({
        ...prev,
        documents: [...prev.documents, uploadedDoc.document_id],
      }));
      toast.success('Document uploaded and attached!');
      setNewFile(null);
      setNewFileTag('');
    } catch (error) {
      console.error('Error uploading document:', error);
      toast.error('Failed to upload document.');
    } finally {
      setIsSubmitting(false);
    }
  };

  // Delete task (if editing)
  const handleDeleteTask = async () => {
    if (!taskData || !taskData.task_id) return;
    try {
      setIsSubmitting(true);
      const token = localStorage.getItem('jwtToken');
      if (!token) {
        toast.warn('You must be logged in to delete tasks.');
        return;
      }
      await axios.delete(`${process.env.REACT_APP_API_URL}/tasks/${taskData.task_id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      toast.success('Task deleted successfully!');
      onSubmit();
    } catch (error) {
      console.error('Error deleting task:', error);
      toast.error('Failed to delete task.');
    } finally {
      setIsSubmitting(false);
    }
  };

  // Submit the form
  const handleSubmit = async (e) => {
    e.preventDefault();
    const stageIdNum = formData.stage_id ? parseInt(formData.stage_id, 10) : null;
    if (!projectId || !stageIdNum || !formData.task_name || !formData.priority) {
      toast.warn('Please ensure Stage, Task Name, and Priority are set.');
      return;
    }
    setIsSubmitting(true);

    try {
      const token = localStorage.getItem('jwtToken');
      if (!token) {
        toast.warn('You must be logged in.');
        onCancel();
        return;
      }

      // Convert assigned users from state
      const submissionData = {
        task_name: formData.task_name,
        description: formData.description?.trim() || '',
        due_date: formData.due_date || undefined,
        priority: formData.priority,
        is_completed: formData.is_completed,
        stage_id: stageIdNum,
        project_id: parseInt(projectId, 10),
        documents: formData.documents,
        assigned_users: assignedUsers, // an array of { user_id, can_edit }
      };
      if (!submissionData.description) {
        delete submissionData.description;
      }

      if (mode === 'edit') {
        if (!taskData || !taskData.task_id) {
          toast.error('Invalid task data.');
          return;
        }
        await axios.put(
          `${process.env.REACT_APP_API_URL}/tasks/${taskData.task_id}`,
          submissionData,
          { headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' } }
        );
        toast.success('Task updated successfully!');
      } else {
        await axios.post(`${process.env.REACT_APP_API_URL}/tasks`, submissionData, {
          headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
        });
        toast.success('Task created successfully!');
      }

      onSubmit();
    } catch (error) {
      console.error('Error saving task:', error);
      if (error.response) {
        toast.error(
          `Failed to ${mode === 'edit' ? 'update' : 'create'} task: ${
            error.response.data.error || 'Unknown error.'
          }`
        );
      } else {
        toast.error(`Failed to ${mode === 'edit' ? 'update' : 'create'} task.`);
      }
    } finally {
      setIsSubmitting(false);
    }
  };

  // Renders assigned users as “chips”
  const renderAssignedUsersChips = () => {
    if (!assignedUsers.length) return null;
    return (
      <div className="mb-3">
        <Form.Label>Currently Assigned:</Form.Label>
        <div>
          {assignedUsers.map(a => {
            // For display, we might just show "User#ID (Edit Access)" or something
            const collaborator = collaborators.find(c => c.user_id === a.user_id);
            const firstName = collaborator?.user?.first_name || '';
            const lastName = collaborator?.user?.last_name || '';
            const nameLabel = (firstName || lastName)
              ? `${firstName} ${lastName}`
              : `User#${a.user_id}`;
            return (
              <Badge bg="info" text="dark" className="me-2 mb-2" key={a.user_id}>
                {nameLabel} {a.can_edit ? '(Edit)' : '(View only)'}
                <Button
                  variant="link"
                  size="sm"
                  className="text-danger ms-2 p-0"
                  onClick={() => handleRemoveAssignee(a.user_id)}
                >
                  <FaTimes />
                </Button>
              </Badge>
            );
          })}
        </div>
      </div>
    );
  };

  // Renders attached docs as “chips” with preview
  const renderAttachedDocs = () => {
    if (!formData.documents.length) return null;
    return (
      <div className="mb-3">
        <Form.Label>Attached Documents:</Form.Label>
        <div>
          {formData.documents.map(docId => {
            const doc = allDocuments.find(d => d.document_id === docId);
            if (!doc) return null;
            const label = doc.original_filename || doc.file_name;

            // Tooltip for doc
            const docTooltip = (
              <Tooltip id={`doc-tooltip-${docId}`}>
                {label}
                <br />
                Uploaded by: {doc.uploaded_by || 'Unknown'}
                <br />
                {doc.uploaded_date ? new Date(doc.uploaded_date).toLocaleString() : 'Unknown date'}
              </Tooltip>
            );

            return (
              <OverlayTrigger
                key={docId}
                placement="top"
                overlay={docTooltip}
              >
                <Badge bg="info" text="dark" className="me-2 mb-2">
                  <span
                    style={{ cursor: 'pointer' }}
                    onClick={() => showDocumentPreview(docId)}
                  >
                    {label} <FaEye />
                  </span>
                  <Button
                    variant="link"
                    size="sm"
                    className="text-danger ms-2 p-0"
                    onClick={(e) => {
                      e.stopPropagation();
                      handleRemoveDocument(docId);
                    }}
                  >
                    <FaTimes />
                  </Button>
                </Badge>
              </OverlayTrigger>
            );
          })}
        </div>
      </div>
    );
  };

  // Main form content
  const formContent = (
    <Form onSubmit={handleSubmit}>
      <Form.Group controlId="taskName" className="mb-3">
        <Form.Label>Task Name</Form.Label>
        <Form.Control
          type="text"
          name="task_name"
          value={formData.task_name}
          onChange={handleChange}
          required
        />
      </Form.Group>

      <Form.Group controlId="description" className="mb-3">
        <Form.Label>Description (optional)</Form.Label>
        <Form.Control
          as="textarea"
          name="description"
          value={formData.description}
          onChange={handleChange}
          rows={3}
        />
      </Form.Group>

      <Form.Group controlId="due_date" className="mb-3">
        <Form.Label>Due Date (optional)</Form.Label>
        <Form.Control
          type="date"
          name="due_date"
          value={formData.due_date}
          onChange={handleChange}
        />
      </Form.Group>

      <Form.Group controlId="priority" className="mb-3">
        <OverlayTrigger
          placement="right"
          overlay={<Tooltip>Higher priority tasks should be tackled first.</Tooltip>}
        >
          <Form.Label>Priority</Form.Label>
        </OverlayTrigger>
        <Form.Select
          name="priority"
          value={formData.priority}
          onChange={handleChange}
          required
        >
          <option value="Low">Low</option>
          <option value="Medium">Medium</option>
          <option value="High">High</option>
        </Form.Select>
      </Form.Group>

      <Form.Group controlId="is_completed" className="mb-3">
        <Form.Check
          type="checkbox"
          label="Completed"
          name="is_completed"
          checked={formData.is_completed}
          onChange={handleChange}
        />
      </Form.Group>

      <Form.Group controlId="stage_id" className="mb-3">
        <Form.Label>Stage</Form.Label>
        <Form.Select name="stage_id" value={formData.stage_id} onChange={handleChange} required>
          <option value="">Select Stage</option>
          {stages.map(stage => (
            <option key={stage.stage_id} value={String(stage.stage_id)}>
              {stage.stage_name}
            </option>
          ))}
        </Form.Select>
      </Form.Group>

      {/* Assigned Users */}
      {renderAssignedUsersChips()}

      <Form.Group className="mb-3" controlId="candidateUser">
        <Form.Label>Assign a Collaborator</Form.Label>
        <Form.Select
          value={candidateUserId}
          onChange={(e) => setCandidateUserId(e.target.value)}
        >
          <option value="">Select a collaborator</option>
          {collaborators.map(c => {
            const firstName = c.user?.first_name || '';
            const lastName = c.user?.last_name || '';
            const name = `${firstName} ${lastName}`.trim() || `User#${c.user_id}`;
            return (
              <option key={c.collaborator_id} value={String(c.user_id)}>
                {name} (User# {c.user_id})
              </option>
            );
          })}
        </Form.Select>
        <Button
          variant="outline-primary"
          size="sm"
          className="mt-2"
          onClick={handleAddAssignee}
        >
          Add
        </Button>
      </Form.Group>

      {/* Document Chips */}
      {renderAttachedDocs()}

      {/* Add an existing doc */}
      <Form.Group controlId="documents" className="mb-3">
        <Form.Label>Add Existing Document</Form.Label>
        <div className="d-flex align-items-center">
          <Form.Select
            value={pendingDocId}
            onChange={(e) => setPendingDocId(e.target.value)}
            style={{ maxWidth: '70%' }}
          >
            <option value="">Select Document</option>
            {allDocuments.map(doc => {
              const label = doc.original_filename || doc.file_name;
              return (
                <option key={doc.document_id} value={String(doc.document_id)}>
                  {label}
                </option>
              );
            })}
          </Form.Select>
          <Button
            variant="outline-primary"
            size="sm"
            className="ms-2"
            onClick={handleAddExistingDoc}
          >
            Add
          </Button>
        </div>
      </Form.Group>

      {/* Upload new doc */}
      <Form.Group controlId="uploadNewDoc" className="mb-3">
        <Form.Label>Upload New Document (optional)</Form.Label>
        <InputGroup className="mb-2">
          <Form.Control type="file" onChange={handleFileChange} />
        </InputGroup>
        <Form.Control
          type="text"
          placeholder="Tag (optional)"
          value={newFileTag}
          onChange={(e) => setNewFileTag(e.target.value)}
          className="mb-2"
        />
        <Button variant="outline-secondary" onClick={handleUploadNewDoc} disabled={isSubmitting || !newFile}>
          {isSubmitting ? 'Uploading...' : 'Upload'}
        </Button>
      </Form.Group>

      {/* Footer Buttons */}
      <div className="d-flex justify-content-end">
        {mode === 'edit' && taskData && taskData.task_id && (
          <Button
            variant="danger"
            className="me-auto"
            disabled={isSubmitting}
            onClick={handleDeleteTask}
          >
            <FaTrash className="me-2" />
            Delete Task
          </Button>
        )}
        <Button variant="secondary" onClick={onCancel} className="me-2">
          Cancel
        </Button>
        <Button variant="primary" type="submit" disabled={isSubmitting}>
          {isSubmitting ? (
            <>
              <Spinner as="span" animation="border" size="sm" className="me-2" />
              Saving...
            </>
          ) : (mode === 'edit' ? 'Save Changes' : 'Create Task')}
        </Button>
      </div>
    </Form>
  );

  // If using as a modal
  if (isModal) {
    return (
      <>
        <Modal show onHide={onCancel} size="lg">
          <Modal.Header closeButton>
            <Modal.Title>{mode === 'edit' ? 'Edit Task' : 'Add Task'}</Modal.Title>
          </Modal.Header>
          <Modal.Body>{formContent}</Modal.Body>
        </Modal>

        {/* Document Preview Modal */}
        <Modal show={showDocPreview} onHide={closeDocPreview} size="lg">
          <Modal.Header closeButton>
            <Modal.Title>
              {previewDoc
                ? (previewDoc.original_filename || previewDoc.file_name)
                : 'Document Preview'
              }
            </Modal.Title>
          </Modal.Header>
          <Modal.Body>
            {previewDoc?.file_url ? (
              previewDoc.file_url.toLowerCase().endsWith('.pdf') ? (
                <iframe
                  src={previewDoc.file_url}
                  title="PDF Preview"
                  style={{ width: '100%', height: '70vh' }}
                />
              ) : (
                <img
                  src={previewDoc.file_url}
                  alt="document"
                  style={{ maxWidth: '100%' }}
                />
              )
            ) : (
              <p>Unable to preview this document.</p>
            )}
          </Modal.Body>
        </Modal>
      </>
    );
  }

  // If not a modal
  return (
    <>
      <div className="task-form-page">
        <h2>{mode === 'edit' ? 'Edit Task' : 'Add Task'}</h2>
        {formContent}
      </div>

      {/* Document Preview Modal (non-modal usage) */}
      <Modal show={showDocPreview} onHide={closeDocPreview} size="lg">
        <Modal.Header closeButton>
          <Modal.Title>
            {previewDoc
              ? (previewDoc.original_filename || previewDoc.file_name)
              : 'Document Preview'
            }
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {previewDoc?.file_url ? (
            previewDoc.file_url.toLowerCase().endsWith('.pdf') ? (
              <iframe
                src={previewDoc.file_url}
                title="PDF Preview"
                style={{ width: '100%', height: '70vh' }}
              />
            ) : (
              <img
                src={previewDoc.file_url}
                alt="document"
                style={{ maxWidth: '100%' }}
              />
            )
          ) : (
            <p>Unable to preview this document.</p>
          )}
        </Modal.Body>
      </Modal>
    </>
  );
}

export default TaskForm;