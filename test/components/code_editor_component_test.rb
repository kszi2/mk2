# frozen_string_literal: true

require 'test_helper'

class CodeEditorComponentTest < ViewComponent::TestCase
  Sut = CodeEditorComponent

  test "does render" do
    render_inline Sut.new(id: 'asd',
                          form_name: 'form_elem',
                          lang: "ruby")
    assert_component_rendered
  end

  test "renders label if given" do
    render_inline Sut.new(id: 'asd',
                          form_name: 'form_elem',
                          lang: "ruby") do |sut|
      sut.with_label { "Label text" }
    end
    assert_component_rendered

    assert_text "Label text"
  end

  test "renders hidden input with given form name" do
    render_inline Sut.new(id: 'asd',
                          form_name: 'form_elem',
                          lang: "ruby") do |sut|
      sut.with_label { "Label text" }
    end
    assert_component_rendered

    assert_css "input[type='hidden'][name='form_elem']",
               visible: false
  end

  test "renders hidden input with preloaded value" do
    render_inline Sut.new(id: 'asd',
                          form_name: 'form_elem',
                          lang: "ruby",
                          value: "def a = 1") do |sut|
      sut.with_label { "Label text" }
    end
    assert_component_rendered

    assert_css "input[type='hidden'][name='form_elem'][value='def a = 1']",
               visible: false
  end

  test "renders div with given id" do
    render_inline Sut.new(id: 'asd',
                          form_name: 'form_elem',
                          lang: "ruby",
                          value: "def a = 1") do |sut|
      sut.with_label { "Label text" }
    end
    assert_component_rendered

    assert_css "div#asd"
  end
end
