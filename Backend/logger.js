// Backend/logger.js
const { createLogger, format, transports } = require('winston');
require('winston-daily-rotate-file');
const path = require('path');

// Define transport for daily rotated logs
const dailyRotateTransport = new transports.DailyRotateFile({
  filename: path.join(__dirname, 'logs', 'application-%DATE%.log'),
  datePattern: 'YYYY-MM-DD',
  zippedArchive: true,
  maxSize: '20m',
  maxFiles: '14d'
});

const logger = createLogger({
  level: 'info',
  format: format.combine(
    format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
    format.errors({ stack: true }),
    format.splat(),
    format.json()
  ),
  defaultMeta: { service: 'project-management-service' },
  transports: [
    dailyRotateTransport,
    new transports.File({ filename: path.join(__dirname, 'logs', 'error.log'), level: 'error' }),
    new transports.Console({
      format: format.combine(
        format.colorize(),
        format.simple()
      ),
      silent: process.env.NODE_ENV === 'production' // Disable console logs in production
    })
  ],
});

module.exports = logger;