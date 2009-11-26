require 'rubygems'
require 'activerecord'
require 'action_controller'
require 'action_controller/test_process'
require File.dirname(__FILE__)+'/../lib/require_permissions'
require 'shoulda'
require 'logger'
require 'mocha'
require 'matchy'


ActiveRecord::Base.configurations = {'sqlite3' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('sqlite3')

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = Logger::WARN
