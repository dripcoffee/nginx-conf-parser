#require "pp"

module Conf
  class Transform
    include Parslet

    attr_reader :t
    def initialize
      @t = Parslet::Transform.new

      t.rule(:command => simple(:cmd)) do
        cmd.to_sym
      end

      t.rule(:parameter => simple(:param)) do
        param
      end

      t.rule(:comment => simple(:comment)) do
        comment
      end

      t.rule(:block => subtree(:block)) do
        block
      end

      t.rule(:integer => simple(:int)) do
        Integer(int)
      end

      t.rule(:string => simple(:str)) do
        str
      end

      t.rule(:variable => simple(:var)) do
        "var_" << var
      end
    end
    
    def do(tree)
      t.apply(tree)
    end
  end
end