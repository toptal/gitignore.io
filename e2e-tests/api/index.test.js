const superagent = require('superagent');
const { templates } = require('../utils/templates');
let response;

describe('/api/list as lines', () => {
  beforeAll(async () => {
    response = await superagent.get(`${BASE_URL}/api/list?format=lines`);
  });

  it('should be successful', async () => {
    expect(response.status).toBe(200);
  });

  it('should contain all valid templates', async () => {
    templates.forEach((template) => expect(response.text).toContain(template.toLowerCase()));
  });
});

describe('/api/list as json', () => {
  beforeAll(async () => {
    response = await superagent.get(`${BASE_URL}/api/list?format=json`);
  });

  it('should be successful', async () => {
    expect(response.status).toBe(200);
  });

  it('should contain all valid templates', async () => {
    templates.forEach((template) => expect(Object.keys(response.body)).toContain(template.toLowerCase()));
  });
});
