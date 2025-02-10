import { Controller } from "@hotwired/stimulus";
import $ from "jquery";

export default class extends Controller {
  static targets = [ "data" ];
  static outlets = [ "templates-component" ]

  setContentToTemplate() {
    this.templatesComponentOutlet.setText($(this.dataTarget).text());
  }
}
