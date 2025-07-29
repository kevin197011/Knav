# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require 'sinatra/base'

module Routes
  class MainRoutes < Sinatra::Base
    set :views, File.join(File.dirname(__FILE__), '..', 'views')
    helpers Helpers::UrlHelper

    get '/' do
      @categories = Models::Category.with_links
      @base_url = get_base_url
      erb :index
    end

    get '/test-url' do
      content_type :json
      {
        base_url: get_base_url,
        scheme: request.scheme,
        host: request.host,
        port: request.port,
        request_url: request.url
      }.to_json
    end
  end
end
