require "test/unit"
$:.unshift File.dirname(__FILE__) + "/.."

warn( File.dirname(__FILE__) + "/.." )

require 'lib/utils'

class TestUtils < Test::Unit::TestCase

  def test_simple
    s = '24 "002" "Some text"'
    assert_equal ["24", "\"002\"", "\"Some text\""], string_to_args(s)
  end

  def test_number_strings
    s = '003 "002" "Some text"'
    assert_equal [ '003', "\"002\"", "\"Some text\""], string_to_args(s)
  end

  def test_number_strings_to_args
    s = '003 "002" "Some text"'
    assert_equal [3, "002", "Some text"], string_to_args(s).map { |a| arg_to_type a }
  end

end
