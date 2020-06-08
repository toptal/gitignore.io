const { randomTemplate, randomTemplates } = require('../utils/templates');

describe('Home page', () => {
  const templateSearchResultSelector = 'li.select2-results__option'
  const selectedTemplatesSelector = 'li.select2-selection__choice';
  const searchInputSelector = 'input[type="search"]';
  const submitButtonSelector = '.btn-gitignore';
  const loadPage = (templates) => {    
    const templatesQuery = templates !== undefined ? `/?templates=${templates.join(',')}` : ''
    return page.goto(`${BASE_URL}${templatesQuery}`, {waitUntil: 'networkidle2'});    
  };
  const searchFor = async (template) => {
    const searchInput = await page.$(searchInputSelector);
    await searchInput.type(template);
    await expect(page).toClick(templateSearchResultSelector);
  }

  beforeEach(async () => {
    await page.setViewport({ width: 1440, height: 900 });    
  });

  it('should successfully submit a single item', async () => {
    const template = randomTemplate();
    
    await loadPage();
    await searchFor(template);
    await expect(await page.$(selectedTemplatesSelector)).toMatch(template, {timeout: 10000});
    await page.click(submitButtonSelector);
    await page.waitForFunction(`window.location.href.includes('${template.toLowerCase()}')`);
    await expect(page).toMatch(template, {timeout: 10000});
  });

  it('should successfully submit multiple items', async () => {
    const testTemplates = randomTemplates(3);

    await loadPage();    
    for (const template of testTemplates) { 
      await searchFor(template);
    }
    await expect((await page.$$(selectedTemplatesSelector)).length).toEqual(testTemplates.length);
    await page.click(submitButtonSelector);
    await page.waitForFunction(`window.location.href.includes('${testTemplates[0].toLowerCase()}')`);
    for (const template of testTemplates) {
      await expect(page).toMatch(template, {timeout: 10000});
    }
  });

  it('should successfully load query params templates in search bar', async () => {
    const testTemplates = randomTemplates(2);

    await loadPage(testTemplates);
    await expect((await page.$$(selectedTemplatesSelector)).length).toEqual(testTemplates.length);    
  });
});
