module Motion
  class Layout
    def initialize(&block)
      @verticals   = []
      @horizontals = []
      @metrics     = {}
      @constraints = []
      yield WeakRef.new(self)
      strain
    end

    def constraint(priority=NSLayoutPriorityDefaultHigh, &blk)
      constraint = ExpressionBuilder.new( WeakRef.new(@view), @subviews, &blk).apply!
      constraint.priority = priority
      @constraints << constraint if constraint.is_a?(NSLayoutConstraint)
    end

    def metrics(metrics)
      @metrics = Hash[metrics.keys.map(&:to_s).zip(metrics.values)]
    end

    def subviews(subviews)
      @subviews = Hash[subviews.keys.map(&:to_s).zip(subviews.values)]
    end

    def view(view)
      @view = view
    end

    def horizontal(horizontal, opts=NSLayoutFormatDirectionLeadingToTrailing)
      @horizontals << [horizontal, opts]
    end

    def vertical(vertical, opts=NSLayoutFormatDirectionLeadingToTrailing)
      @verticals << [vertical, opts]
    end

    private

    def strain
      @subviews.values.each do |subview|
        subview.translatesAutoresizingMaskIntoConstraints = false
        @view.addSubview(subview)
      end

      constraints = []
      constraints += @verticals.map do |vertical, option|
        NSLayoutConstraint.constraintsWithVisualFormat("V:#{vertical}", options:option, metrics:@metrics, views:@subviews)
      end
      constraints += @horizontals.map do |horizontal, option|
        NSLayoutConstraint.constraintsWithVisualFormat("H:#{horizontal}", options:option, metrics:@metrics, views:@subviews)
      end

      @view.addConstraints(constraints.flatten)
      @view.addConstraints(@constraints.flatten)
    end
  end
end
