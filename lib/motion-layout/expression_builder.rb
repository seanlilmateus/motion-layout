module Motion
  class ExpressionBuilder
    def initialize(view, hash={}, &block)
      @view, @subviews = view, hash
      self.instance_eval(&block)
    end

    def apply!
      result = instance_values.values
                              .select { |value| value.class == Expression }
                              .reject { |value| value.other.nil? }
                              .map    { |value| value.constraint }
                              .first
      @subviews = @superview = @main_view = nil
      result
    end

    def superview
      @superview ||= Expression.new @view
    end
    
    private
    
      def method_missing(meth, *args, &blk)
        if @subviews.keys.include? meth.to_s
          unless self.instance_variable_get("@#{meth}")
            expression = Expression.new @subviews[meth.to_s]
            self.instance_variable_set("@#{meth}", expression)
            define_singleton_method(meth) { self.instance_variable_get("@#{meth}") }
          end
          self.instance_variable_get("@#{meth}")
        else
          raise "Unkown view with name #{meth}"
        end
      end

      def instance_values
        Hash[instance_variables.map { |name| [name[1..-1], instance_variable_get(name)] }]
      end
      
      def respond_to_missing?(method_name, include_private = false)
        @subviews.keys.include?(method_name.to_s) || super
      end
  end
end
