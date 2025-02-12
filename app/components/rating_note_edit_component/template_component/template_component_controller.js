import {Controller} from "@hotwired/stimulus";
import $ from "jquery";

export default class extends Controller {
  static values = {cost: Number}
  static targets = ["data"];
  static outlets = ["templates-component"]

  setContentToTemplate() {
    console.log("setContentToTemplate", this.costValue);
    this.templatesComponentOutlet.setContent($(this.dataTarget).text(), this.costValue);
  }
}
