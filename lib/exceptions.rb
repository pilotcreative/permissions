module Exceptions
  class UnathorizedAccess < StandardError; end
end

ActionDispatch::ShowExceptions.rescue_responses.update({'Exceptions::UnathorizedAccess' => :forbidden})