# frozen_string_literal: true

require 'test_helper'

class BreadcrumbsComponentTest < ViewComponent::TestCase
  test "non-array breadcrumbs component raises on init" do
    assert_raises ArgumentError, match: /Array/ do
      BreadcrumbsComponent.new(path: "string")
    end
  end

  test "empty breadcrumbs component raises on init" do
    assert_raises ArgumentError, match: /empty/ do
      BreadcrumbsComponent.new(path: [])
    end
  end

  test "singular object pair is rendered" do
    render_inline BreadcrumbsComponent.new(path: [%w[name /path/]])
    assert_component_rendered
  end

  test "singular object pair renders name" do
    render_inline BreadcrumbsComponent.new(path: [%w[name /path/]])
    assert_component_rendered
    assert_text "name"
  end

  test "singular object pair renders link" do
    render_inline BreadcrumbsComponent.new(path: [%w[name /path/]])
    assert_component_rendered
    assert_css "a[href='/path/']"
  end

  test "model renders its name" do
    render_inline BreadcrumbsComponent.new(path: [courses(:course1)])
    assert_component_rendered

    assert_text courses(:course1).name
  end

  test "model renders its path" do
    render_inline BreadcrumbsComponent.new(path: [courses(:course1)])
    assert_component_rendered

    assert_css "a[href*='/courses/#{courses(:course1).public_id}']"
  end

  test "new record is not rendered" do
    render_inline BreadcrumbsComponent.new(path: [courses(:course1), CourseType.new(course: courses(:course1), name: "type")])
    assert_component_rendered

    refute_text "type"
  end
end
