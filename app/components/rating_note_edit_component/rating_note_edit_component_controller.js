import {Controller} from "@hotwired/stimulus";
import $ from "jquery";

export default class extends Controller {
  static targets = [ "title" ]

  textChanged(value) {
    for (let titleTarget of this.titleTargets) {
      $(titleTarget).text(value.target.value);
    }
  }
}
