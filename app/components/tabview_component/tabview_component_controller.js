import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    activeid: Number,
  }
  static targets = ["pageBody"]

  connect() {
    this.path = window.location.pathname
    this.activeidValue = Number(sessionStorage.getItem(this.path))
  }

  changeTab({params: params}) {
    this.activeidValue = params.id
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

  disconnect() {
    sessionStorage.setItem(this.path, this.activeidValue)
  }

}
