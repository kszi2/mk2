# frozen_string_literal: true

class Shells::ShellComponent::ResourceControlsComponent < ViewComponent::Base
  include Inputs

  def initialize(edit: nil, back: nil)
    @edit = edit
    @back = back
  end

  def before_render
    @edit = url_for(action: :edit) unless @edit
    @back = url_for(:back) unless @back
  end
end
