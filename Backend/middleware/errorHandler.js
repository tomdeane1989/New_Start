// Backend/middleware/errorHandler.js

const logger = require('../logger');

/**
 * Centralized Error Handling Middleware
 */
const errorHandler = (err, req, res, next) => {
    // Determine the status code
    const statusCode = err.statusCode || 500;

    // Log detailed error information
    logger.error({
        message: err.message,
        stack: err.stack,
        method: req.method,
        url: req.originalUrl,
        body: req.body,
        params: req.params,
        query: req.query,
        headers: req.headers,
    });

    // Customize response based on error type
    let errorMessage = 'Internal server error.';
    if (err.name === 'ValidationError') {
        errorMessage = err.message;
    } else if (err.name === 'UnauthorizedError') {
        errorMessage = 'Invalid token.';
    }
    // Add more custom error types as needed

    // Send structured error response
    res.status(statusCode).json({
        error: errorMessage,
    });
};

module.exports = errorHandler;