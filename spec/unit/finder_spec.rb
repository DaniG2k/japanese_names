# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JapaneseNames::Finder do
  subject { described_class.new }

  describe '#find' do
    it 'finds kanji only' do
      result = subject.find(kanji: '外世子')
      expect(result).to eq [%w[外世子 とよこ f]]
    end

    it 'finds kana only' do
      result = subject.find(kana: 'きちゅう')
      expect(result).to eq [
        %w[基柱 きちゅう g],
        %w[紀中 きちゅう g]
      ]
    end

    it 'finds kanji, kana' do
      result = subject.find(kanji: '楢二郎', kana: 'ならじろう')
      expect(result).to eq [%w[楢二郎 ならじろう m]]
    end

    it 'finds kanji, flags' do
      result = subject.find(kanji: "楢島", flags: 's')
      expect(result).to eq [%w[楢島 ならしま s]]
    end

    it 'finds kana, flags' do
      result = subject.find(kana: "ならしま", flags: 's')
      expect(result).to eq [%w[奈良島 ならしま s],
                            %w[楢島 ならしま s],
                            %w[楢嶋 ならしま s]]
    end

    it 'finds kanji, kana, flags' do
      result = subject.find(kanji: "奈良島", kana: "ならしま", flags: 's')
      expect(result).to eq [%w[奈良島 ならしま s]]
    end
  end

  describe '#find_by_* matchers' do
    it '#find_by_kanji' do
      result = subject.find_by_kanji '外世子'
      expect(result).to eq [%w[外世子 とよこ f]]
    end

    it '#find_by_kana' do
      result = subject.find_by_kana 'ならじろう'
      expect(result).to eq [%w[楢二郎 ならじろう m]]
    end
  end
end
