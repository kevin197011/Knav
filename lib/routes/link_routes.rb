# Copyright (c) 2025 kk
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

require 'sinatra/base'

module Routes
  class LinkRoutes < Sinatra::Base
    set :views, File.join(File.dirname(__FILE__), '..', 'views')
    helpers Helpers::AuthHelper
    helpers Helpers::UrlHelper

    get '/admin/links' do
      require_admin
      page = (params[:page] || 1).to_i
      per_page = (params[:per_page] || 10).to_i
      category_filter = params[:category]
      result = Models::NavLink.all_with_pagination(page, per_page, category_filter)
      @links = result[:links]
      @pagination = result[:pagination]
      @categories = Models::Category.all
      @base_url = get_base_url
      erb :admin_links, layout: :admin_layout
    end

    post '/admin/links' do
      require_admin
      if request.content_type&.include?('application/json')
        request.body.rewind
        data = JSON.parse(request.body.read)
        title = data['title']
        url = data['url']
        description = data['description']
        category_id = data['category_id'].to_i
        icon = data['icon']
        sort_order = data['sort_order'].to_i
        is_active = data['is_active'] == 1 ? 1 : 0
        result = Controllers::AdminController.create_link(title, url, description, category_id, icon, sort_order,
                                                          is_active)
        content_type :json
        result.to_json
      else
        title = params[:title]
        url = params[:url]
        description = params[:description]
        category_id = params[:category_id].to_i
        icon = params[:icon]
        sort_order = params[:sort_order].to_i
        is_active = params[:is_active] == 'on' ? 1 : 0
        Controllers::AdminController.create_link(title, url, description, category_id, icon, sort_order, is_active)
        redirect '/admin/links'
      end
    end

    put '/admin/links/:id' do
      require_admin
      id = params[:id].to_i
      request.body.rewind
      data = JSON.parse(request.body.read)
      title = data['title']
      url = data['url']
      description = data['description']
      category_id = data['category_id'].to_i
      icon = data['icon']
      sort_order = data['sort_order'].to_i
              is_active = data['is_active'] == 1 ? 1 : 0
      result = Controllers::AdminController.update_link(id, title, url, description, category_id, icon, sort_order,
                                                        is_active)
      content_type :json
      result.to_json
    end

    delete '/admin/links/:id' do
      require_admin
      id = params[:id].to_i
      result = Controllers::AdminController.delete_link(id)
      content_type :json
      result.to_json
    end

    put '/admin/links/:id/toggle' do
      require_admin
      id = params[:id].to_i

      # Get current link status
      link = Models::NavLink.find_by_id(id)
      return { success: false, error: '链接不存在' }.to_json unless link

      # Toggle the status (1 -> 0, 0 -> 1)
      current_status = link[6] # is_active column
      new_status = current_status == 1 ? 0 : 1

      result = Controllers::AdminController.toggle_link_active(id, new_status)
      content_type :json
      result.to_json
    end
  end
end
