# frozen_string_literal: true

module JapaneseNames
  module Backend
    module Memory
      # In-memory store of the Enamdict dictionary
      class Store
        class << self
          # Public: Finds kanji and/or kana regex strings in the dictionary via
          # a structured query interface.
          #
          # kanji - (String, Array) Value or array of values of the kanji name to match.
          #
          # Returns the dict entries as an Array of Arrays [[kanji, kana, flags], ...]
          def find(params)
            kanji = params[:kanji]
            kana  = params[:kana]
            flags = params[:flags]
            flags = flags.split(',').map(&:strip).sort.join(',') if flags

            result = []
            store.each do |line|
              line_flags = parse_line_flags(line)
              if kanji && kana && flags
                result << line if line.include?(kanji) && line.include?(kana) && line_flags == flags
              elsif kanji && kana
                result << line if line.include?(kanji) && line.include?(kana)
              elsif kana && flags
                result << line if line.include?(kana) && line_flags == flags
              elsif kanji && flags
                result << line if line.include?(kanji) && line_flags == flags
              elsif kanji
                result << line if line.include?(kanji)
              elsif kana
                result << line if line.include?(kana)
              end
            end
            result
          end

          def find_by_kanji(kanji)
            find(kanji: kanji)
          end

          def find_by_kana(kana)
            find(kana: kana)
          end

          # Public: The memoized dictionary instance.
          def store
            @store ||= JapaneseNames::Util::Kernel.deep_freeze(
              File.open(filepath, 'r:utf-8').map do |line|
                line.chop.split('|')
              end
            )
          end

          private

          # Internal: Returns the filepath to the enamdict.min file.
          def filepath
            File.join(JapaneseNames.root, 'bin/enamdict.min')
          end

          def parse_line_flags(line)
            if line[2].include?(',')
              line[2].split(',').map(&:strip).sort.join(',')
            else
              line[2]
            end
          end
        end
      end
    end
  end
end
