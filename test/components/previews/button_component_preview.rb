# frozen_string_literal: true

class ButtonComponentPreview < ViewComponent::Preview
  # @param type select { choices: [basic, primary, secondary, cancel, destroy] }
  # @param text text
  # @param href url
  # @param size select { choices: [small, normal, large] }
  def default(type: :basic, text: 'text', href: '#', size: :normal)
    render(ButtonComponent.new(type: type, text: text, href: href, size: size))
  end
end
