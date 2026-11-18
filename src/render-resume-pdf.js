const { chromium } = require('playwright');
(async () => {
  const b = await chromium.launch();
  const p = await b.newPage();
  await p.goto('file://' + __dirname + '/resume-pdf.html', { waitUntil: 'load' });
  await p.evaluate(() => document.fonts.ready);
  await p.pdf({ path: __dirname + '/../assets/Mary-Nink-Resume.pdf', format: 'Letter', printBackground: true, preferCSSPageSize: true });
  await b.close();
})();
