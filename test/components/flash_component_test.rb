# frozen_string_literal: true

require 'test_helper'

class FlashComponentTest < ViewComponent::TestCase
  Sut = FlashComponent

  test "does render" do
    render_inline Sut.new(type: :notice, title: "title")
    assert_component_rendered
  end

  test "renders title as second level header" do
    render_inline Sut.new(type: :notice, title: "title")
    assert_component_rendered

    assert_css "h2", text: "title"
  end

  test "renders body if given as text parameter" do
    render_inline Sut.new(type: :notice, title: "title", body_text: "asdasd")
    assert_component_rendered

    assert_text "asdasd"
  end

  test "renders body if given as slot" do
    render_inline Sut.new(type: :notice, title: "title") do |f|
      f.with_body { "asdasd" }
    end
    assert_component_rendered

    assert_text "asdasd"
  end

  test "renders body if given as slot if text is also given" do
    render_inline Sut.new(type: :notice, title: "title", body_text: "bad") do |f|
      f.with_body { "asdasd" }
    end
    assert_component_rendered

    assert_text "asdasd"
  end

  %i[notice success alert].each do |type|
    test "renders icon by default for type #{type}" do
      render_inline Sut.new(type: type, title: "title")
      assert_component_rendered

      assert_css "i:not(:has(> *))"
    end
  end

  test "does not render default icon if given icon slot" do
    render_inline Sut.new(type: :notice, title: "title") do |f|
      f.with_icon { "my-icon" }
    end
    assert_component_rendered

    refute_css "i:not(:has(> *))"
  end

  test "renders icon slot" do
    render_inline Sut.new(type: :notice, title: "title") do |f|
      f.with_icon { "my-icon" }
    end
    assert_component_rendered

    assert_text "my-icon"
  end

  %i[effective_icon border_color bg_color text_color].each do |sym|
    test "#{sym} raises for invalid type" do
      sut = Sut.new(type: :unknown, title: "title")
      assert_raises ArgumentError, "unknown" do
        sut.send(sym)
      end
    end
  end

  test "raises for unknown type during rendering" do
    assert_raises ArgumentError, "unknown" do
      render_inline Sut.new(type: :unknown, title: "title")
    end
  end
end
