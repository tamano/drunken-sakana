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
    it 'returns Array of XmlObjects filterd by parameters'
    it 'returns empty Array if no result has found'
  end
end
