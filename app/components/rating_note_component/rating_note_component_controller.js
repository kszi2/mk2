import {Controller} from "@hotwired/stimulus";
import $ from "jquery";

export default class extends Controller {
  static targets = ["content"]

  toggle() {
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
}
