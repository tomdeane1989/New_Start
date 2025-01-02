// Backend/middleware/validateTask.js
const { body, validationResult } = require('express-validator');

const validateTask = [
    body('project_id')
        .exists().withMessage('project_id is required')
        .isInt({ gt: 0 }).withMessage('project_id must be a positive integer'),
    body('stage_id')
        .exists().withMessage('stage_id is required')
        .isInt({ gt: 0 }).withMessage('stage_id must be a positive integer'),
    body('task_name')
        .exists().withMessage('task_name is required')
        .isString().withMessage('task_name must be a string')
        .notEmpty().withMessage('task_name cannot be empty'),
    body('description')
        .optional()
        .isString().withMessage('description must be a string'),
    body('due_date')
        .optional({ checkFalsy: true }) // Allows empty strings to be treated as missing
        .isISO8601().withMessage('due_date must be a valid date'),
    body('priority')
        .exists().withMessage('priority is required')
        .isIn(['Low', 'Medium', 'High']).withMessage('priority must be Low, Medium, or High'),

    (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            const extractedErrors = errors.array().map(err => ({ [err.param]: err.msg }));
            return res.status(400).json({
                errors: extractedErrors,
            });
        }
        next();
    }
];

module.exports = validateTask;