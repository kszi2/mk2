import {Controller} from "@hotwired/stimulus";
import $ from "jquery";

export default class extends Controller {
  static targets = [ "dialog" ]
  static values = {course: String}
  static outlets = [ "rating-note-edit-component" ]

  connect() {
    this.element.id = "_" + crypto.randomUUID();
  }

  setText(text) {
    this.ratingNoteEditComponentOutlet.setText(text);
  }

  async openListings() {
    const csrf = $("meta[name='csrf-token']").attr("content");
    const resp = await Turbo.fetch(`/templates/listings/${this.courseValue}?id=${this.element.id}`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": csrf
      }
    });
    if (!resp.ok) {
      console.error(`error processing /templates/listings/${this.courseValue}: ${resp.status}`);
      return;
    }

    const text = await resp.text();
    Turbo.renderStreamMessage(text);
  }
}
