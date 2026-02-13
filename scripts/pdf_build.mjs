import fs from "fs";
import path from "path";
import { chromium } from "playwright";

const root = process.cwd();
const outDir = path.join(root, "pdf");
if (!fs.existsSync(outDir)) fs.mkdirSync(outDir);

const pages = fs.readdirSync(root)
  .filter(f => /^עמוד \d+\.html$/.test(f))
  .sort((a,b)=> Number(a.match(/\d+/)[0]) - Number(b.match(/\d+/)[0]));

if (pages.length === 0) {
  console.log("❌ לא נמצאו קבצי עמוד");
  process.exit(2);
}

const browser = await chromium.launch();
const page = await browser.newPage();

for (const file of pages) {
  const num = file.match(/\d+/)[0];
  const fileUrl = "file://" + path.join(root, file);

  await page.goto(fileUrl, { waitUntil: "networkidle" });

  // המתנה ל-MathJax
  await page.waitForFunction(() => {
    return window.MathJax && window.MathJax.typesetPromise;
  }, { timeout: 10000 }).catch(() => {});

  const pdfPath = path.join(outDir, `עמוד ${num}.pdf`);
  await page.pdf({
    path: pdfPath,
    format: "A4",
    printBackground: true,
    margin: { top: "0mm", right: "0mm", bottom: "0mm", left: "0mm" }
  });

  console.log(`✅ built: ${pdfPath}`);
}

await browser.close();
