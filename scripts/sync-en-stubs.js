#!/usr/bin/env node
/**
 * For each KO post without an EN file, creates content/en/posts/<same-name>.md
 * with matching date/slug/translationKey and a short stub pointing to the KO URL.
 * Replace the stub body with a real translation before publishing.
 *
 * Usage: node scripts/sync-en-stubs.js
 */
const fs = require("fs");
const path = require("path");

const root = path.join(__dirname, "..");
const koDir = path.join(root, "content", "ko", "posts");
const enDir = path.join(root, "content", "en", "posts");

function fmValue(text, key) {
  const m = text.match(new RegExp(`^${key}:\\s*(.+)$`, "m"));
  return m ? m[1].replace(/^["']|["']$/g, "").trim() : "";
}

function parseFrontMatter(raw) {
  if (!raw.startsWith("---\n")) return { body: raw, data: {} };
  const end = raw.indexOf("\n---\n", 4);
  if (end === -1) return { body: raw, data: {} };
  const block = raw.slice(4, end);
  const body = raw.slice(end + 5);
  const data = {};
  for (const line of block.split("\n")) {
    const m = line.match(/^([\w-]+):\s*(.*)$/);
    if (m) data[m[1]] = m[2].replace(/^["']|["']$/g, "");
  }
  return { data, body };
}

function koPermalinkDate(filename) {
  const m = filename.match(/^(\d{4})-(\d{2})-(\d{2})-/);
  if (!m) return null;
  return { y: m[1], mo: m[2], d: m[3] };
}

const koFiles = fs.readdirSync(koDir).filter((f) => f.endsWith(".md"));
let created = 0;

for (const file of koFiles) {
  const enPath = path.join(enDir, file);
  if (fs.existsSync(enPath)) continue;

  const koRaw = fs.readFileSync(path.join(koDir, file), "utf8");
  const { data, body } = parseFrontMatter(koRaw);
  const title = data.title || "Post";
  const date = data.date || file.slice(0, 10);
  const slugFromFile = file.replace(/^\d{4}-\d{2}-\d{2}-/, "").replace(/\.md$/, "");
  const slug = data.slug || slugFromFile;
  const translationKey = data.translationKey || slugFromFile;
  const tags = data.tags ? data.tags : "[]";

  const pd = koPermalinkDate(file);
  const koUrl = pd
    ? `https://blog.koiro.me/${pd.y}/${pd.mo}/${pd.d}/${slug}/`
    : `https://blog.koiro.me/`;

  const stub = `---
title: "${title.replace(/"/g, '\\"')} (EN — translate)"
title_alt: "Korean edition"
date: ${date}
slug: ${slug}
tags: ${Array.isArray(tags) ? JSON.stringify(tags) : tags}
translationKey: ${translationKey}
---

**English draft.** Please replace this stub with a full translation. Korean edition: [read in Korean](${koUrl}).

`;

  fs.writeFileSync(enPath, stub, "utf8");
  console.log("Created stub:", enPath);
  created++;
}

if (!created) console.log("No missing EN files.");
else console.log("Done. Edit EN stubs and run: node scripts/verify-en-parity.js");
