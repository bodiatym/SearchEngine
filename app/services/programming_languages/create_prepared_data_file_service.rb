# frozen_string_literal: true

module ProgrammingLanguages
  class CreatePreparedDataFileService < ApplicationService
    def call
      programming_languages = ::ParseJsonService.call('data.json')
      prepare_data(programming_languages)
      create_new_file_with_prepared_data
    end

    private

    def prepare_data(programming_languages)
      @prepared_data = {}

      programming_languages.each_with_index do |language, index|
        language_info = language.fetch_values('Name', 'Type', 'Designed by').join(', ').downcase
        language_info.split(/,\s*/).each { |word| add_value(@prepared_data, word, index) }
        if language_info.split(/,\s*|\s+/).count > 1
          language_info.split(/,\s*|\s+/).each { |word| add_value(@prepared_data, word, index) }
        end
      end

      @prepared_data
    end

    def create_new_file_with_prepared_data
      File.open('search_programming_language_list.json', 'w') do |f|
        f.write(@prepared_data.to_json)
      end
    end

    def add_value(hash, key, value)
      hash[key] ||= []
      hash[key] << value unless hash[key].include?(value)
    end
  end
end
