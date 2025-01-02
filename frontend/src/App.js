// src/App.js

import React, { useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import Register from './pages/Register';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Profile from './pages/Profile';
import Projects from './pages/Projects';
import CreateProject from './pages/CreateProject';
import ProjectDetails from './pages/ProjectDetails';
import CreateTaskPage from './pages/CreateTaskPage';
import EditTaskPage from './pages/EditTaskPage';
import DocumentsPage from './pages/DocumentsPage'; // <-- Add your DocumentsPage
import ProtectedRoute from './components/ProtectedRoute';
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import './styles.css';

// 1) Axios setup to handle token expiration gracefully
import axios from 'axios';
import { toast } from 'react-toastify';

function setupAxiosInterceptors() {
  axios.interceptors.response.use(
    response => response,
    error => {
      // If we get a 401 or 403, it may mean token expired or unauthorized
      if (error.response && [401, 403].includes(error.response.status)) {
        // Avoid repeated toasts by checking a flag
        if (!window.__expiredToastShown__) {
          window.__expiredToastShown__ = true;
          toast.warn('Your session has expired. Please log in again.');
          // Force logout
          localStorage.removeItem('jwtToken');
          // Refresh page or redirect to login
          window.location.href = '/login';
        }
      } else if (!error.response) {
        // If it's a network error or no response
        toast.error('Network error. Please check your connection.');
      }
      return Promise.reject(error);
    }
  );
}

function App() {
  // 2) Set up interceptors once
  useEffect(() => {
    setupAxiosInterceptors();
  }, []);

  return (
    <Router>
      <Routes>
        {/* Public Routes */}
        <Route path="/register" element={<Register />} />
        <Route path="/login" element={<Login />} />

        {/* Protected Routes */}
        <Route
          path="/dashboard"
          element={
            <ProtectedRoute>
              <Dashboard />
            </ProtectedRoute>
          }
        />
        <Route
          path="/profile"
          element={
            <ProtectedRoute>
              <Profile />
            </ProtectedRoute>
          }
        />
        <Route
          path="/projects"
          element={
            <ProtectedRoute>
              <Projects />
            </ProtectedRoute>
          }
        />
        <Route
          path="/projects/create"
          element={
            <ProtectedRoute>
              <CreateProject />
            </ProtectedRoute>
          }
        />
        <Route
          path="/projects/:id"
          element={
            <ProtectedRoute>
              <ProjectDetails />
            </ProtectedRoute>
          }
        />

        {/* Task Creation Route */}
        <Route
          path="/projects/:id/create-task"
          element={
            <ProtectedRoute>
              <CreateTaskPage />
            </ProtectedRoute>
          }
        />

        {/* Task Editing Route */}
        <Route
          path="/projects/:projectId/tasks/:taskId/edit"
          element={
            <ProtectedRoute>
              <EditTaskPage />
            </ProtectedRoute>
          }
        />

        {/* New Documents Route */}
        <Route
          path="/documents"
          element={
            <ProtectedRoute>
              <DocumentsPage />
            </ProtectedRoute>
          }
        />

        {/* Root redirect based on authentication */}
        <Route
          path="/"
          element={
            localStorage.getItem('jwtToken') ? (
              <Navigate to="/dashboard" replace />
            ) : (
              <Navigate to="/login" replace />
            )
          }
        />

        {/* Fallback Route */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>

      <ToastContainer position="top-right" autoClose={5000} />
    </Router>
  );
}

export default App;