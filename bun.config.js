import {Glob} from 'bun';
import path from 'path';
import fs from 'fs';

const outfile = path.join(process.cwd(), "app/assets/builds/dynamic.js");

const comps = new Glob("components/**/*.{js,ts}")
const controller_name = new RegExp(/[\\/](\w+)_component_controller\.[tj]s$/);

const config = {
  sourcemap: "external",
  entrypoints: ["app/javascript/application.js"],
  outdir: path.join(process.cwd(), "app/assets/builds"),
  minify: !process.argv.includes("--no-minify")
};

const build = async (config) => {
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
  await fs.unlinkSync(outfile);

  if (!result.success) {
    if (process.argv.includes('--watch')) {
      console.error("Build failed");
      for (const message of result.logs) {
        console.error(message);
      }
      return;
    } else {
      throw new AggregateError(result.logs, "Build failed");
    }
  }
};

(async () => {
  await build(config);

  if (process.argv.includes('--watch')) {
    fs.watch(path.join(process.cwd(), "app/javascript"), {recursive: true}, (eventType, filename) => {
      console.log(`File changed: ${filename}. Rebuilding...`);
      build(config);
    });
  } else {
    process.exit(0);
  }
})();
