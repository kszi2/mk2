require "test_helper"

# Test model to verify ApplicationRecord functionality
class TestModel < ApplicationRecord
  def self.id_prefix
    "TST"
  end

  validates :name, presence: true
end

class ApplicationRecordTest < ActiveSupport::TestCase
  setup do
    # Ensure the TestModel table exists for testing
    ActiveRecord::Base.connection.create_table(:test_models, temporary: true) do |t|
      t.string :name
      t.timestamps
    end

    @test_model = TestModel.create!(name: "Test Record")
  end

  teardown do
    # Drop the temporary table
    ActiveRecord::Base.connection.drop_table(:test_models, if_exists: true)
  end

  test "default scope excludes negative IDs" do
    # Create a record with a negative ID
    negative_record = TestModel.new(name: "Negative Record")
    negative_record.id = -1
    negative_record.save(validate: false)

    # Verify it's not returned in queries
    refute_includes TestModel.all, negative_record
  end

  test "to_param returns public_id" do
    @test_model.stubs(:public_id).returns("TST12345")
    assert_equal "TST12345", @test_model.to_param
  end

  test "id_prefix raises ArgumentError if not defined in model" do
    # Anonymous class without id_prefix defined
    klass = Class.new(ApplicationRecord)
    assert_raises ArgumentError do
      klass.id_prefix
    end
  end

  test "public_id encodes the model ID" do
    ApplicationRecord.stubs(:encode_id).with(TestModel, @test_model.id).returns("ENCODED_ID")
    assert_equal "ENCODED_ID", @test_model.public_id
  end

  test "public_id= decodes and sets the ID" do
    ApplicationRecord.stubs(:decode_id).with(TestModel, "ENCODED_ID").returns(42)
    @test_model.public_id = "ENCODED_ID"
    assert_equal 42, @test_model.id
  end

  test "encode_id with one argument uses self as model" do
    ApplicationRecord.stubs(:wrap_id).with("TST", 123).returns("WRAPPED_ID")
    Crockford32.stubs(:encode).with("WRAPPED_ID", check: true).returns("ENCODED_ID")

    assert_equal "ENCODED_ID", TestModel.encode_id(123)
  end

  test "encode_id with two arguments uses provided model and id" do
    ApplicationRecord.stubs(:wrap_id).with("TST", 123).returns("WRAPPED_ID")
    Crockford32.stubs(:encode).with("WRAPPED_ID", check: true).returns("ENCODED_ID")

    assert_equal "ENCODED_ID", ApplicationRecord.encode_id(TestModel, 123)
  end

  test "decode_id with one argument uses self as model" do
    Crockford32.stubs(:decode).with("ENCODED_ID", check: true, into: :string).returns("WRAPPED_ID")
    ApplicationRecord.stubs(:unwrap_id).with("WRAPPED_ID", "TST").returns(123)

    assert_equal 123, TestModel.decode_id("ENCODED_ID")
  end

  test "decode_id with two arguments uses provided model and pid" do
    Crockford32.stubs(:decode).with("ENCODED_ID", check: true, into: :string).returns("WRAPPED_ID")
    ApplicationRecord.stubs(:unwrap_id).with("WRAPPED_ID", "TST").returns(123)

    assert_equal 123, ApplicationRecord.decode_id(TestModel, "ENCODED_ID")
  end

  test "wrap_id combines prefix and id using XOR" do
    prefix = "TST"
    id = 42
    lengthened_prefix = "TS"

    ApplicationRecord.stubs(:lengthen_prefix).with(prefix, id.to_s).returns(lengthened_prefix)
    ApplicationRecord.stubs(:xor_s).with(id.to_s, lengthened_prefix).returns("WRAPPED_ID")

    assert_equal "WRAPPED_ID", ApplicationRecord.wrap_id(prefix, id)
  end

  test "unwrap_id extracts integer ID from wrapped value" do
    prefix = "TST"
    wrapped = "WRAPPED_ID"
    lengthened_prefix = "TS"

    ApplicationRecord.stubs(:lengthen_prefix).with(prefix, wrapped).returns(lengthened_prefix)
    ApplicationRecord.stubs(:xor_s).with(wrapped, lengthened_prefix).returns("42")

    assert_equal 42, ApplicationRecord.unwrap_id(wrapped, prefix)
  end

  test "xor_s performs XOR operation on string bytes" do
    a = "ABC"
    b = "XYZ"

    # ASCII values: A=65, X=88, XOR=25; B=66, Y=89, XOR=27; C=67, Z=90, XOR=29
    expected = [25, 27, 25].pack('C*')

    assert_equal expected, ApplicationRecord.xor_s(a, b)
  end

  test "lengthen_prefix repeats prefix to match target length (exact multiple)" do
    prefix = "AB"
    to_encode = "1234"

    # Should repeat prefix 2 times (4/2)
    assert_equal "ABAB", ApplicationRecord.lengthen_prefix(prefix, to_encode)
  end

  test "lengthen_prefix repeats prefix and adds part to match target length (with remainder)" do
    prefix = "ABC"
    to_encode = "12345"

    # Should repeat prefix once (3 chars) and add first 2 chars of prefix (5%3=2)
    assert_equal "ABCAB", ApplicationRecord.lengthen_prefix(prefix, to_encode)
  end

  test "decode_id should reverse encode_id" do
    original_id = 42

    # Don't stub the methods for this test to verify actual behavior
    encoded = TestModel.encode_id(original_id)
    decoded = TestModel.decode_id(encoded)

    assert_equal original_id, decoded
  end

  test "different models with same ID get different public IDs" do
    # Create another test model class with a different prefix
    other_model = Class.new(ApplicationRecord) do
      def self.name
        "OtherModel"
      end

      def self.id_prefix
        "OTH"
      end
    end

    # Same ID, different models
    id = 42

    first_encoded = TestModel.encode_id(id)
    second_encoded = other_model.encode_id(id)

    refute_equal first_encoded, second_encoded
  end
end
