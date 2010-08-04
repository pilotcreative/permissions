module Exceptions
  class UnauthorizedAccess < StandardError; end
end

ActionDispatch::ShowExceptions.rescue_responses.update({'Exceptions::UnauthorizedAccess' => :forbidden})