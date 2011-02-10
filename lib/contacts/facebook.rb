require 'mini_fb'

class Contacts
  class Facebook < Base

    def contacts
      return @contacts if @contacts
    end


    def real_connect
      f = MiniFB.get(@password, @login, :type => "friends")
      raise "Didn't find users" unless f.data
      @contacts = f.data.map do |hashie| hashie.values end
    rescue Exception => e
      raise AuthenticationError, "Facebook authentication failed"
    end
  end
  TYPES[:facebook] = Facebook
end
