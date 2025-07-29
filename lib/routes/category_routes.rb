# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require 'sinatra/base'

module Routes
  class CategoryRoutes < Sinatra::Base
    set :views, File.join(File.dirname(__FILE__), '..', 'views')
    helpers Helpers::AuthHelper
    helpers Helpers::UrlHelper

    get '/admin/categories' do
      require_admin
      @categories = Models::Category.all
      @base_url = get_base_url
      erb :admin_categories, layout: :admin_layout
    end

    post '/admin/categories' do
      require_admin
      if request.content_type&.include?('application/json')
        request.body.rewind
        data = JSON.parse(request.body.read)
        name = data['name']
        description = data['description']
        sort_order = data['sort_order'].to_i
        result = Controllers::AdminController.create_category(name, description, sort_order)
        content_type :json
        result.to_json
      else
        name = params[:name]
        description = params[:description]
        sort_order = params[:sort_order].to_i
        Controllers::AdminController.create_category(name, description, sort_order)
        redirect '/admin/categories'
      end
    end

    put '/admin/categories/:id' do
      require_admin
      id = params[:id].to_i
      request.body.rewind
      data = JSON.parse(request.body.read)
      name = data['name']
      description = data['description']
      sort_order = data['sort_order'].to_i
      result = Controllers::AdminController.update_category(id, name, description, sort_order)
      content_type :json
      result.to_json
    end

    delete '/admin/categories/:id' do
      require_admin
      id = params[:id].to_i
      result = Controllers::AdminController.delete_category(id)
      content_type :json
      result.to_json
    end
  end
end
