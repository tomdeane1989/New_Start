// src/components/ConfirmModal.js

import React from 'react';
import { Modal, Button } from 'react-bootstrap';

const ConfirmModal = ({ show, handleClose, handleConfirm, title, body }) => {
  return (
    <Modal
      show={show}
      onHide={handleClose}
      backdrop="static"
      keyboard={false}
      aria-labelledby="confirm-modal-title"
      role="dialog"
    >
      {title && (
        <Modal.Header closeButton>
          <Modal.Title id="confirm-modal-title">{title}</Modal.Title>
        </Modal.Header>
      )}
      {body && <Modal.Body>{body}</Modal.Body>}
      <Modal.Footer>
        <Button variant="secondary" onClick={handleClose}>
          Cancel
        </Button>
        <Button variant="danger" onClick={handleConfirm}>
          Confirm
        </Button>
      </Modal.Footer>
    </Modal>
  );
};

export default ConfirmModal;