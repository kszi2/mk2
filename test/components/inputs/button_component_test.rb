# frozen_string_literal: true

require 'test_helper'

class Inputs::ButtonComponentTest < ViewComponent::TestCase
  Sut = Inputs::ButtonComponent

  test "does render" do
    render_inline Sut.new(type: :basic, text: "text", href: nil)
    assert_component_rendered
  end

  test "renders as button tag if href is blank" do
    render_inline Sut.new(type: :basic, text: "text", href: nil)
    assert_component_rendered

    assert_css "button", text: "text"
  end

  test "renders as a tag if href is not blank" do
    render_inline Sut.new(type: :basic, text: "text", href: "/path")
    assert_component_rendered

    assert_css "a[href='/path']", text: "text"
  end

  test "renders prefix slot if given" do
    render_inline Sut.new(type: :basic, text: "text", href: "/path") do |b|
      b.with_prefix { "prefix" }
    end
    assert_component_rendered

    assert_text "prefix"
  end

  test "enabled false renders disabled button" do
    render_inline Sut.new(type: :basic, text: "text", href: nil, enabled: false)
    assert_component_rendered

    assert_css "button[disabled]", text: "text"
  end

  test "button type is passed to button tag's type" do
    render_inline Sut.new(type: :basic, text: "text", href: nil, button_type: "submit")
    assert_component_rendered

    assert_css "button[type='submit']", text: "text"
  end

  test "button type ignored for anchors" do
    render_inline Sut.new(type: :basic, text: "text", href: "/path", button_type: "submit")
    assert_component_rendered

    assert_css "a[href='/path']", text: "text"
  end

  %i[all grouped no_border].each do |style|
    test "rounding style returns non-nil string for #{style}" do
      sut = Sut.new(type: :basic, text: "text", href: nil, rounding: style)
      refute_nil sut.rounding_styles
    end
  end

  %i[basic primary secondary cancel destroy].each do |style|
    test "color style returns non-nil string for #{style}" do
      sut = Sut.new(type: style, text: "text", href: nil)
      refute_nil sut.color_styles
    end
  end

  test "color_styles raises for invalid style" do
    assert_raises ArgumentError, "button type" do
      sut = Sut.new(type: :unknown, text: "text", href: nil)
      sut.color_styles
    end
  end

  test "color_styles raises for invalid grouping" do
    assert_raises ArgumentError, "button type" do
      sut = Sut.new(type: :basic, text: "text", href: nil, rounding: :unknown)
      sut.rounding_styles
    end
  end
end
