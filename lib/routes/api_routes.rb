# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require 'sinatra/base'

module Routes
  class ApiRoutes < Sinatra::Base
    get '/api/search/suggestions' do
      content_type :json
      query = params[:q]
      limit = (params[:limit] || 10).to_i
      result = Controllers::ApiController.search_suggestions(query, limit)
      result.to_json
    end
  end
end
