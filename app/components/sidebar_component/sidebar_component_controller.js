import {Controller} from "@hotwired/stimulus";
import $ from 'jquery';

export default class extends Controller {
  static targets = ["sidebar"];
  static values = {
    dismissible: Boolean,
    ending: Boolean,
    shake: Boolean,
  }

  outsideClick(e) {
    // count only every 5th click, this only triggers once of ff,
    // because seemingly ff returns mod 4, not that it matters much
    if (e.detail % 5 !== 1) return;

    if (this.dismissibleValue) {
      this.close()
    } else {
      this.shake();
    }
  }

  insideClick() {
    // ignore clicks on the inside
  }

  shake() {
    // at this point shaking is more relevant, and
    // the slide-in doesn't matter
    $(this.sidebarTarget).removeClass("animate-sidebar")
    const animationTimeMs = 700;

    this.shakeValue = true
    setTimeout(() => {
      this.shakeValue = false
    }, animationTimeMs);
  }

  close() {
    const animationTimeMs = 860;

    this.endingValue = true;
    setTimeout(() => {
      this.element.remove()
    }, animationTimeMs);
  }
}
