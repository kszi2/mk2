import {Controller} from "@hotwired/stimulus";
import $ from "jquery";

export default class extends Controller {
  static targets = [ "title", "cost", "body" ]

  setContent(text, value) {
    $(this.bodyTarget).val(text);
    if (value != null) $(this.costTarget).val(value);
  }

  textChanged(value) {
    for (let titleTarget of this.titleTargets) {
      $(titleTarget).text(value.target.value);
    }
  }
}
