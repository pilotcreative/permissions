module Exceptions
  class UnathorizedAccess < StandardError; end
end

ActionController::Base.send(:rescue_from, Exceptions::UnathorizedAccess, :with => :forbidden)

def forbidden
   render_optional_error_file 403
end