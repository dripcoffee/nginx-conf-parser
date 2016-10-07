require 'test_helper'

class ParserTest < Minitest::Test
  def setup
    @parser = Conf::Parser.new
  end

  def test_that_it_has_a_version_number
    refute_nil ::Conf::VERSION
  end

  def test_stmt_without_param
    content = <<-EOB
    eva;
    EOB

    result = @parser.parse_with_debug(content)

    assert_equal "eva", result[0][:statement][:command]
  end

  def test_stmt_with_string_param
    content = <<-EOB
    user  "www-data";
    EOB

    result = @parser.parse_with_debug(content)

    assert_equal "user", result[0][:statement][0][:command]
    assert_equal "www-data", result[0][:statement][1][:string]
  end

  def test_stmt_with_integer_param
    content = <<-EOB
    worker_connections  1024;
    EOB

    result = @parser.parse_with_debug(content)

    assert_equal "worker_connections", result[0][:statement][0][:command]
    assert_equal "1024", result[0][:statement][1][:integer]
  end

  def test_stmt_with_var_param
    content = <<-EOB
    set  $aaa  1;
    EOB

    result = @parser.parse_with_debug(content)

    assert_equal "set", result[0][:statement][0][:command]
    assert_equal "aaa", result[0][:statement][1][:variable]
  end

  def test_comment
    content = <<-EOB
    #error_log  logs/error.log;
    EOB

    result = @parser.parse_with_debug(content)

    assert_equal "#error_log  logs/error.log;", result[0][:comment]
  end

  def test_block
    content = <<-EOB
    events {
      worker_connections  1024;
    }
    EOB

    result = @parser.parse_with_debug(content)

    expect = [
      {
        :statement => [
          {
            :command => "worker_connections"
          },
          {
            :integer => "1024"
          }
        ]
      }
    ]

    assert_equal expect, result[0][:block]
  end
end
