require 'spec_helper'

describe DrunkenSakana do
  it 'has a version number' do
    expect(DrunkenSakana::VERSION).not_to be nil
  end

  describe '#parse' do
    context 'simple xml' do
      before :all do
        @xml = DrunkenSakana.parse('<key1>value1</key1>')
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
        @xml = DrunkenSakana.parse('<key1>value1</key1><key1>value2</key1>')
      end

      it 'contains key1 as Array of Strings' do
        expect(@xml.key1).to eq(['value1', 'value2'])
      end
    end

    context 'xml with tree keys' do
      before :all do
        @xml = DrunkenSakana.parse('<key1><subkey1>value1</subkey1></key1>')
      end

      it 'contains key1.subkey1 as a String value' do
        expect(@xml.key1.subkey1).to eq('value1')
      end
    end
  end
end
