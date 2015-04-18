# Define XmlObject class
class DrunkenSakana::XmlObject
  @hash = nil

  def initialize(hash)
    @hash = hash
  end

  def method_missing(name)
    return nil unless @hash[name.to_s]

    result = []
    @hash[name.to_s].each do |value|
      if value.is_a?(String)
        result << value
      else
        result << DrunkenSakana::XmlObject.new(value)
      end
    end

    (result.size == 1) ? result[0] : result
  end
end
