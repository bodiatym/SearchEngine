# frozen_string_literal: true

module ProgrammingLanguages
  class SearchService < ApplicationService

    attr_reader :term

    def initialize(term)
      super()
      @term = term
      @language_list ||= ::ParseJsonService.call('data.json')
      @search_language_list ||= ::ParseJsonService.call('search_programming_language_list.json')
    end

    def call
      language_indexes = find_languages(@term)
      @language_list.values_at(*language_indexes)
    end

    private

    def find_languages(term)
      negative_term = []
      if term.present?
        term = term.downcase.split
        term_result = []
        negative_term = term.select { |element| element =~ /^-/ }
        right_term = term.reject { |element| element =~ /^-/ }

        right_term.each do |term|
          term_result << @search_language_list[term]
        end

        final_result = term_result.reduce(:&)
      end

      all_language_indexes = (0..@language_list.count - 1).to_a
      final_result = all_language_indexes if final_result.nil?

      if negative_term.present?
        negative_result = []
        negative_term = negative_term.map { |element| element.sub(/^(-)/, '') }
        negative_term.each do |term|
          negative_result << @search_language_list[term]
        end
        negative_result = negative_result.flatten.uniq
        final_result = final_result.reject { |element| negative_result.include?(element) }
      end

      final_result
    end
  end
end
