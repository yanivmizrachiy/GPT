import fs from "fs";
import path from "path";
import { chromium } from "playwright";

const root = process.cwd();
const outDir = path.join(root, "pdf");

// תמיד מתחילים נקי כדי שלא יישאר מצב של "יש 2-4 ואין 1"
fs.rmSync(outDir, { recursive: true, force: true });
fs.mkdirSync(outDir, { recursive: true });

const pages = fs.readdirSync(root)
  .filter(f => /^עמוד \d+\.html$/.test(f))
  .sort((a,b)=> Number(a.match(/\d+/)[0]) - Number(b.match(/\d+/)[0]));

if (pages.length === 0) {
  console.log("❌ לא נמצאו קבצי עמוד *.html");
  process.exit(2);
}

console.log("📄 Pages to PDF:", pages.join(", "));

const browser = await chromium.launch();
const page = await browser.newPage();

for (const file of pages) {
  const num = file.match(/\d+/)[0];
  const fileUrl = "file://" + path.join(root, file);
  await page.goto(fileUrl, { waitUntil: "networkidle" });

  // רגע קטן ל-MathJax (במיוחד בעמוד 1)
  await page.waitForTimeout(600);

  const pdfPath = path.join(outDir, `עמוד ${num}.pdf`);
  await page.pdf({
    path: pdfPath,
    format: "A4",
    printBackground: true,
    margin: { top: "0mm", right: "0mm", bottom: "0mm", left: "0mm" }
  });

  if (!fs.existsSync(pdfPath)) {
    console.log(`❌ FAILED to write: ${pdfPath}`);
    process.exit(3);
  }
  console.log(`✅ built: ${pdfPath}`);
  const alias = path.join(outDir, `page-${num}.pdf`);
  fs.copyFileSync(pdfPath, alias);
  console.log(`✅ alias: ${alias}`);
}

await browser.close();
