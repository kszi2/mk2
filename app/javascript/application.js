// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// this does not exist by default, only generated during build, and then is
// promptly deleted not to plague anything else
import "../assets/builds/dynamic.js"

if (navigator.serviceWorker) {
	navigator.serviceWorker.register('/service-worker.js', { scope: './' })
		.then(function(reg) {
			console.log('[Companion]', 'Service worker registered!');
			console.log(reg);
		});
}

