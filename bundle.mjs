import * as esbuild from 'esbuild'
import ImportGlobPlugin from "esbuild-plugin-import-glob";

await esbuild.build({
  entryPoints: [
    "app/javascript/*.*",
  ],
  bundle: true,
  outdir: 'app/assets/builds',
  sourcemap: true,
  format: 'esm',
  publicPath: "/assets",
  plugins: [
    ImportGlobPlugin.default()
  ],
  minify: true,
  treeShaking: true
})
