require 'rubygems'
require 'bundler/setup'

Bundler.require(:default, :test) if defined?(Bundler)

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(dir + "/../lib/")
require 'test/unit'
require 'contacts'
require 'yaml'
require 'shoulda'

class ContactImporterTestCase < Test::Unit::TestCase
  # Add more helper methods to be used by all tests here...
  def default_test
    assert true
  end
end

class TestAccounts
  def self.[](type)
    load[type]
  end
  
  def self.load(file = File.dirname(__FILE__) + "/accounts.yml")
    raise "/test/accounts.yml file not found, please create, see /test/example_accounts.yml for information" unless File.exist?(file)
    
    accounts = {}
    YAML::load(File.open(file)).each do |type, contents|
      contacts = contents["contacts"].collect {|contact| [contact["name"], (contact["email_address"] || contact["account_id"])]} if contents["contacts"]
      accounts[type.to_sym] = Account.new(type.to_sym, contents["username"], contents["password"], contacts, contents["app_id"], contents["app_secret"])
    end
    accounts
  end

  Account = Struct.new :type, :username, :password, :contacts, :app_id, :app_secret
end
