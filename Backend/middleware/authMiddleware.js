const jwt = require('jsonwebtoken');
console.log(__dirname);
// Use the secret key from the environment variables or fallback to a default (for development purposes only).
const JWT_SECRET = process.env.JWT_SECRET || 'your_secret_key';

/**
 * Middleware to verify the JWT token and attach user info to the request object.
 */
module.exports = (req, res, next) => {
    // Debug log to identify the routes where this middleware is applied
    console.log(`AuthMiddleware applied to route: ${req.originalUrl}`);

    try {
        // Extract the token from the Authorization header. The format should be: "Bearer <token>"
        const authHeader = req.headers.authorization;
        if (!authHeader) {
            console.error('Authorization header is missing.');
            return res.status(401).json({ error: 'Unauthorized: No token provided' });
        }

        const token = authHeader.split(' ')[1];
        if (!token) {
            console.error('Token is missing in the Authorization header.');
            return res.status(401).json({ error: 'Unauthorized: Invalid Authorization header format' });
        }

        // Verify the token using the secret key.
        const decoded = jwt.verify(token, JWT_SECRET);

        // Attach decoded user information (e.g., user ID) to the `req` object for downstream middleware.
        req.user = {
            id: decoded.id,
            email: decoded.email, // Optional, if present in the token payload
            role: decoded.role,   // Optional, if roles are implemented in the payload
        };

        console.log(`Token verified successfully for user ID: ${decoded.id}, email: ${decoded.email}`);

        // Call the next middleware or route handler.
        next();
    } catch (error) {
        if (error.name === 'TokenExpiredError') {
            console.error('Token has expired:', error);
            return res.status(401).json({ error: 'Unauthorized: Token has expired' });
        } else if (error.name === 'JsonWebTokenError') {
            console.error('Invalid token:', error);
            return res.status(401).json({ error: 'Unauthorized: Invalid token' });
        }

        // Handle other unexpected errors.
        console.error('Error verifying token:', error);
        return res.status(500).json({ error: 'Internal server error during token verification' });
    }
};