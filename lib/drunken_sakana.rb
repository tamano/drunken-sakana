require 'drunken_sakana/version'
require 'drunken_sakana/xml_object'

require 'xmlsimple'

# Object/XML Parser
module DrunkenSakana
  def self.parse(xml_text)
    hash = XmlSimple.xml_in(xml_text)
    DrunkenSakana::XmlObject.new(hash)
  end
end
