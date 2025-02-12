# frozen_string_literal: true

require 'test_helper'

class SizeableTest < ActiveSupport::TestCase
  class Sut
    include Sizable

    def initialize(size) = self.size = size
  end

  test "size can be read" do
    sut = Sut.new(:medium)
    assert_equal :medium, sut.size
  end

  test "size can be modified" do
    sut = Sut.new(:medium)
    sut.size = :large
    assert_equal :large, sut.size
  end

  %i[small normal medium large].each do |size|
    test "size_style returns non-empty string for valid size #{size}" do
      sut = Sut.new(size)
      refute_empty sut.size_styles
    end
  end

  test "size_style returns same for normal and medium sizes" do
    normal = Sut.new(:normal)
    medium = Sut.new(:medium)
    assert_equal normal.size_styles, medium.size_styles
  end

  test "size_style raises for invalid size" do
    assert_raises ArgumentError, /my_size_value/ do
      Sut.new(:my_size_value).size_styles
    end
  end
end
