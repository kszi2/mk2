import {Controller} from "@hotwired/stimulus";
import $ from "jquery";

export default class extends Controller {
  static targets = ["content", "ignored"]

  toggleDetails(e) {
    if (this._checkIfIgnored(e.target)) return;

    e.preventDefault();
    if (e.detail > 1) return; /* skip multi-clicks */

    const det = $(this.contentTarget).parent();
    if (det.attr('open')) {
      $(this.contentTarget).slideToggle(function () {
        det.removeAttr('open');
      });
    } else {
      det.attr('open', '');
      $(this.contentTarget).slideToggle();
    }
  }

  _checkIfIgnored(node) {
    for (const ignoredTarget of this.ignoredTargets) {
      if (ignoredTarget.contains(node)) return true;
    }
    return false;
  }
}
