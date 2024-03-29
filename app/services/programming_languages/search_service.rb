# frozen_string_literal: true

module ProgrammingLanguages
  class SearchService < ApplicationService
    def initialize(term)
      super()
      @term = term
      @language_list ||= ::ParseJsonService.call('data.json')
      @search_language_list ||= ::ParseJsonService.call('search_programming_language_list.json')
    end

    def call
      return [] if @language_list.nil? || @search_language_list.nil?
      return @language_list unless @term.present?

      language_indexes = find_languages(@term)

      @language_list.values_at(*language_indexes)
    end

    private

    def find_languages(term)
      prepared_terms = term.downcase.split

      normal_term_result = find_normal_term_result(prepared_terms)
      negative_result = find_negative_term_result(prepared_terms)

      normal_term_result ? (normal_term_result & negative_result) : negative_result
    end

    def find_normal_term_result(terms)
      normal_terms = terms.reject { |element| element =~ /^-/ } # Remove negative term

      normal_terms.map { |term| @search_language_list[term].nil? ? [] : @search_language_list[term] }.reduce(:&)
    end

    def find_negative_term_result(terms)
      all_languages_index = (0..@language_list.count - 1).to_a
      result = negative_terms(terms).map { |term| @search_language_list[term] }.flatten.uniq
      all_languages_index.reject { |element| result.include?(element) }
    end

    def negative_terms(terms)
      negative_terms = terms.select { |element| element =~ /^-/ } # choose only negative terms

      negative_terms.map { |element| element.sub(/^(-)/, '') } # remove '-' from terms
    end
  end
end
