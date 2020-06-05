const fs = require('fs');

let templates = [];

try {
  fs.readdirSync('./gitignore/templates').forEach(file => {
    if (file.includes('.gitignore')) {
      const filenameWithouthExtension = file.split('.')[0];
      templates.push(filenameWithouthExtension);
    }
  });
} catch (e) {
  console.log(e);
}

const randomTemplate = () => randomTemplates(1)[0];
const randomTemplates = (n) => {
  testTemplates = [];
  for (let index = 0; index < n; index++) {
    testTemplates.push(templates[Math.floor(Math.random() * templates.length)]);
  }
  return testTemplates;
}
module.exports = { randomTemplate, randomTemplates, templates }
