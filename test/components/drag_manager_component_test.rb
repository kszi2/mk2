# frozen_string_literal: true

require 'test_helper'

class DragManagerComponentTest < ViewComponent::TestCase
  Sut = DragManagerComponent

  test "does render" do
    render_inline Sut.new(reorder_url: "/render")
    assert_component_rendered
  end

  test "renders form with given url" do
    render_inline Sut.new(reorder_url: "/render")
    assert_component_rendered

    assert_css "form[action='/render'][method='post']"
  end

  test "renders div with Stimulus controller and .drag-manager class" do
    render_inline Sut.new(reorder_url: "/render")
    assert_component_rendered

    assert_css "div[class*='drag-manager'][data-controller*='drag-manager']"
  end
end