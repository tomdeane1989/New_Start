// Backend/middleware/requestLogger.js

const logger = require('../logger');

/**
 * Middleware to log incoming HTTP requests.
 * Logs method, URL, headers, and body.
 */
const requestLogger = (req, res, next) => {
    const { method, url, headers, body } = req;

    // Define fields to mask in logs
    const maskedBody = { ...body };
    if (maskedBody.password) {
        maskedBody.password = '***';
    }

    // Log the request details
    logger.info({
        message: 'Incoming Request',
        method,
        url,
        headers,
        body: maskedBody, // Use masked body to protect sensitive data
    });

    next();
};

module.exports = requestLogger;