class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  default_scope { where(id: 0..) }
end
