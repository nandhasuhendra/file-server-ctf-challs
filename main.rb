#!/usr/bin/env ruby

require 'socket'
require 'zip'
require 'nokogiri'
require 'active_support'
require 'active_support/dependencies'

relative_load_paths = %w[app]
ActiveSupport::Dependencies.autoload_paths += relative_load_paths


if __FILE__ == $0
  
  begin
    server = Libs::Server.new(31337)
  rescue => e
    puts e
  end
end