# Define XmlObject class
class DrunkenSakana::XmlObject
  attr_accessor :hash_value

  def initialize(hash)
    @hash_value = hash
  end

  # return value of this object
  def content
    result = []

    return @hash_value if @hash_value.is_a?(String)

    @hash_value.each do |key, value|
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

  # to solve messeges to attribute
  def method_missing(name)
    target_value = @hash_value[name.to_s]
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

  def find_by_content(path, comparation)
    dig_element(path.split('.'), comparation).map {|v| DrunkenSakana::XmlObject.new(v) }
  end

  protected

  def dig_element(path_array, comparation)
    key_name = path_array[0]

    if key_name.nil?
      return (self.content == comparation) ? self.hash_value : nil
    end

    subject = send(key_name)
    recursive_path = path_array.drop(1)

    return nil if subject.nil?

    result = []

    if subject.is_a?(Array)
      subject.each do |v|
        sub_result = v.dig_element(recursive_path, comparation)
        result << { key_name => [sub_result] } unless sub_result.nil?
      end
    else
      sub_result = subject.dig_element(recursive_path, comparation)
      result << { key_name => [sub_result] } unless sub_result.nil?
    end

    result
  end
end
