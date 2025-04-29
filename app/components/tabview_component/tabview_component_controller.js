import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    activeid: Number,
  }
  static targets = ["pageBody"]

  connect() {
    this.path = window.location.pathname
    this._setActiveTabFromUrl(window.location.href);
  }

  _setActiveTabFromUrl(urlString) {
    const url = new URL(urlString);
    const tab = url.searchParams.get("tab")
    this.activeidValue = Number(tab)
  }

  changeTab({params: params}) {
    this.activeidValue = params.id
    if ("history" in window) {
      const url = new URL(window.location.href);
      url.searchParams.set("tab", params.id)
      window.history.pushState({}, "", url.href)
    }
  }

  restoreTab({target: ev}) {
    this._setActiveTabFromUrl(ev.location.href);
  }

  preloadTab({params: params}) {
    const id = params.id
    if (this.pageBodyTargets.length <= id) {
      console.error(`invalid page preload: ${id} when there are only ${this.pageBodyTargets.length} pages`)
      return;
    }

    const pageRootTurbo = this.pageBodyTargets[id].querySelectorAll("&>turbo-frame")
    if (pageRootTurbo.length === 0) return;

    for (const turbo of pageRootTurbo) {
      if (turbo.loading !== "eager") turbo.loading = "eager";
      turbo.reload()
    }
  }
}
