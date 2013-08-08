require "test/unit"
$:.unshift File.dirname(__FILE__) + "/.."

warn( File.dirname(__FILE__) + "/.." )


require 'lib/utils'

class TestUtils < Test::Unit::TestCase
 include Utils

 def sample_config
   'sample-config.yaml'
 end
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

  def test_loading_sample_config
     require 'yaml'

     config = YAML.load_file sample_config
     assert_equal config[:initial_messages].size, 6

# Check  that we can create a bundle from messages grouped using '|'

     bundle_string = config[:initial_messages].last
     assert ( bundle_string =~ /\|/), "String must contain a pipe" 
 
     root = File.expand_path('../..', __FILE__)
require File.join(root, %w[lib osc-repl])
require File.join(root, %w[lib core])

     oscr = Neurogami::OscRepl::Core.new sample_config

     b = oscr.string_to_bundle bundle_string 
     assert_equal b.class, OSC::Bundle
    
  end

end
