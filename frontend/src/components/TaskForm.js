// src/components/TaskForm.js
import React, { useState, useEffect } from 'react';
import {
  Form,
  Button,
  Spinner,
  Modal,
  OverlayTrigger,
  Tooltip,
  InputGroup
} from 'react-bootstrap';
import axios from 'axios';
import { toast } from 'react-toastify';
import { FaTrash } from 'react-icons/fa';

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
  const formattedDueDate = (taskData && taskData.due_date)
    ? new Date(taskData.due_date).toISOString().split('T')[0]
    : '';

  // If 'stage_id' is missing or invalid, store as string
  const [formData, setFormData] = useState({
    task_name: taskData ? taskData.task_name : '',
    description: taskData ? (taskData.description || '') : '',
    due_date: formattedDueDate,
    priority: taskData ? (taskData.priority || 'Medium') : 'Medium',
    is_completed: taskData ? taskData.is_completed : false,
    stage_id: initialStageId || '', // store as string
    assigned_users: taskData && taskData.assigned_users
      ? taskData.assigned_users.map(u => String(u.user_id))
      : [],
    documents: (taskData && taskData.documents)
      ? taskData.documents.map(d => d.document_id)
      : [],
  });

  const [isSubmitting, setIsSubmitting] = useState(false);
  const [allDocuments, setAllDocuments] = useState([]);
  const [newFile, setNewFile] = useState(null);

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

  // For normal fields
  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;

    let newValue;
    if (type === 'checkbox') {
      newValue = checked;
    } else if (name === 'stage_id') {
      // store stage as string
      newValue = value;
    } else {
      newValue = value;
    }

    setFormData(prev => ({ ...prev, [name]: newValue }));
  };

  // For multiple assigned users
  const handleAssigneesChange = (e) => {
    const selectedOptions = Array.from(e.target.selectedOptions);
    const selectedUserIds = selectedOptions.map(opt => opt.value);
    setFormData(prev => ({ ...prev, assigned_users: selectedUserIds }));
  };

  // For multiple documents
  const handleDocumentSelectChange = (e) => {
    const selectedOptions = Array.from(e.target.selectedOptions);
    const selectedDocIds = selectedOptions.map(opt => parseInt(opt.value, 10));
    setFormData(prev => ({ ...prev, documents: selectedDocIds }));
  };

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
      // any additional form fields for tags, etc.

      const response = await axios.post(`${process.env.REACT_APP_API_URL}/documents`, fd, {
        headers: { Authorization: `Bearer ${token}` },
      });
      const uploadedDoc = response.data;

      // Add to doc list
      setAllDocuments(prev => [...prev, uploadedDoc]);
      // Attach to form
      setFormData(prev => ({
        ...prev,
        documents: [...prev.documents, uploadedDoc.document_id],
      }));
      toast.success('Document uploaded and attached!');
      setNewFile(null);
    } catch (error) {
      console.error('Error uploading document:', error);
      toast.error('Failed to upload document.');
    } finally {
      setIsSubmitting(false);
    }
  };

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

  const handleSubmit = async (e) => {
    e.preventDefault();

    // convert stage_id to a number
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

      const submissionAssigned = formData.assigned_users.map(u => parseInt(u, 10));

      const submissionData = {
        ...formData,
        stage_id: stageIdNum,
        project_id: parseInt(projectId, 10),
        assigned_users: submissionAssigned,
      };

      // Clean up empty fields
      if (!submissionData.due_date) delete submissionData.due_date;
      if (!submissionData.description?.trim()) delete submissionData.description;

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

      onSubmit(formData);
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

  // Document dropdown option with a tooltip
  const renderDocumentOption = (doc) => {
    const tag = doc.tags && doc.tags.length > 0 ? doc.tags[0] : '(No Tag)';
    const filename = doc.original_filename || doc.file_name;
    const uploadedBy = doc.uploaded_by || 'Unknown user';
    const uploadDate = doc.uploaded_date ? new Date(doc.uploaded_date).toLocaleString() : 'Unknown date';

    return (
      <OverlayTrigger
        key={doc.document_id}
        placement="right"
        overlay={
          <Tooltip>
            {filename}<br/>
            Uploaded by: {uploadedBy}<br/>
            On: {uploadDate}
          </Tooltip>
        }
      >
        <option value={doc.document_id}>{tag}</option>
      </OverlayTrigger>
    );
  };

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
          {stages.map((stage) => (
            <option key={stage.stage_id} value={String(stage.stage_id)}>
              {stage.stage_name}
            </option>
          ))}
        </Form.Select>
      </Form.Group>

      <Form.Group controlId="assigned_users" className="mb-3">
        <Form.Label>Assign To (optional)</Form.Label>
        <Form.Control
          as="select"
          multiple
          name="assigned_users"
          value={formData.assigned_users}
          onChange={handleAssigneesChange}
        >
          {collaborators.map((c) => {
            const firstName = c.user?.first_name || '';
            const lastName = c.user?.last_name || '';
            const name = `${firstName} ${lastName}`.trim() || 'Unknown User';
            const roleLabel = getRoleLabel(c.role);
            return (
              <option key={c.collaborator_id} value={String(c.user_id)}>
                {name} ({roleLabel})
              </option>
            );
          })}
        </Form.Control>
      </Form.Group>

      {/* Documents multi-select */}
      <Form.Group controlId="documents" className="mb-3">
        <Form.Label>Attach Documents</Form.Label>
        {allDocuments.length === 0 ? (
          <>
            <Form.Control as="select" multiple disabled>
              <option>No documents available.</option>
            </Form.Control>
            <Form.Text className="text-muted">
              Go to <strong>Documents</strong> page to upload.
            </Form.Text>
          </>
        ) : (
          <Form.Control
            as="select"
            multiple
            name="documents"
            value={formData.documents.map(id => String(id))}
            onChange={handleDocumentSelectChange}
          >
            {allDocuments.map(renderDocumentOption)}
          </Form.Control>
        )}
      </Form.Group>

      <Form.Group controlId="uploadNewDoc" className="mb-3">
        <Form.Label>Upload New Document (optional)</Form.Label>
        <InputGroup>
          <Form.Control type="file" onChange={handleFileChange} />
          <Button variant="outline-secondary" onClick={handleUploadNewDoc} disabled={isSubmitting || !newFile}>
            {isSubmitting ? 'Uploading...' : 'Upload'}
          </Button>
        </InputGroup>
      </Form.Group>

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
          ) : mode === 'edit' ? 'Save Changes' : 'Create Task'}
        </Button>
      </div>
    </Form>
  );

  if (isModal) {
    return (
      <Modal show onHide={onCancel} size="lg">
        <Modal.Header closeButton>
          <Modal.Title>{mode === 'edit' ? 'Edit Task' : 'Add Task'}</Modal.Title>
        </Modal.Header>
        <Modal.Body>{formContent}</Modal.Body>
      </Modal>
    );
  }

  return (
    <div className="task-form-page">
      <h2>{mode === 'edit' ? 'Edit Task' : 'Add Task'}</h2>
      {formContent}
    </div>
  );
}

export default TaskForm;