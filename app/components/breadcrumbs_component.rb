# frozen_string_literal: true

class BreadcrumbsComponent < ViewComponent::Base
  include ComponentHelper

  def initialize(path:)
    @path = path
    raise ArgumentError, "#{@path} is not Array" \
      unless @path.is_a?(Array)
    raise ArgumentError, "#{@path} is empty" \
      if @path.empty?

    @entries = (0..(@path.length - 1)).take_while { |to| !new_record?(@path[to]) }
                                      .filter_map do |to|
      subobj = @path[0..to]
      name = entity_name(subobj.last)
      [name, subobj]
    end
  end

  private

  def obj_url(obj)
    return obj.last.last if obj.last.is_a? Array
    url_for(obj)
  end

  def new_record?(obj)
    return obj.new_record? if obj.respond_to? :new_record?
    false
  end
end
