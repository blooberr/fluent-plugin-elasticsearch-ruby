require 'rubygems'
require 'bundler'
gem 'test-unit'
require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'fluent/test'

require 'fluent/plugin/out_elasticsearch'

class Test::Unit::TestCase
end

