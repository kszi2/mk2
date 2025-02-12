# frozen_string_literal: true

require 'test_helper'

class DataTableComponent::FilterComponentTest < ViewComponent::TestCase
  Sut = DataTableComponent::FilterComponent
  Controller = "submissions"

  test "does render" do
    render_inline Sut.new(controller: Controller, field: :field, clear_url: "/clear", filter_url: "/filter")
    assert_component_rendered
  end

  test "renders form with hidden value for field for given controller and field" do
    render_inline Sut.new(controller: Controller, field: :student, clear_url: "/clear", filter_url: "/filter")
    assert_component_rendered

    assert_css "form##{Controller}_student_form > input[type='hidden'][name='filter_field'][value='student']",
               visible: false
  end

  test "without name filter is named humanized field" do
    render_inline Sut.new(controller: Controller, field: :student, clear_url: "/clear", filter_url: "/filter")
    assert_component_rendered

    assert_text "Filter Student"
  end

  test "with name filter is named the given name" do
    render_inline Sut.new(controller: Controller, field: :student, name: 'asdasdasd', clear_url: "/clear", filter_url: "/filter")
    assert_component_rendered

    assert_text "Filter asdasdasd"
  end

  test "renders button to clear filter" do
    render_inline Sut.new(controller: Controller, field: :student, clear_url: "/clear", filter_url: "/filter")
    assert_component_rendered

    assert_link "Clear", visible: false
  end

  test "renders button to apply filter" do
    render_inline Sut.new(controller: Controller, field: :student, clear_url: "/clear", filter_url: "/filter")
    assert_component_rendered

    assert_link "Filter", visible: false
  end
end