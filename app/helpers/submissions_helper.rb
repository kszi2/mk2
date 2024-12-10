module SubmissionsHelper
  include MarkedPointsHelper

  def render_text(submission, rating_style)
    template = nil
    rating_style.erb_source.open do |file|
      template = File.read(file)
    end
    raise ArgumentError.new("cannot read attached file for style: #{rating_style.name}") \
      unless template

    erb = ERB.new(template, trim_mode: "%-")

    render = RenderEncapsulation.new(submission)
    render.render_via(erb)
  end

  class RenderEncapsulation
    # provide the helpers
    include MarkedPointsHelper
    include MarkingNotesHelper

    attr_reader :submission

    def initialize(submission)
      @submission = submission
    end

    def render_via(renderer)
      renderer.result(binding)
    end
  end
end
