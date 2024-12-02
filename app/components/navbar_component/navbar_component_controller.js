import { Controller } from "@hotwired/stimulus";
import $ from "jquery";

export default class extends Controller {
  static targets = [ "dropdown" ]
  static values = {
    open: Boolean,
  }

  toggle() {
    this.openValue = !!!this.openValue;
    $(this.dropdownTarget).slideToggle();
  }
}
