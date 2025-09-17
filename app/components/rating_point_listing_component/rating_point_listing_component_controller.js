import {Controller} from "@hotwired/stimulus";
import $ from "jquery";

export default class extends Controller {
  static outlets = ["drag-manager"];
  static targets = ["dragenterArea", "dropArea", "destruction"]
  static values = {
    // Currently being dragged
    dragged: Boolean,
    // The order of current rating point, starts at -1 to allow detecting page load
    ordering: {type: Number, default: -1},
    // if a dragged element is currently pointing over this
    pointedOver: {type: Boolean, default: null},
    ending: Boolean,
  }

  constructor(context) {
    super(context);
    this.allowEnter = true;
  }

  fadeOut() {
    this.endingValue = true;
  }

  isAfter(order) {
    return $(order).data('rating-point-listing-ordering-value') >= this.orderingValue
  }

  destructionTargetConnected() {
    this.element.remove()
  }

  pointedOverValueChanged(value, prev) {
    if (value) {
      $(this.dropAreaTarget).slideDown("fast");
    } else {
      $(this.dropAreaTarget).slideUp("fast");
    }
  }

  initiateDrag(e) {
    this.draggedValue = true;

    e.dataTransfer.dropEffect = "move";
    e.dataTransfer.effectAllowed = "move";
    e.dataTransfer.setData("text/html", this.dragenterAreaTarget.outerHTML);

    this.dragManagerComponentOutlet.startDrag();
  }

  finalizeDrag() {
    this.draggedValue = false;
    this.dragManagerComponentOutlet.endDrag();
  }

  allowDrop() {
    // used to allow dropping things
  }

  drop(e) {
    this.dragEnded();
    this.finalizeDrag();
    this.dragManagerComponentOutlet.droppedBefore(this.dragenterAreaTarget, e.dataTransfer);
  }

  enterDragged(e) {
    // don't react if we are the one dragged
    if (this.draggedValue) return;
    // if we are on timeout, ignore event
    if (!this.allowEnter) return;
    // only react if main element is entered
    if (e.target !== this.dragenterAreaTarget) return;

    this.pointedOverValue = true;
  }

  dragEnded() {
    this.pointedOverValue = false;
  }

  leaveDragged(e) {
    // don't react if we are the one dragged
    if (this.draggedValue) return;
    // this doesn't trigger in any sane way, so just ignore it
    if (e.target === this.element) return;

    // if leaving the main thing upwards, ignore it
    if (e.target === this.dragenterAreaTarget
      && e.offsetY < 0) return;

    // if leaving the drop-area downwards, ignore it
    if (e.target === this.dropAreaTarget
      && e.offsetY > 0) return;

    // cooldown on allowing enter
    // this disallows directly entering again, thusly fixing a jumping-effect
    this.allowEnter = false;
    setTimeout(() => this.allowEnter = true, 50);

    this.pointedOverValue = false;
  }
}
