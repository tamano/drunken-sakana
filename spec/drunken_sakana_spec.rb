require 'spec_helper'

describe DrunkenSakana do
  it 'has a version number' do
    expect(DrunkenSakana::VERSION).not_to be nil
  end

  describe '.parse' do
    context 'simple xml' do
      before :all do
        @xml = DrunkenSakana.parse('<root><key1>value1</key1></root>')
      end

      it "contains key1's content" do
        expect(@xml.key1.content).to eq('value1')
      end

      it "returns nil if key doesn't exists" do
        expect(@xml.key2).to be(nil)
      end
    end

    context 'simple xml with attributes' do
      before :all do
        @xml = DrunkenSakana.parse('<root><key1 attribute1="att1">value1</key1></root>')
      end

      it "contains key1's attrubute" do
        expect(@xml.key1.attribute1).to eq('att1')
      end

      it "contains key1's content" do
        expect(@xml.key1.content).to eq('value1')
      end

      it "returns nil if key or attribute doesn't exists" do
        expect(@xml.key2).to be(nil)
      end
    end

    context 'xml with multiple keys' do
      before :all do
        @xml = DrunkenSakana.parse('<root><key1>value1</key1><key1>value2</key1></root>')
      end

      it "contains key1's content as Array of DrunkenSakana::XmlObject" do
        # TODO: Split test cases
        expect(@xml.key1.is_a?(Array)).to be_truthy
        expect(@xml.key1[0].is_a?(DrunkenSakana::XmlObject)).to be_truthy
        expect(@xml.key1[0].content).to eq('value1')
        expect(@xml.key1[1].is_a?(DrunkenSakana::XmlObject)).to be_truthy
        expect(@xml.key1[1].content).to eq('value2')
      end
    end

    context 'xml with tree-structure keys' do
      before :all do
        @xml = DrunkenSakana.parse('<root><key1><subkey1>value1</subkey1></key1></root>')
      end

      it "contains subkey1's content as a child of key" do
        expect(@xml.key1.subkey1.content).to eq('value1')
      end

      it 'also accessable using .content to children of subkey1' do
        expect(@xml.key1.content.subkey1.content).to eq('value1')
      end
    end

    context 'xml with multiple keys with tree-structure keys' do
      before :all do
        @xml = DrunkenSakana.parse('<root><key1><subkey1>value1</subkey1><subkey1>value2</subkey1></key1></root>')
      end

      it "contains key1's child as Array of DrunkenSakana::XmlObject" do
        # TODO: Split test cases
        expect(@xml.key1.subkey1.is_a?(Array)).to be_truthy
        expect(@xml.key1.subkey1[0].is_a?(DrunkenSakana::XmlObject)).to be_truthy
        expect(@xml.key1.subkey1[0].content).to eq('value1')
        expect(@xml.key1.subkey1[1].is_a?(DrunkenSakana::XmlObject)).to be_truthy
        expect(@xml.key1.subkey1[1].content).to eq('value2')
      end
    end

    context 'xml without content' do
      before :all do
        @xml = DrunkenSakana.parse('<root><key1 attribute="attribute1" /></root>')
      end

      it "contains key1's attribute" do
        expect(@xml.key1.attribute).to eq('attribute1')
      end

      it 'returns nil if content is called' do
        expect(@xml.key1.content).to be_nil
      end
    end
  end

  describe '.find_by_content' do
    context 'simple xml' do
      before :all do
        text  = ''
        text += %(<root>                      )
        text += %(  <key attribute="att1">    )
        text += %(    value                   )
        text += %(  </key>                    )
        text += %(  <key attribute="att2">    )
        text += %(    value2                  )
        text += %(  </key>                    )
        text += %(  <key attribute="att3">    )
        text += %(    value                   )
        text += %(  </key>                    )
        text += %(</root>                     )
        @xml = DrunkenSakana.parse(text)
      end

      it 'returns Array of XmlObjects filterd by element value' do
        result = @xml.find_by_content('key', 'value')
        expect(result.size).to eq(2)
        expect(result[0].attribute).to eq('att1')
        expect(result[1].attribute).to eq('att3')
      end

      it 'returns empty Array if no result has found'
    end

    context 'simple xml with other element' do
      before :all do
        text  = ''
        text += %(<root>                      )
        text += %(  <target attribute="att1"> )
        text += %(    value                   )
        text += %(  </target>                 )
        text += %(  <dummy attribute="att2">  )
        text += %(    value                   )
        text += %(  </dummy>                  )
        text += %(</root>                     )
        @xml = DrunkenSakana.parse(text)
      end

      it 'returns Array of XmlObjects filterd by element value' do
        result = @xml.find_by_content('target', 'value')
        expect(result.size).to eq(1)
        expect(result[0].attribute).to eq('att1')
      end
    end

    context 'xml with tree-structure keys' do
      before :all do
        text  = ''
        text += %(<root>                      )
        text += %(  <key attribute="att1">    )
        text += %(    <subkey1>               )
        text += %(      value                 )
        text += %(    </subkey1>              )
        text += %(  </key>                    )
        text += %(  <key attribute="att2">    )
        text += %(    will not be found       )
        text += %(  </key>                    )
        text += %(  <key attribute="att3">    )
        text += %(    <subkey1>               )
        text += %(      value2                )
        text += %(    </subkey1>              )
        text += %(  </key>                    )
        text += %(  <key attribute="att4">    )
        text += %(    <subkey2>               )
        text += %(      value                 )
        text += %(    </subkey2>              )
        text += %(  </key>                    )
        text += %(  <key attribute="att5">    )
        text += %(    <subkey1>               )
        text += %(      value                 )
        text += %(    </subkey1>              )
        text += %(  </key>                    )
        text += %(</root>                     )
        @xml = DrunkenSakana.parse(text)
      end

      it 'returns Array of XmlObjects filterd by treed element value' do
        result = @xml.find_by_content('key.subkey1', 'value')
        expect(result.size).to eq(2)
        expect(result[0].attribute).to eq('att1')
        expect(result[1].attribute).to eq('att5')
      end
    end
  end

  describe '.find_by_attribute' do
    context 'simple xml' do
      before :all do
        text  = ''
        text += %(<root>                      )
        text += %(  <key attribute="att1">    )
        text += %(    value                   )
        text += %(  </key>                    )
        text += %(  <key attribute="att2">    )
        text += %(    value2                  )
        text += %(  </key>                    )
        text += %(  <key attribute="att3">    )
        text += %(    value                   )
        text += %(  </key>                    )
        text += %(</root>                     )
        @xml = DrunkenSakana.parse(text)
      end

      it 'returns Array of XmlObjects filterd by attribute value' do
        result = @xml.find_by_attribute('key.attribute', 'att2')
        expect(result.size).to eq(1)
        expect(result[0].content).to eq('value2')
      end

      it 'returns empty Array if no result has found'
    end

    context 'simple xml with other element' do
      before :all do
        text  = ''
        text += %(<root>                      )
        text += %(  <target attribute="att1"> )
        text += %(    value                   )
        text += %(  </target>                 )
        text += %(  <dummy attribute="att1">  )
        text += %(    value2                  )
        text += %(  </dummy>                  )
        text += %(</root>                     )
        @xml = DrunkenSakana.parse(text)
      end

      it 'returns Array of XmlObjects filterd by element value' do
        result = @xml.find_by_attribute('key.attribute', 'att1')
        expect(result.size).to eq(1)
        expect(result[0].content).to eq('value')
      end
    end

    context 'xml with tree-structure keys' do
      before :all do
        text  = ''
        text += %(<root>                      )
        text += %(  <key attribute="att1">    )
        text += %(    <subkey1 subatt="x1">   )
        text += %(      value                 )
        text += %(    </subkey1>              )
        text += %(  </key>                    )
        text += %(  <key attribute="att2">    )
        text += %(    will not be found       )
        text += %(  </key>                    )
        text += %(  <key attribute="att3">    )
        text += %(    <subkey1 subatt="x3">   )
        text += %(      value2                )
        text += %(    </subkey1>              )
        text += %(  </key>                    )
        text += %(  <key attribute="att4">    )
        text += %(    <subkey2 subatt="x1">   )
        text += %(      value                 )
        text += %(    </subkey2>              )
        text += %(  </key>                    )
        text += %(  <key attribute="att5">    )
        text += %(    <subkey1 subatt="x1">   )
        text += %(      value                 )
        text += %(    </subkey1>              )
        text += %(  </key>                    )
        text += %(</root>                     )
        @xml = DrunkenSakana.parse(text)
      end

      it 'returns Array of XmlObjects filterd by treed element value' do
        result = @xml.find_by_attribute('key.subkey1.subatt', 'x1')
        expect(result.size).to eq(2)
        expect(result[0].attribute).to eq('att1')
        expect(result[1].attribute).to eq('att5')
      end
    end
  end
end
