const superagent = require('superagent');
const { randomTemplates } = require('../utils/templates');
let response;

describe('/api/show single template', () => {
  randomTemplates(10).forEach((template) => {
    it(`${template} should be successful`, async () => {
      response = await superagent.get(`${BASE_URL}/api/${template}`);
      expect(response.status).toBe(200);
    });
    
    it(`should return ${template} template`, async () => {
      response = await superagent.get(`${BASE_URL}/api/${template}`);
      
      expect(response.text).toContain(template);
    });
  });
});

let testTemplates = randomTemplates(3);

describe('/api/show multiple templates', () => {
  beforeAll(async () => {
    response = await superagent.get(`${BASE_URL}/api/${testTemplates.join(',')}`);
  });

  it(`${testTemplates.join(',')} should be successful`, async () => {
    expect(response.status).toBe(200);
  });

  it(`should return ${testTemplates.join(',')} templates`, async () => {
    testTemplates.forEach((template) => expect(response.text).toContain(template));
  });
});
