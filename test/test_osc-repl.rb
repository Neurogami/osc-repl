require "test/unit"
$:.unshift File.dirname(__FILE__) + "/.."

warn( File.dirname(__FILE__) + "/.." )

require 'lib/utils'

class TestUtils < Test::Unit::TestCase

  include Utils

  def test_simple
    s = '24 "Some text"'
    assert_equal ["24", "Some text"], string_to_args(s)
  end

end
