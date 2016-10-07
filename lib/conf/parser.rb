module Conf
  class Parser < Parslet::Parser
    root :body

    rule :body do
      space? >> (statement | block | comment).repeat >> space?
    end

    # A statement is a Nginx command with parameters
    rule :statement do
      space? >> (command.as(:command) >> (space >> parameter).repeat).as(:statement) >> space? >> delimiter >> space?
    end

    rule :comment do
      space? >> (str("#") >> (newline.absent? >> any).repeat).as(:comment) >> space?
    end

    rule :block do
      space? >> (block_identifier >> space.repeat >> parameter.repeat >> space.repeat >> str("{") >> body >> str("}")).as(:block) >> space?
    end

    rule :command do
      match('[a-zA-Z]') >> match('\w').repeat
    end

    rule :parameter do
      string | variable | integer
    end

    rule :block_identifier do
      str("events") | str("http") | str("server") | str("location") | str("if")
    end

    rule :variable do
      str('$') >> (match('[a-zA-Z]') >> match('\w').repeat).as(:variable)
    end

    rule :integer do
      ((str('+') | str('-')).maybe >> match("[0-9]").repeat(1)).as(:integer)
    end
    
    rule :string do
      str('"') >> (
        str('\\') >> any |
        str('"').absent? >> any 
      ).repeat.as(:string) >> str('"')
    end

    rule :space do
      match('\s').repeat(1)
    end

    rule :space? do
      space.maybe
    end

    rule :newline do
      str("\n") >> str("\r").maybe
    end

    rule :delimiter do
      str(";")
    end
  end
end