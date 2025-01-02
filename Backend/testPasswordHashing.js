// testPasswordHashing.js

const bcrypt = require('bcrypt');

async function testHashing(password) {
    try {
        const saltRounds = 10;
        const hash = await bcrypt.hash(password, saltRounds);
        console.log(`Plaintext Password: ${password}`);
        console.log(`Hashed Password: ${hash}`);

        const isMatch = await bcrypt.compare(password, hash);
        console.log(`Password Match: ${isMatch}`);
    } catch (error) {
        console.error('Error during hashing test:', error);
    }
}

// Replace 'UserPassword123!' with the password you want to test
testHashing('test123');