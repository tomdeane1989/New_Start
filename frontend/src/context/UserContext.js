// Frontend/src/context/UserContext.js

import React, { createContext, useState, useEffect } from 'react';
import axios from 'axios';

export const UserContext = createContext(null);

export function UserProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const token = localStorage.getItem('jwtToken');
    if (token) {
      axios.get(`${process.env.REACT_APP_API_URL}/users/me`, {
        headers: { Authorization: `Bearer ${token}` },
      })
        .then((response) => {
          // Assuming response.data contains the user object
          console.log('User data from /users/me:', response.data); // Debug log
          setUser(response.data);
        })
        .catch((error) => {
          console.error('Failed to fetch user:', error);
          localStorage.removeItem('jwtToken');
        })
        .finally(() => setLoading(false));
    } else {
      // No token means no user, just stop loading.
      setLoading(false);
    }
  }, []);

  return (
    <UserContext.Provider value={{ user, setUser, loading }}>
      {children}
    </UserContext.Provider>
  );
}