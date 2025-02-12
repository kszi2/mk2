require "test_helper"

class TemplateTest < ActiveSupport::TestCase
  setup do
    @template = Template.new(name: "Sample Template", data: "Some data")
  end

  test "template can be found by public id" do
    assert_respond_to Template, :public_find
    assert_respond_to @template, :public_id
  end

  test "valid template should be valid" do
    assert @template.valid?
  end

  test "name should be present" do
    @template.name = ""
    refute @template.valid?
    assert @template.errors.added?(:name, :blank)
  end

  test "name length should be within range" do
    @template.name = "A"
    refute @template.valid?

    @template.name = "A" * 65
    refute @template.valid?
  end

  test "data should be present" do
    @template.data = ""
    refute @template.valid?
    assert @template.errors.added?(:data, :blank)
  end

  test "course association should be optional" do
    @template.course = nil
    assert @template.valid?
  end
end
