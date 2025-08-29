class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.to_api(**options)
    ActiveModelSerializers::SerializableResource.new(current_scope, **options)
  end

  def to_api(**options)
    ActiveModelSerializers::SerializableResource.new(self, **options)
  end
end
