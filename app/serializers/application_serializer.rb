class ApplicationSerializer < ActiveModel::Serializer
  def with?(option)
    Array.wrap(instance_options[:with]).include?(option)
  end

  def without?(option)
    Array.wrap(instance_options[:without]).include?(option)
  end
end
