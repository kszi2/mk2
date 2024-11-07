# frozen_string_literal: true

class SelectComponentPreview < ViewComponent::Preview
  # @param name text
  # @param value text
  # @param enabled toggle
  # @param errored toggle
  # @param size select { choices: [small, normal, large] }
  def without_options(name: "name", value: nil, enabled: true, errored: false, size: :normal)
    render SelectComponent.new(name: name, value: value, enabled: enabled, size: size) do |sc|
      sc.errored = errored
      sc.with_label { "Without options" }
    end
  end

  # @param name text
  # @param value number
  # @param enabled toggle
  # @param errored toggle
  # @param size select { choices: [small, normal, large] }
  def with_options(name: "name", value: 2, enabled: true, errored: false, size: :normal)
    render SelectComponent.new(name: name, value: value, enabled: enabled, size: size) do |sc|
      sc.errored = errored
      sc.with_label { "With options" }
      sc.with_option(value: 1, current: value) { "AAAA" }
      sc.with_option(value: 2, current: value) { "BBBB" }
      sc.with_option(value: 3, current: value) { "CCCC" }
    end
  end

  # @param name text
  # @param enabled toggle
  # @param errored toggle
  # @param size select { choices: [small, normal, large] }
  def with_default_empty(name: "name", enabled: true, errored: false, size: :normal)
    render SelectComponent.new(name: name, value: nil, enabled: enabled, size: size) do |sc|
      sc.errored = errored
      sc.with_label { "With options" }
      sc.with_option { "" }
      sc.with_option(value: 1) { "AAAA" }
      sc.with_option(value: 2) { "BBBB" }
      sc.with_option(value: 3) { "CCCC" }
    end
  end
end
