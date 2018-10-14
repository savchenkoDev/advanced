module ApplicationHelper
  def resource_name(resource)
    resource.class.name.underscore.to_s
  end 
end
