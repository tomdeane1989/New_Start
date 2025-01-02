// src/pages/DocumentsPage.js
import React, { useEffect, useState } from 'react';
import {
  Container,
  Row,
  Col,
  Card,
  Form,
  Button,
  Spinner,
  Badge,
  OverlayTrigger,
  Tooltip,
  Modal,
} from 'react-bootstrap';
import { toast } from 'react-toastify';
import axios from 'axios';
import Header from '../components/Header';
import ConfirmModal from '../components/ConfirmModal'; // Reuse existing ConfirmModal
import { FaSearchPlus, FaTrash, FaEdit } from 'react-icons/fa';

// Default tags
const defaultTags = [
  'Proof of Identity',
  'Bank Statement',
  'Pay Slip',
  'Proof of Employment',
];

function DocumentsPage() {
  const [documents, setDocuments] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  // For uploading
  const [selectedFile, setSelectedFile] = useState(null);
  const [selectedTags, setSelectedTags] = useState([]);
  const [isUploading, setIsUploading] = useState(false);

  // Preview
  const [showPreview, setShowPreview] = useState(false);
  const [previewDoc, setPreviewDoc] = useState(null);

  // Delete
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [docToDelete, setDocToDelete] = useState(null);

  // Edit (update)
  const [showEditModal, setShowEditModal] = useState(false);
  const [docToEdit, setDocToEdit] = useState(null);
  const [editTags, setEditTags] = useState([]);
  const [editFilename, setEditFilename] = useState('');

  useEffect(() => {
    fetchDocuments();
  }, []);

  const fetchDocuments = async () => {
    try {
      setIsLoading(true);
      const token = localStorage.getItem('jwtToken');
      const response = await axios.get(`${process.env.REACT_APP_API_URL}/documents`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      setDocuments(response.data);
    } catch (error) {
      console.error('Error fetching documents:', error);
      toast.error('Failed to fetch documents.');
    } finally {
      setIsLoading(false);
    }
  };

  // ------------------ File Upload ------------------
  const handleFileChange = (e) => {
    if (e.target.files && e.target.files[0]) {
      setSelectedFile(e.target.files[0]);
    } else {
      setSelectedFile(null);
    }
  };

  const handleTagChange = (e) => {
    const sel = Array.from(e.target.selectedOptions).map(opt => opt.value);
    setSelectedTags(sel);
  };

  const handleUpload = async () => {
    if (!selectedFile) {
      toast.warn('No file selected.');
      return;
    }
    try {
      setIsUploading(true);
      const token = localStorage.getItem('jwtToken');

      const formData = new FormData();
      formData.append('file', selectedFile);
      selectedTags.forEach(tag => formData.append('tags', tag));

      const response = await axios.post(`${process.env.REACT_APP_API_URL}/documents`, formData, {
        headers: { Authorization: `Bearer ${token}` },
      });
      const uploadedDoc = response.data;
      toast.success('Document uploaded!');
      setDocuments(prev => [...prev, uploadedDoc]);
      setSelectedFile(null);
      setSelectedTags([]);
    } catch (error) {
      console.error('Error uploading document:', error);
      toast.error('Failed to upload document.');
    } finally {
      setIsUploading(false);
    }
  };

  // ------------------ Preview ------------------
  const isPDF = (url) => {
    // If your backend sets a .pdf extension, or correct content-type, a browser can preview inline
    return url.toLowerCase().endsWith('.pdf');
  };

  const handlePreviewClick = (doc) => {
    setPreviewDoc(doc);
    setShowPreview(true);
  };

  const handleClosePreview = () => {
    setShowPreview(false);
    setPreviewDoc(null);
  };

  // ------------------ Delete ------------------
  const handleDeleteClick = (doc) => {
    setDocToDelete(doc);
    setShowDeleteModal(true);
  };

  const confirmDeleteDocument = async () => {
    if (!docToDelete) return;
    try {
      const token = localStorage.getItem('jwtToken');
      await axios.delete(
        `${process.env.REACT_APP_API_URL}/documents/${docToDelete.document_id}`,
        { headers: { Authorization: `Bearer ${token}` } }
      );
      toast.success('Document deleted successfully!');
      setDocuments(prev => prev.filter(d => d.document_id !== docToDelete.document_id));
    } catch (error) {
      console.error('Error deleting document:', error);
      toast.error('Failed to delete document.');
    } finally {
      setDocToDelete(null);
      setShowDeleteModal(false);
    }
  };

  // ------------------ Edit (Update) ------------------
  const handleEditClick = (doc) => {
    setDocToEdit(doc);
    setEditFilename(doc.original_filename || doc.file_name || '');
    setEditTags(doc.tags || []);
    setShowEditModal(true);
  };

  const handleEditTagChange = (e) => {
    const sel = Array.from(e.target.selectedOptions).map(opt => opt.value);
    setEditTags(sel);
  };

  const handleSaveEdit = async () => {
    if (!docToEdit) return;
    try {
      const token = localStorage.getItem('jwtToken');
      // PUT request to update doc
      await axios.put(
        `${process.env.REACT_APP_API_URL}/documents/${docToEdit.document_id}`,
        {
          original_filename: editFilename,
          tags: editTags,
        },
        { headers: { Authorization: `Bearer ${token}` } }
      );
      toast.success('Document updated!');
      // Refresh the entire list
      fetchDocuments();
    } catch (error) {
      console.error('Error updating document:', error);
      toast.error('Failed to update document.');
    } finally {
      setShowEditModal(false);
      setDocToEdit(null);
    }
  };

  // ------------------ Tooltip Helper ------------------
  const renderDocTooltip = (doc) => {
    const user = doc.uploaded_by || 'Unknown user';
    const dateStr = doc.uploaded_date ? new Date(doc.uploaded_date).toLocaleString() : 'unknown date';
    const fullName = doc.original_filename || doc.file_name; // e.g. "mydoc.pdf" or "abc123.pdf"
    return (
      <Tooltip>
        {fullName}
        <br />
        Uploaded by: {user}
        <br />
        {dateStr}
      </Tooltip>
    );
  };

  // **This is the updated logic**: The Title is the "Name" of the file
  const renderDocTitle = (doc) => {
    // If doc.original_filename is present, use that, else fallback to doc.file_name
    const docTitle = doc.original_filename?.trim() 
      ? doc.original_filename 
      : doc.file_name;

    return (
      <OverlayTrigger placement="top" overlay={renderDocTooltip(doc)}>
        <span style={{ cursor: doc.file_url ? 'pointer' : 'default' }}>
          {docTitle}
        </span>
      </OverlayTrigger>
    );
  };

  // ------------------ Main Render ------------------
  return (
    <>
      <Header />
      <Container className="mt-4">
        <h1>Documents</h1>
        <Row className="mb-3">
          <Col md={6}>
            <Form.Group controlId="documentFile" className="mb-3">
              <Form.Label>Upload a new document</Form.Label>
              <Form.Control type="file" onChange={handleFileChange} />
            </Form.Group>
          </Col>
          <Col md={4}>
            <Form.Group controlId="tagsSelect" className="mb-3">
              <Form.Label>Tags (optional)</Form.Label>
              <Form.Control as="select" multiple value={selectedTags} onChange={handleTagChange}>
                {defaultTags.map(tag => (
                  <option key={tag} value={tag}>
                    {tag}
                  </option>
                ))}
              </Form.Control>
              <Form.Text className="text-muted">
                Hold Ctrl (Windows) or Cmd (Mac) to select multiple tags.
              </Form.Text>
            </Form.Group>
          </Col>
          <Col md={2} className="d-flex align-items-end">
            <Button variant="primary" onClick={handleUpload} disabled={isUploading}>
              {isUploading ? (
                <>
                  <Spinner as="span" animation="border" size="sm" className="me-2" />
                  Uploading...
                </>
              ) : (
                'Upload'
              )}
            </Button>
          </Col>
        </Row>

        {isLoading ? (
          <div className="text-center">
            <Spinner animation="border" role="status" />
            <p>Loading Documents...</p>
          </div>
        ) : documents.length === 0 ? (
          <p>No documents found.</p>
        ) : (
          <Row xs={1} md={2} lg={3} className="g-4">
            {documents.map((doc) => (
              <Col key={doc.document_id}>
                <Card className="h-100 d-flex flex-column">
                  <Card.Body className="d-flex flex-column">
                    <div className="d-flex justify-content-between align-items-center mb-2">
                      {/* Render name-based Title */}
                      <Card.Title className="m-0">
                        {renderDocTitle(doc)}
                      </Card.Title>
                      {doc.file_url && (
                        <FaSearchPlus
                          style={{ cursor: 'pointer' }}
                          onClick={() => handlePreviewClick(doc)}
                        />
                      )}
                    </div>

                    {/* Show tags (if any) below the name */}
                    <div className="mb-2">
                      {doc.tags && doc.tags.length > 0 ? (
                        doc.tags.map((t, idx) => (
                          <Badge bg="info" text="dark" className="me-1" key={idx}>
                            {t}
                          </Badge>
                        ))
                      ) : (
                        <Badge bg="secondary">No tags</Badge>
                      )}
                    </div>

                    {doc.file_url && (
                      <Button
                        variant="outline-primary"
                        size="sm"
                        href={doc.file_url}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="mb-2"
                      >
                        View / Download
                      </Button>
                    )}

                    {/* Edit / Delete buttons */}
                    <div className="mt-auto d-flex justify-content-between">
                      <Button 
                        variant="outline-warning" 
                        size="sm" 
                        onClick={() => handleEditClick(doc)}
                      >
                        <FaEdit className="me-1" />
                        Edit
                      </Button>
                      <Button 
                        variant="outline-danger" 
                        size="sm" 
                        onClick={() => handleDeleteClick(doc)}
                      >
                        <FaTrash className="me-1" />
                        Delete
                      </Button>
                    </div>
                  </Card.Body>
                </Card>
              </Col>
            ))}
          </Row>
        )}
      </Container>

      {/* Preview Modal */}
      <Modal show={showPreview} onHide={handleClosePreview} size="lg">
        <Modal.Header closeButton>
          <Modal.Title>
            {previewDoc
              ? (previewDoc.original_filename || previewDoc.file_name)
              : 'Document Preview'
            }
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          {previewDoc && previewDoc.file_url ? (
            isPDF(previewDoc.file_url) ? (
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

      {/* Delete Confirmation Modal */}
      <ConfirmModal
        show={showDeleteModal}
        handleClose={() => setShowDeleteModal(false)}
        handleConfirm={confirmDeleteDocument}
        title="Confirm Document Deletion"
        body={`Are you sure you want to delete "${
          docToDelete?.original_filename || docToDelete?.file_name
        }"? This action cannot be undone.`}
      />

      {/* Edit Document Modal */}
      <Modal show={showEditModal} onHide={() => setShowEditModal(false)}>
        <Modal.Header closeButton>
          <Modal.Title>Edit Document</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Form.Group className="mb-3" controlId="editFilename">
            <Form.Label>Original Filename:</Form.Label>
            <Form.Control
              type="text"
              value={editFilename}
              onChange={(e) => setEditFilename(e.target.value)}
            />
          </Form.Group>
          <Form.Group className="mb-3" controlId="editTags">
            <Form.Label>Tags:</Form.Label>
            <Form.Control
              as="select"
              multiple
              value={editTags}
              onChange={handleEditTagChange}
            >
              {defaultTags.map((tag) => (
                <option key={tag} value={tag}>
                  {tag}
                </option>
              ))}
            </Form.Control>
            <Form.Text className="text-muted">
              Hold Ctrl (Windows) or Cmd (Mac) to select multiple tags.
            </Form.Text>
          </Form.Group>
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={() => setShowEditModal(false)}>
            Cancel
          </Button>
          <Button variant="primary" onClick={handleSaveEdit}>
            Save
          </Button>
        </Modal.Footer>
      </Modal>
    </>
  );
}

export default DocumentsPage;