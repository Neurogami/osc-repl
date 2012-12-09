osc-repl
=========

A REPL for sending OSC messages to some configured server.

This is a command-line app.  When you start it you can optionally provide the path to a config file, as well some OSC messages to pre-populate the Readline history of the REPL.


If you omit any arguments it assumes there is a file named '.osc-config.yaml' in the current directory.

If you want to pass in a set of OSC messages to stash in Readline history then the first argument must be the path of the config file and then each OSC message must be separated by a comma.

For example:


    osc-repl 

    osc-repl /home/james/.my-global-osc-conf.yaml

    osc-repl .osc-config.yaml /renoise/transport/start, /renoise/transport/stop,  /renoise/song/bpm 90 , /renoise/trigger/note_on 1 2 13 125


You can omit the full path if the config file is in the current working directory.


The config file must be a YAML file that has at least two keys:

    :address: <IP address of OSC server>
    :port: <port number of OSC server>


The program runs in a loop.  You enter the OSC address pattern and args (if any) to send and hit Enter.

Once the app is running it never reload the config file.


The apps sends the OSC message and awaits the next command.


You can send integers, floats, and strings. Sorry, no OSC blob support. Or that OSC time-stamp thing either. As a practical matter, anecdotal experience says that 99% of the OSC use case will involve floats, and maybe integers.

You need to quote any string arguments using the double-quotes character.  Numbers should be auto-recognized.

For example:


    /renoise/transport/start
    
    /renoise/song/bpm  124

    /some/other/messsage 123 14.14 "This is some text"

Do not use commas to separate the arguments.  They might work, or they might confuse the simple arguments parser in the app.

The app uses the `readline` lib so you can use the arrow keys to recall previous commands. 

Enter 'q' or 'Q' to quit.

The app does not yet show any replies sent back from the OSC server.

This program is something of a variation of the OSC Commander created for the book [Just the Best Parts: OSC for Artists](http://osc.justthebestparts.com).  That version is written in Processing, uses a GUI, and has a few more features.

This Ruby version is easier in many ways, not the least being that you can just invoke it from the command line to quickly send some OSC messages, and the Readline support makes it quick and easy to recall and edit or reuse previous commands.


Features
--------

* Loads config file only once
* Stays resident and provides a REPL
* Auto-parses your arguments
* Simple


Requirements
------------

* Ruby, osc-ruby gem

Install
-------

    gem i osc-repl --source http://gems.neurogami.com

Author
------

Original author: James Britt <james@neurogami.com>


License
-------

The MIT License


Copyright (c) 2012 James Britt / Neurogami

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Feed your head

Hack your world

Live curious
