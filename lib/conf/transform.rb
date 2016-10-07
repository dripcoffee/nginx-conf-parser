module Conf
  class Transform
    include Parslet

    attr_reader :t
    def initialize
      @t = Parslet::Transform.new
    end
    
    def do(tree)
      t.apply(tree)
    end
  end
end