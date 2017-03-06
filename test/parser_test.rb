require "test_helper"

class ParserTest < Minitest::Test
  context "test parser" do
    setup do
      @parser = Conf::Parser.new
    end

    should "has a version number" do
      refute_nil Conf::VERSION
    end

    should "parse stmt without params" do
      content = <<-EOB
      eva;
      EOB

      result = @parser.parse_with_debug(content)

      assert_equal "eva", result[0][:statement][:command]
    end

    should "parse stmt with string param" do
      content = <<-EOB
      user  "www-data";
      EOB

      result = @parser.parse_with_debug(content)

      assert_equal "user", result[0][:statement][0][:command]
      assert_equal "www-data", result[0][:statement][1][:string]
    end

    should "parse stmt with integer param" do
      content = <<-EOB
      worker_connections  1024;
      EOB

      result = @parser.parse_with_debug(content)

      assert_equal "worker_connections", result[0][:statement][0][:command]
      assert_equal "1024", result[0][:statement][1][:integer]
    end

    should "parse stmt with var param" do
      content = <<-EOB
      set  $aaa  1;
      EOB

      result = @parser.parse_with_debug(content)

      assert_equal "set", result[0][:statement][0][:command]
      assert_equal "aaa", result[0][:statement][1][:variable]
    end

    should "parse stmt with flag param" do
      content = <<-EOB
      flag on;
      flag off;
      EOB

      result = @parser.parse_with_debug(content)

      assert_equal "flag", result[0][:statement][0][:command]
      assert_equal "on", result[0][:statement][1][:flag]
      assert_equal "off", result[1][:statement][1][:flag]
    end

    should "parse comment" do
      content = <<-EOB
      #error_log  logs/error.log;
      EOB

      result = @parser.parse_with_debug(content)

      assert_equal "#error_log  logs/error.log;", result[0][:comment]
    end

    should "parse block" do
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
end