require 'test_helper'

class Nginx::Conf::ParserTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Nginx::Conf::Parser::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
