require 'linkedin'
require 'ruby-debug'
class Contacts
  class LinkedIn < Base

    def contacts
      return @contacts if @contacts
    end


    def real_connect
      client = ::LinkedIn::Client.new(@options[:app_id], @options[:app_secret])
      client.authorize_from_access(@login, @password)
      contacts = client.connections
      raise "Didn't find users" unless contacts 

      @contacts = contacts.map do |contact|
        ["#{contact.first_name} #{contact.last_name}", contact.id]
      end
    rescue Exception => e
      raise AuthenticationError, "linked_in authentication failed"
    end
  end
  TYPES[:linked_in] = LinkedIn 
end
