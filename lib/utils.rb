require 'socket'

class String
  def to_bool
    self.to_i == 0 ? 0 : 1
  end
end

class Fixnum
  def to_bool
    self == 0 ? 0 : 1
  end
end

class Float
  def to_bool
    self.to_f == 0.0  ? 0 : 1
  end
end

module Utils
  # The idea is to take a string and convert it into an array of message arguments
  # The method needs to carefully split based on how text is presented.
  # Numbers are easy, but text strings must be identified by the use
  # of quotation marks. To do this the method needs to walk through the characters
  # and use a flag to track when it is looking inside some quoted text

  # A problem sems ot be how to create an array to return that is able to disinguish string-strings from
  # number string.  Right now, everything comes back as text, but some of that text is just
  # a text representatoin of a number, other text is actual String values
  def string_to_args  s = nil
    warn " --- string_to_args has #{s.inspect}"

    return [] unless s

    in_text = false
    args_ary = [ "" ] 

    args_ary_size = args_ary.size;

    s.split(//).each do  |letter|
      if letter == '"' 
        in_text = !in_text
        args_ary_size = args_ary.length;

     # Leave out adding the quote character since we're dealing withal strings anyways
        args_ary[args_ary_size-1] <<  letter

      else 
        if  letter == ' '  && !in_text 
          unless args_ary[args_ary.length-1] == ""
          args_ary <<  ""
          end
        else 
          args_ary_size = args_ary.length
          args_ary[args_ary_size-1] <<  letter;
        end
      end

    end 
    args_ary
  end 


  def arg_to_type a
# This is broken if you are trying to send quoted numbers as text: "002", for example
    # Also broken: sending boolean values.
    
    warn "---- arg_to_type has '#{a}'"
    
    return true if a =~ /^b:T$/ 
    return false if a =~ /^b:F$/ 
           
    warn "Not a boolean. See what else it is ..."
    if a =~ /^"/ &&  a =~ /"$/ 
      #It is a forced string; a string that has quotation marks  on each end.  Remove them
      a.sub! /^"/, ''
      a.sub! /"$/, ''
      return a
    end

    
    if a =~ /\d\.\d/ 
      if a.to_f == 0.0
        if a == '0'
          0
        elsif a == '0.0'
          0.0
        end
      else
        a.to_f
      end
    else
      if a == '0'
        0
      elsif a.to_i != 0 
        a.to_i
      else
        a 
      end
    end
  end


  def config
    @config
  end

  def config= cfg
    @config = cfg
  end


  def local_ip config='config.yaml'

    return @local_ip if  @local_ip 

    load_config 

    target = `hostname`.strip
    key  = "#{target}_ip".intern

    @local_ip = @config[key]

    if @local_ip 
      return @local_ip 
    end

    warn "Need to deduce IP ..."

    # We need to use an external site or we may get an IP address that works
    # local-only.  For example, if you have  a fixed IP address on a LAN card and DHCP
    # on wlan, and disconnect the network cable but do not disable the LAN card
    # Plus, if you have no 'Net connection then this will fail, which is probably
    # what you want though it's hacky
    #
    target  = 'google.com' # '64.233.187.99' #google

    # turn off reverse DNS resolution 
    bdns, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true 

    UDPSocket.open do |s| 
      s.connect target, 8000 
      warn s.addr.inspect
      @local_ip = s.addr.last 
    end 
  ensure 
    # restore DNS resolution 
    Socket.do_not_reverse_lookup = bdns 
  end 


end

