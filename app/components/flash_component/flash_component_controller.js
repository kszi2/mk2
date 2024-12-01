import {Controller} from "@hotwired/stimulus";
import $ from "jquery";

export default class extends Controller {
  static values = {
    ending: Boolean
  }

  connect() {
    this._startTimeout()
  }

  haltTimeout() {
    clearTimeout(this.timeout)
    this.timeout = null
  }

  restartTimeout() {
    if (this.timeout !== null) {
      console.warn("trying to restart running timeout: ignoring request")
      return;
    }

    this._startTimeout()
  }

  _startTimeout() {
    const animationTimeMs = 700;
    const showTimeoutMs = 1300;

    this.timeout = setTimeout(() => {
      this.endingValue = true
      setTimeout(() => {
        this.element.remove()
      }, animationTimeMs)
    }, animationTimeMs + showTimeoutMs)
  }
}
