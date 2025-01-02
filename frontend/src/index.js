// src/index.js

import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import { AuthProvider } from './context/AuthContext';
import { UserProvider } from './context/UserContext'; // Import UserProvider
import 'react-toastify/dist/ReactToastify.css'; // Import React Toastify CSS
import 'bootstrap/dist/css/bootstrap.min.css'; // Import Bootstrap CSS
import './styles.css'; // Import global styles

ReactDOM.render(
  <React.StrictMode>
    <AuthProvider>
      <UserProvider> {/* Add UserProvider */}
        <App />
      </UserProvider>
    </AuthProvider>
  </React.StrictMode>,
  document.getElementById('root')
);