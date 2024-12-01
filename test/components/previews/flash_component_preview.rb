# frozen_string_literal: true

class FlashComponentPreview < ViewComponent::Preview
  # @param type select { choices: [success, notice, alert] }
  # @param title text
  # @param body_text text
  def default(type: :notice, title: "title", body_text: "body")
    render(FlashComponent.new(type: type, title: title, body_text: body_text))
  end
end
