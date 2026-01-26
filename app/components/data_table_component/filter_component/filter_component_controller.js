import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    visible: Boolean,
    preloaded: Boolean,
    filters: Object,
    controller: String,
    field: String,
    useful: {type: Boolean, default: false},
  };

  connect() {
    if (!this.hasFiltersValue) this.filtersValue = {};
    this.preloadedValue = false;
  }

  toggle() {
    this.visibleValue = !this.visibleValue
    for (const val of this.filtersValue[this.fieldValue] || []) {
      this.element.querySelector(`li>input#${this.fieldValue}_${val}`).checked = true;
    }
  }

  preload() {
    if (this.preloadedValue) return;
    const turboFrame = this.element.querySelector(this._memberIdOf("turbo-frame", "filter"))
    if (turboFrame === null) return;
    turboFrame.loading = "eager";
    turboFrame.reload();
    this.preloadedValue = true;
  }

  setFilter(filter) {
    if (!(filter.params.field in this.filtersValue)) {
      this.filtersValue = this._update(this.filtersValue, filter.params.field, []);
    }

    this.filtersValue = this._update(this.filtersValue, filter.params.field,
      this._toggleMembership(this.filtersValue[filter.params.field], filter.params.value.toString()));
  }

  filtersValueChanged() {
    const submitter = this.element.querySelector(this._memberIdOf("a", "submit"))
    const url = new URL(submitter.href);
    url.search = this._getFilterParameters()
    submitter.href = url.href;
    this._updateActiveFilter()
  }

  _getFilterParameters() {
    return "?"
      + Object
        .entries(this.filtersValue)
        .map(
          ([field, vals]) =>
        vals.map(val => `f[${field}][]=${val}`).join("&")
      ).join("&")
  }

  _updateActiveFilter() {
    const myFilter = this.filtersValue[this.fieldValue] || []
    this.usefulValue = myFilter.length > 0
  }

  _update(obj, field, value) {
    obj[field] = value;
    return obj;
  }

  _toggleMembership(arr, obj) {
    if (arr.indexOf(obj) !== -1) return this._removeFromArray(arr, obj);
    const ret = arr.slice();
    ret.push(obj);
    return ret;
  }

  _removeFromArray(arr, value) {
    const idx = arr.indexOf(value);
    if (idx > -1) {
      const clone = arr.slice();
      clone.splice(idx, 1);
      return clone;
    }
    return arr;
  }

  _memberIdOf(tag, obj) {
    return `${tag}#${this.controllerValue}_${this.fieldValue}_${obj}`
  }
}
