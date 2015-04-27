# Define XmlObject class
class DrunkenSakana::XmlObject
  @hash = nil

  def initialize(hash)
    @hash = hash
  end

  # return value of this object
  def content
    result = []

    return @hash if @hash.is_a?(String)

    @hash.each do |key, value|
      if key == 'content'
        return value
      elsif value.is_a?(Array)
        result << DrunkenSakana::XmlObject.new(key => value)
      end
    end

    return nil if result.size == 0
    return result[0] if result.size == 1
    result
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
      result << DrunkenSakana::XmlObject.new(value)
    end

    (result.size == 1) ? result[0] : result
  end
end
