// In authMiddleware.js

const jwt = require('jsonwebtoken');

function isAuthenticated(req, res, next) {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) return res.status(401).json({ error: 'Unauthorized: No token provided' });

    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err || !decoded.id) {
            return res.status(401).json({ error: 'Unauthorized: Invalid or missing user ID' });
        }
        req.user = decoded;  // req.user.id will now be accessible
        next();
    });
}

module.exports = { isAuthenticated };