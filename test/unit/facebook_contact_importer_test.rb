dir = File.dirname(__FILE__)
require File.join(".", dir, "..", "test_helper.rb")
require 'contacts'

class FacebookContactImporterTest < ContactImporterTestCase
  def setup
    super
    @account = TestAccounts[:facebook]
  end

  def test_successful_login
    Contacts.new(:facebook, @account.username, @account.password, "", {:app_id => @account.app_id, :app_secret => @account.app_secret})
  end

  def test_importer_fails_with_invalid_password
    assert_raise(Contacts::AuthenticationError) do
      Contacts.new(:facebook, @account.username, "wrong_password", "", {:app_id => @account.app_id, :app_secret => @account.app_secret})
    end
  end

  def test_importer_fails_with_blank_password
    assert_raise(Contacts::AuthenticationError) do
      Contacts.new(:facebook, @account.username, "", "", {:app_id => @account.app_id, :app_secret => @account.app_secret})
    end
  end

  def test_importer_fails_with_blank_username
    assert_raise(Contacts::AuthenticationError) do
      Contacts.new(:facebook, "", @account.password, "", {:app_id => @account.app_id, :app_secret => @account.app_secret})
    end
  end

  def test_fetch_contacts
    contacts = Contacts.new(:facebook, @account.username, @account.password, "", {:app_id => @account.app_id, :app_secret => @account.app_secret}).contacts
    @account.contacts.each do |contact|
      assert contacts.include?(contact), "Could not find: #{contact.inspect} in #{contacts.inspect}"
    end
  end
end
