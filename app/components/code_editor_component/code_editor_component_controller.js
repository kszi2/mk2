import {Controller} from "@hotwired/stimulus";
import {CodeJar} from 'codejar';
import hljs from 'highlight.js';
import $ from 'jquery';

export default class extends Controller {
  static targets = ["editor", "holder"]
  static values = {
    language: String,
    editable: Boolean,
  }

  connect() {
    const hljsHighlighter = (e) => {
      delete e.dataset.highlighted;
      hljs.highlightElement(e)
    };
    $(this.editorTarget)
      .html("")
      .removeClass("language-none")
      .addClass(`language-${this.languageValue || "none"}`)
    const opts = {tab: "    "};

    this.jar = CodeJar(this.editorTarget, hljsHighlighter, opts)
    this.jar.updateCode($(this.holderTarget).val());
    this.jar.onUpdate((text) => {
      $(this.holderTarget).val(text);
      this.jar.recordHistory();
    });
    this.editorTarget.contentEditable = this.editableValue;
  }

  focusEditor() {
    $(this.editorTarget).focus();
  }
}
