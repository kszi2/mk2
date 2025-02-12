SimpleCov.start 'rails' do
  enable_coverage :branch

  add_filter "/test/"
  add_filter "/db/"
  add_filter "/config/"
  add_filter do |src|
    # filters empty class/module definitions
    src.relevant_lines < 2
  end

  add_group "View", "app/components"
  add_group "Policies", "app/policies"
end