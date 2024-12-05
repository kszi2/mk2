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
    erb.result(render.get_binding)
  end

  class RenderEncapsulation
    # provide the helpers
    include MarkedPointsHelper
    include MarkingNotesHelper

    attr_reader :submission

    def initialize(submission)
      @submission = submission
    end

    def get_binding
      binding
    end
  end
end
