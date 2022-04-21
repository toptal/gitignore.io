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
    const myNumArr = new Uint32Array(1);
    crypto.getRandomValues(myNumArr);
    const randomNumber = Number(`0.${myNumArr[0]}`);

    testTemplates.push(templates[Math.floor(randomNumber * templates.length)])
  }
  return testTemplates;
}
module.exports = { randomTemplate, randomTemplates, templates }
