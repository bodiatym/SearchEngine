require 'ostruct'
class ProgrammingLanguagesController < ApplicationController
  def index
    @languages_hash = ::ProgrammingLanguages::SearchService.call(params[:search])
  end
end
