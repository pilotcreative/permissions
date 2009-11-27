require 'exceptions'

module RequirePermissions
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def require_permissions(options = {})
      method = options.delete(:method)
      method ||= :editable_by?
      
      redirect = options.delete(:redirect)
      redirect ||= nil
      
      success = options.delete(:success)
      success ||= lambda {}
      
      failure = options.delete(:failure)
      failure ||= lambda {
        if redirect
          flash[:error] = "You were not authorised to see that page".t
          redirect_to case redirect
          when Symbol then self.send(redirect)
          when Proc then instance_eval &redirect
          else redirect
          end
        else
          raise Exceptions::UnathorizedAccess
        end
      }
      
      options.each do |model, actions|
        actions = {:only => actions} if actions.kind_of? Array
        
        _method = actions.delete(:method) || method
        _method = _method.to_s
        
        _success = actions.delete(:success) || success
        _failure = actions.delete(:failure) || failure
        
        negative = _method.gsub!(/^\!/, '') ? true : false
        name = :"require_#{model}_permissions_#{rand}"
        define_method(name) do
          target = instance_variable_get("@#{model}")
          return false unless target
          condition = target.send(_method.to_sym, current_user)
          condition = negative ? !condition : condition
          if condition
            instance_eval &_success
          else
            instance_eval &_failure
          end
          return condition
        end
        before_filter name, actions
      end
    end
    
    def require_visibility(options = {})
      require_permissions({:method => :visible_to?}.merge(options))
    end
  end
end


ActionController::Base.send(:include, RequirePermissions)