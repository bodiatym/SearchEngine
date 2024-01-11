# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProgrammingLanguages::SearchService do
  subject(:service) { described_class.call(term) }

  let(:language_list) { ::ParseJsonService.call('data.json') }

  context 'when no term in field' do
    let(:term) { '' }

    it 'returns all languages' do
      expect(service).to eq(language_list)
    end
  end

  context 'when term is not valid' do
    let(:term) { 'остілвостш3в39вцsjs?? john -array' }

    it "returns 'Common Lisp'" do
      expect(service).to eq([])
    end
  end

  context 'when only negative term' do
    let(:term) { "-#{language_list[0]['Name']}" }

    it "returns 'Common Lisp'" do
      list_without_first_elem = language_list.drop(1)

      expect(service).to eq(list_without_first_elem)
    end
  end

  context 'when negative term with normal term' do
    let(:term) { 'john -array' }

    it 'returns 4 results' do
      expect(service.count).to eq(4)
    end

    it "returns 'BASIC', 'Haskell', 'Lisp' and 'S-Lang'" do
      expect(service.find { |lang| lang['Name'] == 'BASIC' }).not_to be_nil
    end

    it "returns 'Haskell'" do
      expect(service.find { |lang| lang['Name'] == 'Haskell' }).not_to be_nil
    end

    it "returns 'Lisp'" do
      expect(service.find { |lang| lang['Name'] == 'Lisp' }).not_to be_nil
    end

    it "returns 'S-Lang'" do
      expect(service.find { |lang| lang['Name'] == 'S-Lang' }).not_to be_nil
    end
  end

  context "when term is 'Lisp Common'" do
    let(:term) { 'Lisp Common' }

    it "returns 'Common Lisp'" do
      expect(service[0]['Name']).to eq('Common Lisp')
    end
  end

  context "when term is 'Thomas Eugene'" do
    let(:term) { 'Thomas Eugene' }

    it "returns 'Basic'" do
      expect(service[0]['Name']).to eq('BASIC')
    end

    it 'returns one result' do
      expect(service.count).to eq(1)
    end
  end
end
