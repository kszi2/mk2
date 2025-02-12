# frozen_string_literal: true

class BreadcrumbsComponent::LinkComponentTest < ViewComponent::TestCase
  Sut = BreadcrumbsComponent::LinkComponent

  test "does render" do
    render_inline Sut.new(url: "/")
    assert_component_rendered
  end

  test "renders content given" do
    render_inline Sut.new(url: "/").with_content("Content")
    assert_component_rendered
    assert_text "Content"
  end

  test "renders given url as anchor" do
    render_inline Sut.new(url: "/this/is/a/path").with_content("Content")
    assert_component_rendered
    assert_css "a[href='/this/is/a/path']"
  end
end
