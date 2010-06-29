class Contacts
  class Vcf < Base
    
    def initialize(file)
      @contact_file = File.open(file, "r")
    end
    
    def contacts
      contacts = Array.new
      i = 0
      @contact_file.each_line do |line|
        contacts[i] = Array.new unless contacts[i]
        if line.match(/FN:/)
          contacts[i] << line.gsub(/FN:/, '').strip
        elsif line.match(/EMAIL;/)
          contacts[i] << line.gsub(/^.*:/, '').strip
        elsif line.match(/END:VCARD/)
          i += 1
        end
      end
      contacts
    end
  end
  TYPES[:vcf] = Vcf
end