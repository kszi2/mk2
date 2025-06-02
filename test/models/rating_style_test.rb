require "test_helper"

class RatingStyleTest < ActiveSupport::TestCase
  setup do
    @rating_style = RatingStyle.new(name: "Test Style")
  end

  # Test PublicFindable functionality
  test "should include PublicFindable with prefix 'rS'" do
    assert_equal "rS", RatingStyle.id_prefix
    assert_respond_to RatingStyle, :public_find
    assert_respond_to @rating_style, :public_id
  end

  # Test validations
  test "should be valid with valid attributes" do
    assert @rating_style.valid?
  end

  test "should not be valid without a name" do
    @rating_style.name = nil
    refute @rating_style.valid?
    assert_includes @rating_style.errors[:name], "can't be blank"
  end

  test "should not be valid with a too short name" do
    @rating_style.name = "A"
    refute @rating_style.valid?
    assert_includes @rating_style.errors[:name], "is too short (minimum is 2 characters)"
  end

  test "should not be valid with a too long name" do
    @rating_style.name = "A" * 65
    refute @rating_style.valid?
    assert_includes @rating_style.errors[:name], "is too long (maximum is 64 characters)"
  end

  test "should not be valid with a duplicate name" do
    # First save the original style
    @rating_style.save!

    # Create a duplicate
    duplicate_style = RatingStyle.new(name: "Test Style")
    refute duplicate_style.valid?
    assert_includes duplicate_style.errors[:name], "has already been taken"
  end

  # Test instance methods
  test "source_as_text should return the content of erb_source" do
    file_content = "<h1>Test ERB Template</h1>"
    Tempfile.create(['test_template', '.erb']) do |file|
      file.write(file_content)
      file.rewind

      @rating_style.erb_source.attach(
        io: file,
        filename: 'test_template.erb',
        content_type: 'text/plain'
      )
      @rating_style.save!

      assert_equal file_content, @rating_style.source_as_text
    end
  end

  test "source_as_text should handle empty files" do
    Tempfile.create(['empty_template', '.erb']) do |file|
      @rating_style.erb_source.attach(
        io: file,
        filename: 'empty_template.erb',
        content_type: 'text/plain'
      )
      @rating_style.save!

      assert_equal "", @rating_style.source_as_text
    end
  end
end
