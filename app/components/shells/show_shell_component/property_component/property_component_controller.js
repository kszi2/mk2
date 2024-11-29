import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    success: Boolean
  }
  static targets = [ "source" ];

  connect() {
    this.successValue = false;
  }

  copy() {
    navigator.clipboard.writeText(this.sourceTarget.value)
      .then(() => {
        this.successValue = true;
        setTimeout(() => { this.successValue = false }, 400)
      });
  }
}
