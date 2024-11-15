import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    activeid: Number,
  }

  connect() {
    this.path = window.location.pathname
    this.activeidValue = Number(sessionStorage.getItem(this.path))
    console.log("XX", this.activeidValue)
  }

  changeTab({ params: params }) {
    console.log("p:", params)
    this.activeidValue = params.id
  }

  disconnect() {
    sessionStorage.setItem(this.path, this.activeidValue)
  }

}
