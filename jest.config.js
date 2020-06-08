module.exports = {
  globals: {
    'BASE_URL': process.env.BASE_URL || 'http://localhost:8080'
  },
  preset: 'jest-puppeteer',
  testTimeout: 30000
};
