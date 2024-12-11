# frozen_string_literal: true

# # PublicFindable
#
# Helper concern for all models, that automatically provides the public id
# interface. Should be included with the prefix supplied in brackets.
#
#   class MyModel < ApplicationRecord
#     extend PublicFindable["Prefix"]
#   end
module PublicFindable
  def self.[](prefix)
    Module.new do
      define_method(:id_prefix) { prefix }

      define_method(:public_find) do |pid|
        self.find(ApplicationRecord.decode_id(self, pid))
      end
    end
  end
end
