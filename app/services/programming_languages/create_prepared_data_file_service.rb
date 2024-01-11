# frozen_string_literal: true

module ProgrammingLanguages
  class CreatePreparedDataFileService < ApplicationService
    def call
      programming_languages = ::ParseJsonService.call('data.json')
      return if programming_languages.nil?
      create_file_with_data(prepare_data(programming_languages))
    end

    private

    def prepare_data(programming_languages)
      prepared_data = {}

      programming_languages.each_with_index do |language, index|
        language_info = language.fetch_values('Name', 'Type', 'Designed by').join(', ').downcase
        add_words_to_data(prepared_data, language_info, index)
      end

      prepared_data
    end

    def add_words_to_data(hash, language_info, index)
      language_info.split(/,\s*|\s+/).each do |word|
        add_value(hash, word, index)
      end
    end

    def create_file_with_data(data)
      File.open('search_programming_language_list.json', 'w') do |f|
        f.write(data.to_json)
      end
    end

    def add_value(hash, key, value)
      hash[key] ||= []
      hash[key] << value unless hash[key].include?(value)
    end
  end
end
