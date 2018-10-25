#!/usr/bin/env ruby

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