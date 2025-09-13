// Entry point for the build script in your package.json
import $ from "jquery";
let ce, cw;

window.phone_home = function(type, message){
    const csrf = $("meta[name='csrf-token']").attr("content");
    fetch("/client_logs/log.json", {
        method: "POST",
        headers: {
            "X-CSRF-Token": csrf,
            "Content-Type": "application/json",
            "Accept": "application/json"
        },
        body: JSON.stringify({
            type: type,
            message,
        })
    }).then(x => {})
        .catch(x => ce.apply(console.error, ["error logging to server: ", x]));
}

if(window.console && console.warn){
    cw = console.warn;
    console.warn = function(...args){
        phone_home('warn', args.join(" "));
        cw.apply(this, args)
    }
}

if(window.console && console.error){
    ce = console.error;
    console.error = function(...args){
        phone_home('error', args.join(" "));
        ce.apply(this, args)
    }
}

import "@hotwired/turbo-rails"
import "./controllers"

if (navigator.serviceWorker) {
	navigator.serviceWorker.register('/service-worker.js', { scope: './' })
		.then(function(reg) {
			console.log('[Companion]', 'Service worker registered!');
			console.log(reg);
		});
}

