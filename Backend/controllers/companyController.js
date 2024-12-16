// Backend/controllers/companyController.js
const { Company, User } = require('../models');
const logger = require('../logger'); // Import Winston logger

// Create a new company
const createCompany = async (req, res) => {
    try {
        const { company_name, company_email } = req.body;

        // Retrieve the logged-in user's ID from the `req.user` object
        const userId = req.user?.id;

        if (!company_name || !company_email) {
            logger.warn('Missing required fields: company_name or company_email');
            return res.status(400).json({ error: 'Missing required fields: company_name or company_email' });
        }

        logger.info(`Creating or validating Company: ${company_name}`);

        // Check if the company already exists
        const existingCompany = await Company.findOne({ where: { company_name } });

        if (existingCompany) {
            logger.warn(`Company "${company_name}" already exists`);
            return res.status(409).json({ error: 'Company already exists' });
        }

        // Create a new company
        const newCompany = await Company.create({ company_name, company_email });
        logger.info(`Company created successfully: ${newCompany.company_id} (${company_name})`);

        // Associate the logged-in user with the company
        if (userId) {
            const user = await User.findByPk(userId);
            if (user) {
                await user.update({ company_id: newCompany.company_id });
                logger.info(`User ID ${userId} associated with company ID ${newCompany.company_id}`);
            } else {
                logger.warn(`User ID ${userId} not found.`);
            }
        } else {
            logger.warn('No user ID provided in request.');
        }

        res.status(201).json({ message: 'Company created successfully', company: newCompany });
    } catch (error) {
        logger.error(`Error creating company: ${error.message}`, error);
        res.status(500).json({ error: 'Failed to create company', details: error.message });
    }
};

// Get all companies
const getAllCompanies = async (req, res) => {
    try {
        logger.info('Fetching all companies');

        const companies = await Company.findAll({
            attributes: ['company_id', 'company_name'], // Fetch minimal data for autocomplete
            order: [['company_name', 'ASC']],
        });

        if (!companies.length) {
            logger.warn('No companies found in the database.');
            return res.status(404).json({ message: 'No companies found' });
        }

        logger.info(`Companies retrieved successfully: ${companies.length} companies found.`);
        res.status(200).json(companies);
    } catch (error) {
        logger.error(`Error fetching companies: ${error.message}`, error);
        res.status(500).json({ error: 'Failed to fetch companies', details: error.message });
    }
};

// Get a company by ID
const getCompanyById = async (req, res) => {
    try {
        const { id } = req.params;
        logger.info(`Fetching company with ID: ${id}`);

        const company = await Company.findByPk(id);
        if (!company) {
            logger.warn(`Company with ID ${id} not found.`);
            return res.status(404).json({ error: 'Company not found' });
        }

        logger.info(`Company retrieved successfully: ${id}`);
        res.status(200).json(company);
    } catch (error) {
        logger.error(`Error fetching company: ${error.message}`, error);
        res.status(500).json({ error: 'Failed to fetch company' });
    }
};

// Update a company by ID
const updateCompany = async (req, res) => {
    try {
        const { id } = req.params;
        const { company_name, company_email } = req.body;

        logger.info(`Updating company with ID: ${id}`);

        const company = await Company.findByPk(id);
        if (!company) {
            logger.warn(`Company with ID ${id} not found.`);
            return res.status(404).json({ error: 'Company not found' });
        }

        const updatedCompany = await company.update({ company_name, company_email });
        logger.info(`Company updated successfully: ${id}`);
        res.status(200).json(updatedCompany);
    } catch (error) {
        logger.error(`Error updating company: ${error.message}`, error);
        res.status(500).json({ error: 'Failed to update company' });
    }
};

// Delete a company by ID
const deleteCompany = async (req, res) => {
    try {
        const { id } = req.params;

        logger.info(`Deleting company with ID: ${id}`);

        const company = await Company.findByPk(id);
        if (!company) {
            logger.warn(`Company with ID ${id} not found.`);
            return res.status(404).json({ error: 'Company not found' });
        }

        await company.destroy();
        logger.info(`Company with ID ${id} deleted successfully.`);
        res.status(200).json({ message: 'Company deleted successfully' });
    } catch (error) {
        logger.error(`Error deleting company: ${error.message}`, error);
        res.status(500).json({ error: 'Failed to delete company' });
    }
};

// Get users associated with a specific company by company ID
const getUsersByCompanyId = async (req, res) => {
    try {
        const { id } = req.params;
        logger.info(`Fetching users for company ID: ${id}`);

        // Fetch users associated with the company
        const users = await User.findAll({
            where: { company_id: id },
            attributes: ['user_id', 'username', 'email', 'first_name', 'last_name'], // Select specific fields
        });

        if (!users.length) {
            logger.warn(`No users found for company ID: ${id}`);
            return res.status(404).json({ message: 'No users found for this company' });
        }

        logger.info(`Users retrieved successfully for company ID ${id}: ${users.length} users found.`);
        res.status(200).json({ message: 'Users retrieved successfully', users });
    } catch (error) {
        logger.error(`Error fetching users for company: ${error.message}`, error);
        res.status(500).json({ error: 'Failed to fetch users for company', details: error.message });
    }
};

module.exports = {
    createCompany,
    getAllCompanies,
    getCompanyById,
    updateCompany,
    deleteCompany,
    getUsersByCompanyId, // Ensure export
};