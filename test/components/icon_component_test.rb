# frozen_string_literal: true

require 'test_helper'

class IconComponentTest < ViewComponent::TestCase
  Sut = IconComponent

  test "does render" do
    render_inline Sut.new(name: "x-mark")
    assert_component_rendered
  end

  test "renders i tag with class given" do
    render_inline Sut.new(name: "x-mark")
    assert_component_rendered

    assert_css "i.fa-x-mark"
  end

  test "renders i tag with extra classes" do
    render_inline Sut.new(name: "x-mark", classes: "my-class1 my-class2")
    assert_component_rendered

    assert_css "i.fa-x-mark.my-class1.my-class2"
  end
end
