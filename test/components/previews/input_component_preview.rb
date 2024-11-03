# frozen_string_literal: true

class InputComponentPreview < ViewComponent::Preview
  # @param type select { choices: [text, email, password, number, date, time, datetime, url, tel] }
  # @param name text
  # @param value text
  # @param enabled toggle
  # @param errored toggle
  # @param size select { choices: [small, normal, large] }
  def default(type: :text, name: "name", enabled: true, errored: false, size: :normal, value: "")
    ic = InputComponent.new(type: type, name: name, value: value, enabled: enabled, size: size)
    ic.errored = errored
    render ic
  end
end
