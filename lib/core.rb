warn "Loading #{__FILE__}"

require 'yaml'
require 'osc-ruby'
require 'utils'
require "readline"


module Neurogami
  module OscRepl


    class Core
      include  OSC
      include Utils


      DEFAULT_CONFIG = '.osc-config.yaml'

      def self.help
        puts "\tUsage:"
        puts "\tWhen run with no arguments the program expects to find the config file #{DEFAULT_CONFIG} in the current directory."
        puts "\tWhen run with an argument the program expects that you have given it the complete path to a config file."
        puts "\tThe config file must be a YAML file with at least two keys."
        puts "\t\t:address: <the OSC server IP address>"
        puts "\t\t:port <the OSC server port number>"
        puts "\n\t Enjoy!"
      end

      def initialize config_file_path=nil,  initial_messages=nil
 
        config_file = config_file_path || Dir.pwd + '/' + DEFAULT_CONFIG 

        @config = load_config config_file 

        unless @config
          warn '*'*80
          warn "\tCannot get configuration data, so we're out of here.\n\tCheck your config file and try again."
          warn '*'*80
          exit
        end

        warn "@config  #{@config }"

        if @config[:initial_messages]
          warn "@config[:initial_messages] = #{@config[:initial_messages].inspect}"
            initial_messages ||= []
            initial_messages.concat @config[:initial_messages].map{|m| "#{m},"}
        end
        
        if initial_messages 
           @initial_messages = initial_messages.join ' '
        end

        warn "@initial_messages : #{@initial_messages.inspect }"
        
        @client = OSC::Client.new @config[:address], @config[:port]

      end

      def quit? s
        s.strip =~ /^q$/i
      end


      def run
        quit = nil 

        ARGV.clear

        initial_message = nil

        # We allow the user to provide a set of message to prepopulate the REPL history
        if @initial_messages  
            @initial_messages.split(',').reverse.each do |m|
              m.strip!
               Readline::HISTORY.push m 
               initial_message = m
            end
            puts "*** Use the arrow keys to pull up your pre-loaded messages. ***\n"
        end


        while buf = Readline.readline( "> ", !quit)
          print "-] ", buf, "\n"
          puts buf  
          message = buf.to_s.strip
          if quit? message
            puts "Received the 'quit' command.  See you later!"
            exit
          else
            send message unless message.empty?
          end
        end
      end


      def send s
        message, s = *(s.split /\s/, 2)

        args = string_to_args s
        args.map! { |a| arg_to_type a }

        msg = OSC::Message.new message, *args  

        t = Thread.new do
          begin
            @client.send msg
          rescue 
            warn '!'*80
            warn "Error sending OSC message: #{$!}"
            warn '!'*80
          end
        end

        t.join
        sleep 0.02

      end


      def load_config config_file
        warn "Look for '#{config_file}' in #{@working_dir}"
        unless File.exist? config_file
          warn "Cannot find config file '#{config_file}'"
          return nil
        end
        begin 
          YAML.load_file config_file
        rescue
          warn "There was an exception loading config file '#{config_file}': #{$!}"
          return nil
        end
      end
    end
  end
end
