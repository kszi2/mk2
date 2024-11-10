# frozen_string_literal: true

module Filterable
  protected

  def inner_filter_for(type, &block)
    field = params.require(:field)
    unless type.new.respond_to?(field)
      logger.warn("Invalid field `#{field}' as filter to Submission controller")
      return index
    end
    @filter_field = field
    @filter_ctrl = type.name.to_s.underscore.pluralize

    filtered = block.call(type)
    refl = type.reflect_on_association(field)
    if not refl.nil?
      # field is another model
      fields = filtered.pluck("#{field}_id")
      @fields = refl.klass.where(id: fields)
      if refl.klass.new.respond_to?(:name)
        @fields = @fields.order(:name)
      end
    else
      # field is a primitive attribute
      @fields = filtered.order(field).pluck(field)
    end

  end

  def construct_filter_obj(type, permitted)
    f = params[:f] || {}
    @prev_filter = f
    return {} if f.blank?

    f.permit(*permitted).to_hash.filter_map do |field, values|
      obj = type.new
      if obj.respond_to?(field)
        { field => values }
      elsif obj.respond_to?("#{field}_id")
        { "#{field}_id": values.map(&:to_i) }
      end
    end.inject(&:merge)
  end
end
