# frozen_string_literal: true

class BreadcrumbsComponent < ViewComponent::Base
  include ComponentHelper

  def initialize(path:)
    @path = path
    raise ArgumentError, "#{@path} is not Array" \
      unless @path.is_a?(Array)
    raise ArgumentError, "#{@path} is empty" \
      if @path.empty?

    @entries = (0..(@path.length - 1)).take_while { |to| !@path[to].new_record? }
                                      .filter_map do |to|
      subobj = @path[0..to]
      name = entity_name(subobj.last)
      [name, subobj] unless name.nil?
    end
  end
end
