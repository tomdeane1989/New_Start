const authMiddleware = require('../middleware/authMiddleware');
const express = require('express');
const router = express.Router();
const { Op } = require('sequelize');
const {
    createCompany,
    getAllCompanies,
    getCompanyById,
    updateCompany,
    deleteCompany,
    getUsersByCompanyId,
} = require('../controllers/companyController');
const Company = require('../models').Company;

console.log('Initializing Company Routes');

// Protect all routes
router.use(authMiddleware);

// Ownership validation middleware specific to company routes
const validateCompanyOwnership = async (req, res, next) => {
    try {
        const companyId = req.params.id; // Extract company ID from route parameters
        const userId = req.user.id; // Extract authenticated user ID from `authMiddleware`

        // Fetch the company and validate ownership
        const company = await Company.findByPk(companyId);

        if (!company) {
            return res.status(404).json({ error: 'Company not found' });
        }

        if (company.owner_id !== userId) {
            return res.status(403).json({ error: 'Access denied: You do not own this company' });
        }

        console.log(`Ownership validated for user ${userId} on company ${companyId}`);
        next();
    } catch (error) {
        console.error('Error validating company ownership:', error);
        res.status(500).json({ error: 'Internal server error during ownership validation' });
    }
};

// Search route - specific paths must be defined before parameterized routes
router.get('/search', async (req, res) => {
    try {
        const { name, email, created_after, created_before, updated_after, updated_before } = req.query;

        const query = {};
        if (name) query.company_name = { [Op.like]: `%${name}%` };
        if (email) query.company_email = email;
        if (created_after) query.created_at = { [Op.gte]: created_after };
        if (created_before) query.created_at = { ...query.created_at, [Op.lte]: created_before };
        if (updated_after) query.updated_at = { [Op.gte]: updated_after };
        if (updated_before) query.updated_at = { ...query.updated_at, [Op.lte]: updated_before };

        console.log('Executing company search with query:', query);

        const companies = await Company.findAll({ where: query });

        res.status(200).json(companies);
    } catch (error) {
        console.error('Error searching companies:', error);
        res.status(500).json({ error: 'Failed to search companies' });
    }
});

// Other routes
router.post('/create', createCompany);
router.get('/', getAllCompanies);
router.get('/:id', getCompanyById); // Parameterized route should come last
router.put('/:id', updateCompany);
router.delete('/:id', deleteCompany);
router.get('/:id/users', getUsersByCompanyId);
router.get('/:id/owner', validateCompanyOwnership, async (req, res) => {
    const company = await Company.findByPk(req.params.id, { include: 'owner' });
    res.status(200).json(company.owner);
});

module.exports = router;