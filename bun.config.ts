import {Glob} from 'bun';
import path from 'node:path';
import fs from 'node:fs';

const outfile = path.join(process.cwd(), "app/assets/builds/dynamic.js");

const comps = new Glob("components/**/*.{js,ts}")
const controller_name = new RegExp(/[\\/](\w+)_component_controller\.[tj]s$/);

const config = {
  sourcemap: "external" as (boolean | "external" | "inline" | "none" | "linked" | undefined),
  entrypoints: ["app/javascript/application.js"],
  outdir: path.join(process.cwd(), "app/assets/builds"),
  minify: !process.argv.includes("--no-minify")
};

let isBuilding = false;
let pendingBuild = false;

const build = async (config: Bun.BuildConfig) => {
  if (isBuilding) {
    pendingBuild = true;
    return;
  }
  isBuilding = true;

  try {
    let imports = "";
    let registrations = "";

    for await (const file of comps.scan("./app")) {
      const cn = controller_name.exec(file);
      if (cn === null) {
        console.error("Can't find the file " + file);
        continue;
      }

      imports += `import {default as ${cn[1]}_component_controller} from "../../${file.replaceAll("\\", "/")}";\n`;
      registrations += `window.Stimulus.register('${cn[1].replaceAll("_", "-")}', ${cn[1]}_component_controller);\n`;
    }

    await Bun.write(outfile, imports + "\n" + registrations);

    const result = await Bun.build(config);
    if (fs.existsSync(outfile)) {
      fs.unlinkSync(outfile);
    }

    if (!result.success) {
      if (process.argv.includes('--watch')) {
        console.error("Build failed");
        for (const message of result.logs) {
          console.error(message);
        }
      } else {
        throw new AggregateError(result.logs, "Build failed");
      }
    }
  } finally {
    isBuilding = false;
    if (pendingBuild) {
      pendingBuild = false;
      await build(config);
    }
  }
};

(async () => {
  await build(config);

  if (process.argv.includes('--watch')) {
    let timeout: Timer | null = null;
    fs.watch(path.join(process.cwd(), "app"),
        {recursive: true},
        (_eventType, filename) => {
          console.log(`File changed: ${filename}.`);
          if (filename?.startsWith("assets/builds")) return;
          if (filename?.endsWith("~")) return;

          if (timeout) clearTimeout(timeout);
          timeout = setTimeout(() => {
            console.log(`Rebuilding...`);
            build(config);
          }, 100);
        });
  } else {
    process.exit(0);
  }
})();
