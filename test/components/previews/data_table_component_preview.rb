# frozen_string_literal: true

class DataTableComponentPreview < ViewComponent::Preview
  def default
    render(DataTableComponent.new(objects: "objects", col_config: "col_config"))
  end
end
