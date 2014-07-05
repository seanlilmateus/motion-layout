module Motion
  class Expression < BlankSlate
    attr_reader :attribute, :relation, :multiplier, :constant, :other, :view

    LAYOUT_ATTRIBUTES = ::Hash[
      :left,     ::NSLayoutAttributeLeft,
      :right,    ::NSLayoutAttributeRight,
      :top,      ::NSLayoutAttributeTop,
      :bottom,   ::NSLayoutAttributeBottom,
      :leading,  ::NSLayoutAttributeLeading,
      :trailing, ::NSLayoutAttributeTrailing,
      :width,    ::NSLayoutAttributeWidth,
      :height,   ::NSLayoutAttributeHeight,
      :centerX,  ::NSLayoutAttributeCenterX,
      :centerY,  ::NSLayoutAttributeCenterY,
      :baseline, ::NSLayoutAttributeBaseline,
      :none,     ::NSLayoutAttributeNotAnAttribute
    ]

    # Initializer
    
    def initialize(view)
      @view = view
      @attribute  = ::NSLayoutAttributeNotAnAttribute
      @constant   = 0.0
      @multiplier = 1.0
    end

    def nil?; false; end

    def constraint
      constraint = NSLayoutConstraint.constraintWithItem( self.view,
                                  attribute: self.attribute,
                                  relatedBy: self.relation,
                                     toItem: @other.view,
                                  attribute: @other.attribute,
                                 multiplier: @other.multiplier,
                                   constant: @other.constant)
      # @other = @relation = @attribute = @multiplier = @constant = nil                   
      # constraint
    end

    def == other
      @other = other if other.class == self.class
      @relation = ::NSLayoutRelationEqual
      self
    end

    def >= other
      @other = other if other.class == self.class
      @relation = ::NSLayoutRelationGreaterThanOrEqual
      self
    end

    def <= other
      @other = other if other.class == self.class
      @relation = ::NSLayoutRelationLessThanOrEqual
      self
    end

    def * number
      @multiplier = number.to_f
      self
    end
    
    def / number
      @multiplier = 1.0 / number.to_f
      self
    end
    

    def + number
      @constant = number.to_f
      self
    end

    def - number
      @constant = -number.to_f
      self
    end

    private
      def method_missing(meth, *args, &blk)
        if LAYOUT_ATTRIBUTES.keys.include? meth
          @attribute = LAYOUT_ATTRIBUTES[meth]
          self
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        LAYOUT_ATTRIBUTES.keys.include?(method_name) || super
      end
  end
end
