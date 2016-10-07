require "parslet"
require "parslet/convenience"
require "pp"

module Conf
  class Parser < Parslet::Parser
    root :body

    rule :body do
      space? >> (statement | block | comment).repeat >> space?
    end

    # A statement is a Nginx command with parameters
    rule :statement do
      space? >> command >> space.repeat >> parameter.repeat >> space? >> delimiter
    end

    rule :command do
      match('[a-zA-Z]') >> match('\w').repeat
    end

    rule :parameter do
      match('[a-zA-Z0-9]') >> match('[a-zA-Z0-9_-]').repeat
    end

    rule :comment do
      space? >> str("#") >> any.repeat >> space.repeat
    end

    rule :block do
      space? >> command >> space? >> parameter.repeat >> space? >> str("{") >> body >> str("}") >> space.repeat
    end

    rule :space do
      match('\s').repeat(1)
    end

    rule :space? do
      space.maybe
    end

    rule :delimiter do
      str(";")
    end
  end
end