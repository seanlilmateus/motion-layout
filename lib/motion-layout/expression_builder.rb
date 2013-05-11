module Motion
  class ExpressionBuilder
    def initialize(view, hash={}, &block)
      @view     = view
      @subviews = hash
      self.instance_eval(&block)
    end
            
    def apply!
      contraint = nil
      @subviews.keys.each do |key|
        meth = self.send(key)
        contraint = meth.constraint if meth.other
      end
      contraint
    end
  
    def view
      @superview ||= create_expression @view
    end
    
    private
    def method_missing(meth, *args, &blk)
      if @subviews.keys.include? meth.to_s
        if self.instance_variable_get("@#{meth}").nil?
          expression = create_expression @subviews[meth.to_s]
          self.instance_variable_set("@#{meth}", expression)
          define_singleton_method(meth) { self.instance_variable_get("@#{meth}") }
        end
        self.instance_variable_get("@#{meth}")
      else
        raise "Unkown view with name #{meth}"
      end
    end
    
    def create_expression view
      expression = LayoutExpression.new
      expression.view = view
      expression
    end
    
    def respond_to_missing?(method_name, include_private = false)
      @subviews.keys.include?(method_name.to_s) || super
    end
  end
end