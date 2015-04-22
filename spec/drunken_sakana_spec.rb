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

      it 'contains key1 as attribute' do
        expect(@xml.key1).to eq('value1')
      end

      it "returns nil if attribute doesn't exists" do
        expect(@xml.key2).to be(nil)
      end
    end

    context 'xml with multiple keys' do
      before :all do
        @xml = DrunkenSakana.parse('<root><key1>value1</key1><key1>value2</key1></root>')
      end

      it 'contains key1 as Array of Strings' do
        expect(@xml.key1).to eq(['value1', 'value2'])
      end
    end

    context 'xml with tree-structure keys' do
      before :all do
        @xml = DrunkenSakana.parse('<root><key1><subkey1>value1</subkey1></key1></root>')
      end

      it 'contains key1.subkey1 as a String value' do
        expect(@xml.key1.subkey1).to eq('value1')
      end
    end

    context 'xml with multiple keys with tree-structure keys' do
      before :all do
        @xml = DrunkenSakana.parse('<root><key1><subkey1>value1</subkey1><subkey1>value2</subkey1></key1></root>')
      end

      it 'contains key1.subkey1[1] as a String value' do
        expect(@xml.key1.subkey1[1]).to eq('value2')
      end
    end

    context 'xml with attribute' do
      before :all do
        @xml = DrunkenSakana.parse('<root><key1 attribute="attribute1">value1</key1></root>')
      end

      it 'contains key1.attribute as a String value' do
        expect(@xml.key1.attribute).to eq('attribute1')
      end
    end
  end

  describe '.find' do
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
        result = @xml.find('key', 'value')
        expect(result.size).to eq(2)
        expect(result[0].attribute).to eq('att1')
        expect(result[1].attribute).to eq('att3')
      end

      it 'returns Array of XmlObjects filterd by attribute value' do
        result = @xml.find('attribute', 'att2')
        expect(result.size).to eq(1)
        expect(result[0]).to eq('value2')
      end

      it 'returns empty Array if no result has found'
    end

    context 'simple xml with other element' do
      before :all do
        text  = ''
        text += %(<root>                      )
        text += %(  <target attribute="att1"> )
        text += %(    value                   )
        text += %(  </key>                    )
        text += %(  <dummy attribute="att1">  )
        text += %(    value                   )
        text += %(  </key>                    )
        text += %(</root>                     )
        @xml = DrunkenSakana.parse(text)
      end

      it 'returns Array of XmlObjects filterd by element value' do
        result = @xml.find('target', 'value')
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
        result = @xml.find('key.subkey1', 'value')
        expect(result.size).to eq(2)
        expect(result[0].attribute).to eq('att1')
        expect(result[1].attribute).to eq('att5')
      end
    end


  end
end
