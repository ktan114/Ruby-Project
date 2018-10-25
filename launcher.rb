#!/usr/bin/env ruby
# Ruby does not automatically include current directory 
# on require look-up path, $:.unshift '.' takes the current folder and
# adds it to the start of the array of places your ruby app will
# look for files to require

$:.unshift '.'
require 'launcher'

# Script to invoke launcher using command-line args
def help
    print "
    You must pass in the path to the file to launch.
    
    Usage: #{__FILE__} target_file
    "
end

unless ARGV.size > 0
    help
    exit
end

app_map = {
    'html' => 'chromium-browser -new-window  --enable-plugins    --allow-outdated-plugins ',
    'rb' => 'gvim',
    'jpg' => 'gimp'
}

launcher = Launcher.new app_map
target = ARGV.join ' '
launcher.run target