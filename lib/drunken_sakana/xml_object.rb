# Define XmlObject class
class DrunkenSakana::XmlObject
  @hash = nil

  def initialize(hash)
    @hash = hash
  end

  def method_missing(name)
    target_value = @hash[name.to_s]
    # no element or attribute
    return nil unless target_value

    # attribute
    return target_value if target_value.is_a?(String)

    # element
    result = []
    target_value.each do |value|
      if value.is_a?(String)
        result << value
      else
        result << DrunkenSakana::XmlObject.new(value)
      end
    end

    (result.size == 1) ? result[0] : result
  end
end
