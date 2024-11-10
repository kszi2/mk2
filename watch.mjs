import * as esbuild from 'esbuild'
import ImportGlobPlugin from "esbuild-plugin-import-glob";

const is_watch = process.argv[2] === "--watch";

async function watch() {
	let ctx = await esbuild.context({
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
	  minify: !is_watch,
	  treeShaking: !is_watch
	})
	await ctx.watch();
	console.log('Watch cycle...');
}

watch();