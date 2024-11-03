# frozen_string_literal: true

module Sizable
  attr_accessor :size

  def size_styles
    case @size
    when :small
      'text-sm py-1 px-3'
    when :normal, :medium
      'text-base py-2 px-5'
    when :large
      'text-lg py-3 px-7'
    else
      raise ArgumentError, "Unexpected value for size in Sizable: #{@size}"
    end
  end
end
