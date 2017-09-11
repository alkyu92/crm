class SearchController < ApplicationController
  def search
    if params[:term].nil?
      @results = []
    else
      @results = Elasticsearch::Model.search(params[:term],
      [
        Account,
        Contact,
        Opportunity,
        Task,
        Call,
        Event,
        Stage,
        User
        ])
    end
  end
end
