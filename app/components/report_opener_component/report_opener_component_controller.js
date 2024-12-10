import {Controller} from "@hotwired/stimulus";
import $ from "jquery";

export default class extends Controller {
  static targets = ["styleSelector"]
  static values = {
    baseurl: String,
    copied: Boolean,
  }

  connect() {
    this.copiedValue = false;
  }

  open() {
    window.location.href = this._getUrl();
  }

  openNewPage() {
    window.open(this._getUrl(), "_blank").focus();
  }

  async copy() {
    const url = this._getUrl();
    const resp = await fetch(url)
    if (!resp.ok) {
      console.error(`cannot get report at ${url}: ${resp.status}`);
      return;
    }

    await navigator.clipboard.writeText(await resp.text())
    this.copiedValue = true;
    setTimeout(() => { this.copiedValue = false }, 400)
  }

  _getUrl() {
    const url = new URL(this.baseurlValue)
    url.searchParams.set("rating_style_id", $(this.styleSelectorTarget).val())
    return url.href
  }
}
