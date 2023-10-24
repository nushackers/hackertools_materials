#!/usr/bin/env node

const fs = require("node:fs/promises");
const path = require("node:path");

const pug = require("pug");
const { escape } = require("pug-runtime");
const shiki = require("shiki");

const ignoreNodeModules = {
  ignored: 'node_modules/**'
};

async function main() {
  const { unified } = await import("unified");
  const remarkParse = (await import("remark-parse")).default;
  const remarkGfm = (await import("remark-gfm")).default;
  const remarkHtml = (await import("remark-html")).default;
  const { visit } = await import("unist-util-visit");

  const highlighter = await shiki.getHighlighter({
    theme: "monokai",
    langs: ["c", "cpp"],
  });

  function remarkShiki() {
    return (tree) => {
      visit(tree, "code", (node) => {
        if (!node.lang) {
          return;
        }

        node.type = "html";
        node.value = highlighter.codeToHtml(node.value, { lang: node.lang });
        delete node.lang;
      });
    };
  }

  const mdProcessor = unified()
    .use(remarkParse)
    .use(remarkGfm)
    .use(remarkShiki, { highlighter })
    .use(remarkHtml, { sanitize: false });

  const pugConfig = {
    filters: {
      escape,
      md: (value) => mdProcessor.processSync(value).value,
      code: (v, o) => {
        const languageCandidates = Object.entries(o).filter(([k, v]) => v === true && k !== "filename");
        if (languageCandidates.length < 1) {
          throw new Error("No language specified to :code filter");
        }
        if (languageCandidates.length > 1) {
          throw new Error("Multiple languages specified to :code filter");
        }
        const language = languageCandidates[0][0];

        return highlighter.codeToHtml(v, { lang: language });
      }
    }
  };

  async function renderFile(file) {
    try {
      console.log(`Rendering ${file} ...`);
      const result = pug.renderFile(file, pugConfig);
      const outPath = path.format({ dir: path.dirname(file), name: path.basename(file, '.pug'), ext: '.html' });
      await fs.writeFile(outPath, result);
      console.log(`Rendered ${outPath}`);
    } catch (e) {
      console.error("Failed to render file", e);
    }
  }

  if (process.argv.length > 2) {
    for (const file of process.argv.slice(2)) {
      renderFile(file);
    }
    return;
  }

  const bs = require("browser-sync").create();

  bs.init({
    ui: false,
    open: false,
    server: {
      baseDir: ".",
      directory: true
    }
  });

  bs.watch("*.pug", ignoreNodeModules).on("change", (file) => void renderFile(file));
  bs.watch("*.html", ignoreNodeModules).on("change", (file) => void bs.reload(file));
}

main();