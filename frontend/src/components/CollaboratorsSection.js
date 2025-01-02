// src/components/CollaboratorsSection.js

import React, { useState } from 'react';
import axios from 'axios';
import { toast } from 'react-toastify';
import { 
  Table, 
  Button, 
  Form, 
  Modal, 
  Spinner, 
  OverlayTrigger, // Imported OverlayTrigger
  Tooltip          // Imported Tooltip
} from 'react-bootstrap'; // Added OverlayTrigger and Tooltip to imports
import { useNavigate } from 'react-router-dom';
import ConfirmModal from './ConfirmModal'; // Import ConfirmModal
import { v4 as uuidv4 } from 'uuid'; // Import uuid for unique IDs

const roleOptions = [
  { value: '0', label: 'Buyer' },
  { value: '1', label: 'Seller' },
  { value: '2', label: 'Buyer Solicitor' },
  { value: '3', label: 'Seller Solicitor' },
  { value: '4', label: 'Estate Agent' },
  { value: '5', label: 'Mortgage Advisor' },
  { value: '6', label: 'Mortgage Vendor' },
  { value: '7', label: 'Deposit Gifter' }
];

function getRoleLabel(roleValue) {
  const found = roleOptions.find(r => r.value === String(roleValue));
  return found ? found.label : 'Unknown';
}

