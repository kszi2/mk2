# frozen_string_literal: true

class ButtonComponentPreview < ViewComponent::Preview
  # @param type select { choices: [basic, primary, secondary, cancel, destroy] }
  # @param text text
  # @param href url
  # @param size select { choices: [small, normal, large] }
  def default(type: :basic, text: 'text', href: '#', size: :normal)
    render(Inputs::ButtonComponent.new(type: type, text: text, href: href, size: size))
  end

  # @param type select { choices: [basic, primary, secondary, cancel, destroy] }
  # @param text text
  # @param href url
  # @param size select { choices: [small, normal, large] }
  # @param icon_name text
  def with_icon(type: :basic, text: 'text', href: '#', size: :normal, icon_name: "fa-chevron-right")
    render Inputs::ButtonComponent.new(type: type, text: nil, href: href, size: size) do |r|
      r.with_prefix do
        tag.i class: "fa-regular #{icon_name}"
      end

      text
    end
  end
end
