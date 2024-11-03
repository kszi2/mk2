# frozen_string_literal: true

class BreadcrumbsComponent < ViewComponent::Base
  def initialize(path:)
    @path = path
    raise ArgumentError, "#{@path} is not Array" \
      unless @path.is_a?(Array)
    raise ArgumentError, "#{@path} is empty" \
      if @path.empty?

    @entries = (0..(@path.length - 1)).map do |to|
      subobj = @path[0..to]
      [entity_name(subobj.last), subobj]
    end
  end

  private

  def entity_name(obj)
    if obj.respond_to?(:name)
      obj.name
    elsif obj.respond_to?(:render_as)
      obj.render_as
    else
      "#{obj.class.name.underline}##{obj.id}"
    end
  end
end