function CollaboratorsSection({ projectId, collaborators, refetchCollaborators }) {
  const [showAddForm, setShowAddForm] = useState(false);
  const [newCollaboratorEmail, setNewCollaboratorEmail] = useState('');
  const [newCollaboratorRole, setNewCollaboratorRole] = useState('0');
  const [isAdding, setIsAdding] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [collaboratorToDelete, setCollaboratorToDelete] = useState(null);
  const navigate = useNavigate();

  const handleAddCollaborator = async (e) => {
    e.preventDefault();
    setIsAdding(true);
    try {
      const token = localStorage.getItem('jwtToken');
      await axios.post(`${process.env.REACT_APP_API_URL}/projects/${projectId}/collaborators`, {
        email: newCollaboratorEmail,
        role: parseInt(newCollaboratorRole, 10),
      }, {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      });
      toast.success('Collaborator added successfully!');
      setShowAddForm(false);
      setNewCollaboratorEmail('');
      setNewCollaboratorRole('0');
      refetchCollaborators();
    } catch (error) {
      console.error('Error adding collaborator:', error);
      toast.error('Failed to add collaborator.');
    } finally {
      setIsAdding(false);
    }
  };

  const handleDeleteCollaborator = async () => {
    const token = localStorage.getItem('jwtToken');
    try {
      await axios.delete(`${process.env.REACT_APP_API_URL}/projects/${projectId}/collaborators/${collaboratorToDelete.collaborator_id}`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      toast.success('Collaborator removed successfully!');
      setShowDeleteModal(false);
      setCollaboratorToDelete(null);
      refetchCollaborators();
    } catch (error) {
      console.error('Error removing collaborator:', error);
      toast.error('Failed to remove collaborator.');
    }
  };

  const getCollaboratorInfo = (userId) => {
    const collab = collaborators.find(c => c.user_id === userId);
    if (!collab || !collab.user) return { name: 'Unknown', role: 'Unknown' };
    const name = `${collab.user.first_name || ''} ${collab.user.last_name || ''}`.trim() || 'Unknown';
    const roleLabel = getRoleLabel(collab.role);
    return { name, role: roleLabel };
  };

  const renderAssignedUsers = (task) => {
    if (!task.assigned_users || task.assigned_users.length === 0) {
      return <span className="text-muted">None</span>;
    }

    const assignedDetails = task.assigned_users.map(u => getCollaboratorInfo(u.user_id));
    const displayLimit = 2;

    if (assignedDetails.length <= displayLimit) {
      return (
        <>
          {assignedDetails.map((a, idx) => (
            <span key={idx} className="me-2">
              {a.name} ({a.role})
            </span>
          ))}
        </>
      );
    } else {
      const firstTwo = assignedDetails.slice(0, displayLimit);
      const remaining = assignedDetails.slice(displayLimit);
      const tooltipId = uuidv4(); // Unique ID

      const tooltip = (
        <Tooltip id={tooltipId}>
          {remaining.map((a, idx) => (
            <div key={idx}>
              {a.name} ({a.role})
            </div>
          ))}
        </Tooltip>
      );

      return (
        <>
          {firstTwo.map((a, idx) => (
            <span key={idx} className="me-2">
              {a.name} ({a.role})
            </span>
          ))}
          {remaining.length > 0 && (
            <OverlayTrigger overlay={tooltip} placement="right">
              <span className="text-primary" style={{ cursor: 'pointer' }}>
                +{remaining.length} more
              </span>
            </OverlayTrigger>
          )}
        </>
      );
    }
  };

  return (
    <div className="collaborators-section section">
      <h2>Project Team</h2>
      {collaborators && collaborators.length > 0 ? (
        <div className="table-responsive">
          <Table striped bordered hover>
            <thead>
              <tr>
                <th>Name & Role</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {collaborators.map((collab) => {
                const name = `${collab.user?.first_name || ''} ${collab.user?.last_name || ''}`.trim() || 'Unknown User';
                const roleLabel = getRoleLabel(collab.role);
                return (
                  <tr key={collab.collaborator_id}>
                    <td>{name} ({roleLabel})</td>
                    <td>
                      <Button
                        variant="outline-danger"
                        size="sm"
                        onClick={() => {
                          setCollaboratorToDelete(collab);
                          setShowDeleteModal(true);
                        }}
                      >
                        Remove
                      </Button>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </Table>
        </div>
      ) : (
        <p>No collaborators found.</p>
      )}

      <Button variant={showAddForm ? 'secondary' : 'success'} className="mt-3" onClick={() => setShowAddForm(!showAddForm)}>
        {showAddForm ? 'Cancel' : 'Add Collaborator'}
      </Button>

      {/* Add Collaborator Form Modal */}
      <Modal show={showAddForm} onHide={() => setShowAddForm(false)}>
        <Modal.Header closeButton>
          <Modal.Title>Add a New Collaborator</Modal.Title>
        </Modal.Header>
        <Form onSubmit={handleAddCollaborator}>
          <Modal.Body>
            <Form.Group controlId="email" className="mb-3">
              <Form.Label>Email:</Form.Label>
              <Form.Control
                type="email"
                value={newCollaboratorEmail}
                onChange={(e) => setNewCollaboratorEmail(e.target.value)}
                placeholder="Enter collaborator's email"
                required
              />
            </Form.Group>
            <Form.Group controlId="role" className="mb-3">
              <Form.Label>Role:</Form.Label>
              <Form.Control
                as="select"
                value={newCollaboratorRole}
                onChange={(e) => setNewCollaboratorRole(e.target.value)}
              >
                {roleOptions.map((opt) => (
                  <option key={opt.value} value={opt.value}>{opt.label}</option>
                ))}
              </Form.Control>
            </Form.Group>
          </Modal.Body>
          <Modal.Footer>
            <Button variant="secondary" onClick={() => setShowAddForm(false)}>
              Cancel
            </Button>
            <Button variant="primary" type="submit" disabled={isAdding}>
              {isAdding ? (
                <>
                  <Spinner
                    as="span"
                    animation="border"
                    size="sm"
                    role="status"
                    aria-hidden="true"
                  /> Adding...
                </>
              ) : (
                'Add Collaborator'
              )}
            </Button>
          </Modal.Footer>
        </Form>
      </Modal>

      {/* Delete Confirmation Modal */}
      <ConfirmModal
        show={showDeleteModal}
        handleClose={() => setShowDeleteModal(false)}
        handleConfirm={handleDeleteCollaborator}
        title="Confirm Removal"
        body={
          collaboratorToDelete
            ? `Are you sure you want to remove ${collaboratorToDelete.user?.first_name || ''} ${collaboratorToDelete.user?.last_name || ''}?`
            : 'Are you sure you want to remove this collaborator?'
        }
      />
    </div>
  );
}

export default CollaboratorsSection;