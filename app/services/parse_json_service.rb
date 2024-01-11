# frozen_string_literal: true

require 'json'

class ParseJsonService < ApplicationService
  attr_reader :file_path

  def initialize(file_path)
    super()
    @file_path = file_path
  end

  def call
    begin
      file = File.read(file_path)
    rescue Errno::ENOENT
      return nil
    end
    JSON.parse(file)
  end
end
