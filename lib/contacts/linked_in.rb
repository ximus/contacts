begin
  require 'oauth'
rescue LoadError
  puts "No oauth gem, so no linked_in"
else
  class Contacts
    class LinkedIn < Base

      def contacts
        return @contacts if @contacts
      end


      def real_connect
        consumer = OAuth::Consumer.new(@options[:app_id], @options[:app_secret])
        access_token = OAuth::AccessToken.new(consumer, @login, @password)
        raw_connections = access_token.get("http://api.linkedin.com/v1/people/~/connections", 'x-li-format' => 'json').body
        parsed_connections = JSON.parse(raw_connections)
        raise "Didn't find users" unless parsed_connections["values"] && parsed_connections["values"].count > 0
        contacts = parsed_connections["values"]

        @contacts = contacts.map do |contact|
          ["#{contact["firstName"]} #{contact["lastName"]}", contact["id"]]
        end
      rescue Exception => e
        raise AuthenticationError, "linked_in authentication failed"
      end
    end
    TYPES[:linked_in] = LinkedIn 
  end
end
