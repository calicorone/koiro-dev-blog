#!/usr/bin/env node
/**
 * Ensures every content/ko/posts/*.md has a same-basename file in content/en/posts/.
 * Run in CI before `hugo` so bilingual publishing stays in sync.
 *
 * Usage: node scripts/verify-en-parity.js
 */
const fs = require("fs");
const path = require("path");

const root = path.join(__dirname, "..");
const koDir = path.join(root, "content", "ko", "posts");
const enDir = path.join(root, "content", "en", "posts");

const koFiles = fs.readdirSync(koDir).filter((f) => f.endsWith(".md"));
const missing = koFiles.filter((f) => !fs.existsSync(path.join(enDir, f)));

if (missing.length) {
  console.error("Missing English counterparts (same filename as KO):");
  for (const f of missing) console.error("  -", f);
  console.error("\nFix: add content/en/posts/<file> or run: node scripts/sync-en-stubs.js");
  process.exit(1);
}

const extraEn = fs
  .readdirSync(enDir)
  .filter((f) => f.endsWith(".md") && !koFiles.includes(f));
if (extraEn.length) {
  console.warn("Warning: EN posts with no KO pair (orphans):");
  for (const f of extraEn) console.warn("  -", f);
}

console.log(`OK: ${koFiles.length} KO/EN post pairs (same basename).`);
