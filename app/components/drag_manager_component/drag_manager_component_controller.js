import {Controller} from "@hotwired/stimulus";
import $ from "jquery";

export default class extends Controller {
  // todo this hardcodes what can be dragged :(
  static outlets = ["rating-point-listing-component"]
  static targets = [
    "draggable",
    "actionForm",
    "beforeId",
    "droppedId",
  ]
  static values = {
    // whether the current drag area is actively in a drag operation
    active: Boolean,
  }

  startDrag() {
    this.activeValue = true;
  }

  endDrag() {
    this.activeValue = false;
    this.ratingPointListingComponentOutlets.forEach(outlet => {
      outlet.dragEnded()
    })
  }

  droppedBefore(before, e) {
    const droppedHelper = document.createElement("div");
    droppedHelper.innerHTML = e.getData("text/html");
    const dropped = droppedHelper.firstChild;

    this.ratingPointListingComponentOutlets
      .filter(x => x.isAfter(before))
      .forEach(x => {
        x.fadeOut();
      })

    this.beforeIdTarget.value = before.id;
    this.droppedIdTarget.value = dropped.id;
    this.actionFormTarget.requestSubmit();
  }
}
